//
//  ValueEditorController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol ValueEditorControllerDelegate_iPhone;

@class Value;
@class AppModel;


@interface ValueEditorController_iPhone : GAITrackedViewController

@property (weak, nonatomic) id<ValueEditorControllerDelegate_iPhone> delegate;

@property (strong, nonatomic) Value *value;

- (id)initWithAppModel:(AppModel *)appModel;

@end

@protocol ValueEditorControllerDelegate_iPhone

@optional

- (void)dismissValueEditorController:(ValueEditorController_iPhone *)sender;

@end