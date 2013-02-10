//
//  EventListTableModelDecoratorForUITableView.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventListTableModel;
@class EventListGroup;
@class EventListItem;

@interface EventListTableModelDecoratorForUITableView : NSObject

- (id)initWithEventListTableModel:(id<EventListTableModel>)eventListTableModel;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (EventListItem *)eventListItemByIndexPath:(NSIndexPath *)indexPath;

- (EventListGroup *)eventListGroupBySection:(NSInteger)section;

- (NSIndexPath *)currentIndexPath;

- (void)loadSectionsAroundDate:(NSDate *)date;

- (void)reloadData;

- (void)loadPrevSection;

- (void)loadNextSection;

@end
