//
//  EventListTableView.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/27/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventListTableViewDelegate <UITableViewDelegate>

@optional

- (void)recalculateOffsetForTableView:(UITableView *)tableView;

@end


@interface EventListTableView : UITableView

@property (assign, nonatomic) id <EventListTableViewDelegate> delegate;

@end


