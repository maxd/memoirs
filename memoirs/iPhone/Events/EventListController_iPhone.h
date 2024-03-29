//
//  EventListController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class AppModel;
@protocol EventListTableModel;
@protocol EventListHandler;

@interface EventListController_iPhone : GAITrackedViewController

@property (strong, nonatomic) id <EventListTableModel> eventListTableModel;
@property (strong, nonatomic) id <EventListHandler> eventListHandler;

- (id)initWithAppModel:(AppModel *)appModel;

- (void)scrollToTodayAnimated:(BOOL)animated;

- (void)openEventListEditorForDate:(NSDate *)date;

@end
