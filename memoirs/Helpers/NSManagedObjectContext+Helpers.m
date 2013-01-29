#import "NSManagedObjectContext+Helpers.h"

@implementation NSManagedObjectContext (Creation)

+ (NSManagedObjectContext *)managedContextWithModel:(NSManagedObjectModel *)model storageUrl:(NSURL *)storageUrl error:(NSError **)error {
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (!storeCoordinator) return nil;

    NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
    [pragmaOptions setObject:@"OFF" forKey:@"synchronous"];
    [pragmaOptions setObject:@"OFF" forKey:@"count_changes"];
    [pragmaOptions setObject:@"MEMORY" forKey:@"journal_mode"];
    [pragmaOptions setObject:@"MEMORY" forKey:@"temp_store"];
    [pragmaOptions setObject:@"4000" forKey:@"cache_size"];
    
    // BOOL values needed to migrate the database automatically when object model is changed
    NSDictionary *storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:pragmaOptions, NSSQLitePragmasOption,
                                                                            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                                                            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                                                            nil];

    NSPersistentStore *store = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storageUrl options:storeOptions error:error];
    if (!store) return nil;
    NSManagedObjectContext *dataCtx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    dataCtx.persistentStoreCoordinator = storeCoordinator;
    
    // Mark file as "do not back up" to exclude it from backup to iCloud
    // [storageUrl setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:error];
    
    return dataCtx;
}

- (NSManagedObjectModel *)model {
    return self.persistentStoreCoordinator.managedObjectModel;
}

- (id)newObjectWithEntityName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

- (NSFetchedResultsController *)resultsControllerForRequest:(NSFetchRequest *)req {
    return [self resultsControllerForRequest:req sectionNameKeyPath:nil cacheName:nil];
}

- (NSFetchedResultsController *)resultsControllerForRequest:(NSFetchRequest *)req sectionNameKeyPath:(NSString *)section {
    return [self resultsControllerForRequest:req sectionNameKeyPath:section cacheName:nil];
}

- (NSFetchedResultsController *)resultsControllerForRequest:(NSFetchRequest *)req sectionNameKeyPath:(NSString *)section cacheName:(NSString *)cache {
    return [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:self sectionNameKeyPath:section cacheName:cache];
}

- (NSArray *)objectsForRequest:(NSFetchRequest *)req {
    NSError *error;

    NSArray* result = [self executeFetchRequest:req error:&error];
    if (result == nil) {
        NSLog(@"Can't execute executeFetchRequest. Error: %@", error);
    }

    return result;
}

- (NSManagedObjectContext *)localContextWithMerge:(BOOL)needsMerge {
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    ctx.persistentStoreCoordinator = self.persistentStoreCoordinator;
    [ctx setUndoManager:nil];
    [ctx setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    if (needsMerge) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_childContextDidUpdate:) name:NSManagedObjectContextDidSaveNotification object:ctx];
    }
    return ctx;
}

- (void)_childContextDidUpdate:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mergeChangesFromContextDidSaveNotification:notification];
    });
}

- (NSArray *)objectsWithEntityName:(NSString *)name {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:name];
    return [self executeFetchRequest:req error:nil];    
}

- (void)removeObjectsWithEntityName:(NSString *)name batch:(NSUInteger)batch sleepTime:(double)time {
    NSUInteger count = 0;
    for (NSManagedObject *object in [self objectsWithEntityName:name]) {
        [self deleteObject:object];
        count++;
        if (count % batch == 0) {
            [self save];
            NSLog(@"%@ delete batch number: %d", name, count/batch);
        }
    }
}

- (BOOL)save {
    BOOL saved = NO;
    NSError *error = nil;
    @autoreleasepool {
        @try
        {
            saved = [self save:&error];
            if (!saved) {
                NSLog(@"Error saving context: %@", error);
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error saving context: %@", exception);
        }
    }
    return saved;
}

@end
