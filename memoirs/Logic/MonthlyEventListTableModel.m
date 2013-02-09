//
//  MonthlyEventListTableModel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/8/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "MonthlyEventListTableModel.h"
#import "AppModel.h"
#import "NSDate+MTDates.h"
#import "EventListGroup.h"
#import "Event.h"
#import "EventListItem.h"

@interface MonthlyEventListTableModel ()
@end

@implementation MonthlyEventListTableModel {
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
    NSDate *startMonth = [[currentDate startOfPreviousMonth] oneMonthPrevious];
    NSDate *endMonth = [[currentDate startOfNextMonth] oneMonthNext];

    [self.groups removeAllObjects];
    for (NSDate *date = startMonth; [date isOnOrBefore:endMonth]; date = [date startOfNextMonth]) {
        EventListGroup *eventListGroup = [self loadMonth:date];
        [self.groups addObject:eventListGroup];
    }
}

- (EventListGroup *)loadMonth:(NSDate *)dateInMonth {
    EventListGroup *eventListGroup = [EventListGroup new];
    eventListGroup.startDate = [dateInMonth startOfCurrentMonth];
    eventListGroup.endDate = [dateInMonth endOfCurrentMonth];

    NSDate *alignedByWeekStartDate = [eventListGroup.startDate startOfCurrentWeek];
    NSDate *alignedByWeekEndDate = [eventListGroup.endDate weekDayOfWeek] == 7 ? eventListGroup.endDate : [eventListGroup.endDate endOfPreviousWeek];

    NSArray *events = [_appModel eventsBetween:alignedByWeekStartDate and:alignedByWeekEndDate]; //TODO: filter by most important flag
    for (NSDate *date = alignedByWeekStartDate; [date isOnOrBefore:alignedByWeekEndDate]; date = [date startOfNextWeek]) {

        Event *event = _.array(events).find(^BOOL(Event *e) {
            return [e.date isEqualToDate:date];
        });

        EventListItem *eventListItem = [[EventListItem alloc] initWithDate:date andEvent:event];
        [eventListGroup.eventListItems addObject:eventListItem];
    }

    return eventListGroup;
}

- (void)loadPrevSection {
    EventListGroup *eventListGroup = self.groups[0];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfPreviousMonth];
    eventListGroup = [self loadMonth:date];
    [self.groups insertObject:eventListGroup atIndex:0];

    [self.groups removeLastObject];
}

- (void)loadNextSection {
    EventListGroup *eventListGroup = [self.groups lastObject];
    NSDate *date = eventListGroup.startDate;

    date = [date startOfNextMonth];
    eventListGroup = [self loadMonth:date];
    [self.groups addObject:eventListGroup];

    [self.groups removeObjectAtIndex:0];
}

@end
