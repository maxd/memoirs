//
//  ValuesLoader.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/1/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "ValuesLoader.h"
#import "Value.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObject+Helpers.h"

#define IS_VALUES_LOADED_KEY @"isValuesLoaded"

@implementation ValuesLoader {
    NSManagedObjectContext *_context;
}

- (id)initWithManagedContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

- (void)loadPredefinedValuesIfRequired {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:IS_VALUES_LOADED_KEY]) {
        [self loadPredefinedValues];

        [userDefaults setBool:YES forKey:IS_VALUES_LOADED_KEY];
        [userDefaults synchronize];
    }
}

- (void)loadPredefinedValues {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"values" ofType:@"lst"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileContent componentsSeparatedByString:@"\n"];

    for (NSString *line in lines) {
        Value *value = [_context newObjectWithEntityName:[Value entityName]];
        value.title = line;
    }

    [_context save];
}

@end
