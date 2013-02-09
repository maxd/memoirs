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

    [self.groups removeAllObjects];
    for (NSDate *date = startYear; [date isOnOrBefore:endYear]; date = [date startOfNextYear]) {
        EventListGroup *eventListGroup = [self loadYear:date];
        [self.groups addObject:eventListGroup];
    }
}

- (EventListGroup *)loadYear:(NSDate *)dateInYear {
    EventListGroup *eventListGroup = [EventListGroup new];
    eventListGroup.startDate = [dateInYear startOfCurrentYear];
    eventListGroup.endDate = [dateInYear endOfCurrentYear];

    NSArray *events = [_appModel eventsBetween:eventListGroup.startDate and:eventListGroup.endDate]; //TODO: filter by most important flag
    for (NSDate *date = eventListGroup.startDate; [date isOnOrBefore:eventListGroup.endDate]; date = [date startOfNextMonth]) {

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
