//
//  EventListTableModelDecoratorForUITableView.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventListTableModel;
@class Event;
@class EventListGroup;

@interface EventListTableModelDecoratorForUITableView : NSObject

-(id)initWithEventListTableModel:(EventListTableModel *)eventListTableModel;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (Event *)eventByIndexPath:(NSIndexPath *)indexPath;

- (EventListGroup *)eventGroupBySection:(NSInteger)section;

-(NSIndexPath *)currentIndexPath;

-(void)loadWeeksAroundCurrent;

-(void)loadPrev;

-(void)loadNext;
@end
