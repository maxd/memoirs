//
//  AppModel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/28/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "AppModel.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObject+Helpers.h"
#import "Event.h"
#import "Value.h"
#import "NSDate+MTDates.h"
#import "Underscore.h"

#define _ Underscore

@implementation AppModel

- (id)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];

    if (self) {
        _context = context;
    }

    return self;
}

- (NSArray *)eventsBetween:(NSDate *)from and:(NSDate *)to {
    NSFetchRequest *fetchRequest = [Event request];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context objectsForRequest:fetchRequest];
}

- (NSArray *)mostImportantEventsOfWeeksBetween:(NSDate *)from and:(NSDate *)to {
    NSFetchRequest *fetchRequest = [Event request];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@ AND isImportantDateOfWeek == YES", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context objectsForRequest:fetchRequest];
}

- (NSArray *)mostImportantEventsOfMonthsBetween:(NSDate *)from and:(NSDate *)to {
    NSFetchRequest *fetchRequest = [Event request];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@ AND isImportantDateOfMonth == YES", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context objectsForRequest:fetchRequest];
}

- (BOOL)isEventOfDayExists:(NSDate *)date {
    NSFetchRequest *fetchRequest = [Event request];

    NSDate *from = [date startOfCurrentDay];
    NSDate *to = [date endOfCurrentDay];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context countForFetchRequest:fetchRequest error:nil] > 0;
}

- (BOOL)isEventOfWeekExists:(NSDate *)date {
    NSFetchRequest *fetchRequest = [Event request];

    NSDate *from = [date startOfCurrentWeek];
    NSDate *to = [date endOfCurrentWeek];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@ AND isImportantDateOfWeek == YES", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context countForFetchRequest:fetchRequest error:nil] > 0;
}

- (BOOL)isEventOfMonthExists:(NSDate *)date {
    NSFetchRequest *fetchRequest = [Event request];

    NSDate *from = [date startOfCurrentMonth];
    NSDate *to = [date endOfCurrentMonth];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@ AND isImportantDateOfMonth == YES", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context countForFetchRequest:fetchRequest error:nil] > 0;
}

- (NSFetchedResultsController *)values {
    NSFetchRequest *fetchRequest = [Value request];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    return [_context resultsControllerForRequest:fetchRequest];
}

- (NSArray *)topValues {
    NSFetchRequest *fetchRequest = [Value request];
    NSArray *values = [_context objectsForRequest:fetchRequest];

    values = _.array(values).sort(^NSComparisonResult(Value *a, Value *b) {
        int countA = a.events.count;
        int countB = b.events.count;

        if (countA > countB) {
            return NSOrderedAscending;
        } else if (countA < countB) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }

    }).unwrap;

    return values;
}

@end
