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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"values" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *valuesJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    for (NSDictionary *valueJson in valuesJson) {
        Value *value = [_context newObjectWithEntityName:[Value entityName]];
        value.title = valueJson[@"title"];
        value.text = valueJson[@"description"];
    }

    [_context save];
}

@end
