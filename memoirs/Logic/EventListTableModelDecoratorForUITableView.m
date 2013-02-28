//
//  EventListTableModelDecoratorForUITableView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListTableModelDecoratorForUITableView.h"
#import "EventListTableModel.h"
#import "EventListGroup.h"
#import "NSDate+MTDates.h"
#import "EventListItem.h"

@implementation EventListTableModelDecoratorForUITableView {
    id<EventListTableModel> _eventListTableModel;
}

- (id)initWithEventListTableModel:(id<EventListTableModel>)eventListTableModel {
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

- (NSIndexPath *)indexPathForDate:(NSDate *)date {
    for (NSUInteger section = 0; section < _eventListTableModel.groups.count; section++) {
        EventListGroup *eventListGroup = _eventListTableModel.groups[section];

        for (NSUInteger row = 0; row < eventListGroup.eventListItems.count; row++) {
            EventListItem *eventListItem = eventListGroup.eventListItems[row];

            if ([date isBetweenDate:eventListItem.startDate andDate:eventListItem.endDate]) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }

    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)loadSectionsAroundDate:(NSDate *)date {
    [_eventListTableModel loadSectionsAroundDate:date];
}

- (void)reloadData {
    EventListGroup *firstEventListGroup = _eventListTableModel.groups[0];
    EventListGroup *lastEventListGroup = [_eventListTableModel.groups lastObject];

    [_eventListTableModel reloadSectionsBetween:firstEventListGroup.startDate and:lastEventListGroup.endDate];
}

- (void)loadPrevSection {
    [_eventListTableModel loadPrevSection];
}

- (void)loadNextSection {
    [_eventListTableModel loadNextSection];
}

@end
