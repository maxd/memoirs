//
//  EventEditorController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventEditorController_iPhoneDelegate;

@class Event;
@class Value;
@class AppModel;


@interface EventEditorController_iPhone : UIViewController

@property (weak, nonatomic) id<EventEditorController_iPhoneDelegate> delegate;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) Value *value;
@property (strong, nonatomic) NSString *text;

- (id)initWithAppModel:(AppModel *)appModel;

@end


@protocol EventEditorController_iPhoneDelegate

@optional

- (void)eventEditorController:(EventEditorController_iPhone *)eventEditorController didFinishedWithSaveState:(BOOL)save;

@end