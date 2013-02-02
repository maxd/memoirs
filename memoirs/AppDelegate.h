//
//  AppDelegate.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/25/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController_iPhone.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)shared;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainController_iPhone *mainController;

@end
