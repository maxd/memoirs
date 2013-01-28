#import "NSManagedObject+Helpers.h"

@implementation NSManagedObject (Helpers)

+ (NSString *)entityName {
    return NSStringFromClass(self.class);
}

+ (NSFetchRequest *)request {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    req.sortDescriptors = [NSArray new];
    return req;
}

@end
