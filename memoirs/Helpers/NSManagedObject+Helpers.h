#import <CoreData/CoreData.h>

@interface NSManagedObject (Helpers)

+ (NSString *)entityName;

+ (NSFetchRequest *)request;

@end
