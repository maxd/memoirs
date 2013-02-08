//
//  EventListTableModelDecoratorForUITableView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListTableModelDecoratorForUITableView.h"
#import "WeeklyEventListTableModel.h"
#import "EventListGroup.h"
#import "NSDate+MTDates.h"
#import "EventListItem.h"

@implementation EventListTableModelDecoratorForUITableView {
    WeeklyEventListTableModel *_eventListTableModel;
}

- (id)initWithEventListTableModel:(WeeklyEventListTableModel *)eventListTableModel {
    self = [super init];
    if (self) {
        _eventListTableModel = eventListTableModel;
    }

    return self;
}

- (NSInteger)numberOfSections {
    return [_eventListTableModel.groups count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    EventListGroup *eventListGroup = _eventListTableModel.groups[(NSUInteger) section];

    return [eventListGroup.eventListItems count];
}

- (EventListItem *)eventListItemByIndexPath:(NSIndexPath *)indexPath {
    EventListGroup *eventListGroup = _eventListTableModel.groups[(NSUInteger) indexPath.section];
    return eventListGroup.eventListItems[(NSUInteger) indexPath.row];
}

- (EventListGroup *)eventListGroupBySection:(NSInteger)section {
    return _eventListTableModel.groups[(NSUInteger)section];
}

- (NSIndexPath *)currentIndexPath {
    NSDate *currentDate = [NSDate date];

    NSInteger section = 0;
    for (int i = 0; i < _eventListTableModel.groups.count; i++) {
        EventListGroup *eventListGroup = _eventListTableModel.groups[(NSUInteger) i];
        if ([currentDate isBetweenDate:eventListGroup.startDate andDate:eventListGroup.endDate]) {
            section = i;
            break;
        }
    }

    return [NSIndexPath indexPathForRow:0 inSection:section];
}

- (void)loadSectionsAroundDate:(NSDate *)date {
    [_eventListTableModel loadSectionsAroundDate:date];
}

- (void)loadPrevSection {
    [_eventListTableModel loadPrevSection];
}

- (void)loadNextSection {
    [_eventListTableModel loadNextSection];
}

@end
