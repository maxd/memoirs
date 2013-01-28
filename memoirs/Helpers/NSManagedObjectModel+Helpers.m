#import "NSManagedObjectModel+Helpers.h"

@implementation NSManagedObjectModel (Helpers)

+ (NSManagedObjectModel *)modelWithName:(NSString *)name {
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
    if (!modelPath) return nil;
    return [[self alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
}

@end
