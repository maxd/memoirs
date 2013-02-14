//
//  YearlyEventListTableModel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "YearlyEventListTableModel.h"
#import "NSDate+MTDates.h"
#import "EventListGroup.h"
#import "AppModel.h"
#import "Event.h"
#import "EventListItem.h"
#import "Underscore.h"

#define _ Underscore

@implementation YearlyEventListTableModel {
    AppModel *_appModel;
}

@synthesize groups;

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
        self.groups = [NSMutableArray new];
    }
    return self;
}

- (void)loadSectionsAroundDate:(NSDate *)currentDate {
    NSDate *startYear = [[currentDate startOfPreviousYear] oneYearPrevious];
    NSDate *endYear = [[currentDate startOfNextYear] oneYearNext];

    [self reloadSectionsBetween:startYear and:endYear];
}

- (void)reloadSectionsBetween:(NSDate *)startDate and:(NSDate *)endDate {
    [self.groups removeAllObjects];
    for (NSDate *date = startDate; [date isOnOrBefore:endDate]; date = [date startOfNextYear]) {
        EventListGroup *eventListGroup = [self loadYear:date];
        [self.groups addObject:eventListGroup];
    }
}

- (EventListGroup *)loadYear:(NSDate *)dateInYear {
    EventListGroup *eventListGroup = [EventListGroup new];
    eventListGroup.startDate = [dateInYear startOfCurrentYear];
    eventListGroup.endDate = [dateInYear endOfCurrentYear];

    NSArray *events = [_appModel mostImportantEventsOfMonthsBetween:eventListGroup.startDate and:eventListGroup.endDate];
    for (NSDate *date = eventListGroup.startDate; [date isOnOrBefore:eventListGroup.endDate]; date = [date startOfNextMonth]) {

        NSDate *startDate = date;
        NSDate *endDate = [date endOfCurrentMonth];

        Event *event = _.array(events).find(^BOOL(Event *e) {
            return [e.date isBetweenDate:startDate andDate:endDate];
        });

        EventListItem *eventListItem = [[EventListItem alloc] initWithEvent:event startDate:startDate endDate:endDate];
        [eventListGroup.eventListItems addObject:eventListItem];
    }

    return eventListGroup;
}

- (void)loadPrevSection {
    EventListGroup *eventListGroup = self.groups[0];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfPreviousYear];
    eventListGroup = [self loadYear:date];
    [self.groups insertObject:eventListGroup atIndex:0];

    [self.groups removeLastObject];
}

- (void)loadNextSection {
    EventListGroup *eventListGroup = [self.groups lastObject];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfNextYear];
    eventListGroup = [self loadYear:date];
    [self.groups addObject:eventListGroup];

    [self.groups removeObjectAtIndex:0];
}

@end
