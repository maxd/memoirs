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
#import "Event.h"
#import "NSDate+MTDates.h"

@implementation EventListTableModelDecoratorForUITableView {
    EventListTableModel *_eventListTableModel;
}

- (id)initWithEventListTableModel:(EventListTableModel *)eventListTableModel {
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

    return [eventListGroup.events count];
}

- (Event *)eventByIndexPath:(NSIndexPath *)indexPath {
    EventListGroup *eventListGroup = _eventListTableModel.groups[(NSUInteger) indexPath.section];
    return eventListGroup.events[(NSUInteger) indexPath.row];
}

- (EventListGroup *)eventGroupBySection:(NSInteger)section {
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

- (void)loadWeeksAroundCurrent {
    [_eventListTableModel loadWeeksAroundCurrent];
}

- (void)loadPrev {
    [_eventListTableModel loadPrev];
}

- (void)loadNext {
    [_eventListTableModel loadNext];
}

@end
