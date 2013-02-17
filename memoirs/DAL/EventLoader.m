//
//  EventLoader.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/10/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EventLoader.h"
#import "Event.h"
#import "NSManagedObjectContext+Helpers.h"
#import "AppModel.h"
#import "NSManagedObject+Helpers.h"
#import "Value.h"
#import "NSDate+MTDates.h"
#import "Underscore.h"

#define _ Underscore

#define IS_EVENTS_LOADED_KEY @"isEventsLoaded"

@implementation EventLoader {
    AppModel *_appModel;

    NSArray *_values;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
    }
    return self;
}

- (void)loadPredefinedEventsIfRequired {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:IS_EVENTS_LOADED_KEY]) {
        [self loadPredefinedEvents];

        [userDefaults setBool:YES forKey:IS_EVENTS_LOADED_KEY];
        [userDefaults synchronize];
    }
}

- (void)loadPredefinedEvents {
    NSFetchedResultsController *fetchedResultsController = [_appModel values];
    [fetchedResultsController performFetch:nil];
    _values = fetchedResultsController.fetchedObjects;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"predefined_events" ofType:@"lst"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileContent componentsSeparatedByString:@"\n"];

    NSDate *date = [[NSDate date] startOfCurrentWeek];

    for (NSUInteger i = 0; i < lines.count; i += 3) {
        NSString *valueTitle = lines[i];
        NSString *text = lines[i + 1];

        [self loadEventToDate:date withValue:valueTitle andText:text];
        date = [date startOfNextDay];
    }

    [_appModel.context save];
}

- (void)loadEventToDate:(NSDate *)date withValue:(NSString *)valueText andText:(NSString *)text {
    Event *event = [_appModel.context newObjectWithEntityName:[Event entityName]];
    event.date = date;
    event.value = _.array(_values).find(^BOOL(Value *v) {
        return [v.title isEqualToString:valueText];
    });
    event.text = text;
}

@end
