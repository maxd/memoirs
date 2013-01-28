#import <CoreData/CoreData.h>
#import "NSManagedObjectModel+Helpers.h"

@interface NSManagedObjectContext (Helpers)
@property (nonatomic, readonly) NSManagedObjectModel *model;

+ (NSManagedObjectContext *)managedContextWithModel:(NSManagedObjectModel *)model storageUrl:(NSURL *)storageUrl error:(NSError **)error;

- (id)newObjectWithEntityName:(NSString *)name;
- (NSArray*)objectsWithEntityName:(NSString *)name;
- (void)removeObjectsWithEntityName:(NSString *)name batch:(NSUInteger)batch sleepTime:(double)time;

- (NSFetchedResultsController *)resultsControllerForRequest:(NSFetchRequest *)req;
- (NSFetchedResultsController *)resultsControllerForRequest:(NSFetchRequest *)req sectionNameKeyPath:(NSString *)section;
- (NSFetchedResultsController *)resultsControllerForRequest:(NSFetchRequest *)req sectionNameKeyPath:(NSString *)section cacheName:(NSString *)cache;
 
- (NSArray *)objectsForRequest:(NSFetchRequest *)req withFetchedProperty:(NSString *)property;

- (NSManagedObjectContext *)localContextWithMerge:(BOOL)needsMerge;

- (BOOL)save;

@end
