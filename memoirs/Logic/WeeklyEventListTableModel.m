//
//  WeeklyEventListTableModel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "WeeklyEventListTableModel.h"
#import "NSDate+MTDates.h"
#import "EventListGroup.h"
#import "Event.h"
#import "AppModel.h"
#import "EventListItem.h"

@interface WeeklyEventListTableModel ()
@end

@implementation WeeklyEventListTableModel {
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
    NSDate *startWeek = [[currentDate startOfPreviousWeek] oneWeekPrevious];
    NSDate *endWeek = [[currentDate startOfNextWeek] oneWeekNext];

    [self reloadSectionsBetween:startWeek and:endWeek];
}

- (void)reloadSectionsBetween:(NSDate *)startDate and:(NSDate *)endDate {
    [self.groups removeAllObjects];
    for (NSDate *date = startDate; [date isOnOrBefore:endDate]; date = [date startOfNextWeek]) {
        EventListGroup *eventListGroup = [self loadWeek:date];
        [self.groups addObject:eventListGroup];
    }
}

- (EventListGroup *)loadWeek:(NSDate *)dateInWeek {
    EventListGroup *eventListGroup = [EventListGroup new];
    eventListGroup.startDate = [dateInWeek startOfCurrentWeek];
    eventListGroup.endDate = [dateInWeek endOfCurrentWeek];

    NSArray *events = [_appModel eventsBetween:eventListGroup.startDate and:eventListGroup.endDate];
    for (NSDate *date = eventListGroup.startDate; [date isOnOrBefore:eventListGroup.endDate]; date = [date startOfNextDay]) {

        Event *event = _.array(events).find(^BOOL(Event *e) {
            return [e.date isEqualToDate:date];
        });

        EventListItem *eventListItem = [[EventListItem alloc] initWithEvent:event startDate:date endDate:[date endOfCurrentDay]];
        [eventListGroup.eventListItems addObject:eventListItem];
    }

    return eventListGroup;
}

- (void)loadPrevSection {
    EventListGroup *eventListGroup = self.groups[0];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfPreviousWeek];
    eventListGroup = [self loadWeek:date];
    [self.groups insertObject:eventListGroup atIndex:0];

    [self.groups removeLastObject];
}

- (void)loadNextSection {
    EventListGroup *eventListGroup = [self.groups lastObject];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfNextWeek];
    eventListGroup = [self loadWeek:date];
    [self.groups addObject:eventListGroup];

    [self.groups removeObjectAtIndex:0];
}

@end
