#import <Foundation/Foundation.h>

@interface NSURL (Helpers)

+ (NSURL *)fileURLWithPathInBundle:(NSString *)path;
+ (NSURL *)fileURLWithPathInDocuments:(NSString *)path;
+ (NSURL *)fileURLWithPathInLibrary:(NSString *)path;
+ (BOOL)isFileExistsInLibrary:(NSString *)name;

@end
