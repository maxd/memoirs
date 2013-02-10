//
//  EventSelectorController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/8/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventSelectorControllerDelegate_iPhone;
@class Event;

@interface EventSelectorController_iPhone : UIViewController

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSString *emptyMessage;

@property (weak, nonatomic) id <EventSelectorControllerDelegate_iPhone> delegate;

@end

@protocol EventSelectorControllerDelegate_iPhone

@optional

- (void)eventSelectorController:(EventSelectorController_iPhone *)eventSelectorController didSelectEvent:(Event *)event;

@end
