//
//  EventEditorController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol EventEditorController_iPhoneDelegate;

@class AppModel;
@class EventListItem;


@interface EventEditorController_iPhone : GAITrackedViewController

@property (weak, nonatomic) id<EventEditorController_iPhoneDelegate> delegate;

@property (strong, nonatomic) EventListItem *eventListItem;

- (id)initWithAppModel:(AppModel *)appModel;

@end


@protocol EventEditorController_iPhoneDelegate

@optional

- (void)dismissEventEditorController:(EventEditorController_iPhone *)eventEditorController;

@end