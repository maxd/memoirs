//
//  ValueListController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol ValueListControllerDelegate_iPhone;

@class AppModel;
@class Value;


@interface ValueListController_iPhone : GAITrackedViewController

@property (strong, nonatomic) Value *value;

@property (weak, nonatomic) id<ValueListControllerDelegate_iPhone> delegate;

-(id)initWithAppModel:(AppModel *)appModel;

@end


@protocol ValueListControllerDelegate_iPhone

@optional

- (void)valueListControllerDidSelectedValue:(ValueListController_iPhone *)valueListController;

@end
