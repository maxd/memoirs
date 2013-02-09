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

- (NSFetchedResultsController *)values {
    NSFetchRequest *fetchRequest = [Value request];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    return [_context resultsControllerForRequest:fetchRequest];
}

@end
