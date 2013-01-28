#import "NSURL+Helpers.h"

@implementation NSURL (Helpers)

+ (NSURL *)fileURLWithPathInBundle:(NSString *)path {
    return [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path]];
}

+ (NSURL *)fileURLWithPathInDocuments:(NSString *)path {
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]];
}

+ (NSURL *)fileURLWithPathInLibrary:(NSString *)path {
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]];
}

+ (BOOL)isFileExistsInLibrary:(NSString *)name {
    return [[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]];
}

@end
