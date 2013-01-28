//
//  EventListTableModel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListTableModel.h"
#import "NSDate+MTDates.h"
#import "EventListGroup.h"
#import "Event.h"

@interface EventListTableModel ()
@end

@implementation EventListTableModel

- (id)init {
    self = [super init];
    if (self) {
        self.groups = [NSMutableArray new];
    }

    return self;
}

- (void)loadWeeksAroundCurrent {
    NSDate *currentWeek = [[NSDate date] startOfCurrentWeek];
    NSDate *startWeek = [currentWeek startOfPreviousWeek];
    NSDate *endWeek = [currentWeek startOfNextWeek];

    [self.groups removeAllObjects];
    for (NSDate *date = startWeek; [date isOnOrBefore:endWeek]; date = [date startOfNextWeek]) {
        EventListGroup *eventListGroup = [self loadWeek:date];
        [self.groups addObject:eventListGroup];
    }
}

- (EventListGroup *)loadWeek:(NSDate *)dateInWeek {
    EventListGroup *eventListGroup = [EventListGroup new];
    eventListGroup.startDate = [dateInWeek startOfCurrentWeek];
    eventListGroup.endDate = [dateInWeek endOfCurrentWeek];

    for (NSDate *date = eventListGroup.startDate; [date isOnOrBefore:eventListGroup.endDate]; date = [date startOfNextDay]) {
//        Event *event = [Event new];
//        event.text = @"test";
//        event.date = date;

        [eventListGroup.events addObject:[NSNull null]];
    }

    return eventListGroup;
}

- (void)loadPrev {
    EventListGroup *eventListGroup = self.groups[0];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfPreviousWeek];
    eventListGroup = [self loadWeek:date];
    [self.groups insertObject:eventListGroup atIndex:0];

    [self.groups removeLastObject];
}

- (void)loadNext {
    EventListGroup *eventListGroup = [self.groups lastObject];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfNextWeek];
    eventListGroup = [self loadWeek:date];
    [self.groups addObject:eventListGroup];

    [self.groups removeObjectAtIndex:0];
}

@end
