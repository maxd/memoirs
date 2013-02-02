//
//  MainController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "MainController_iPhone.h"
#import "EventListMenuController_iPhone.h"
#import "EventListController_iPhone.h"
#import "AppModel.h"

@interface MainController_iPhone ()

@end

@implementation MainController_iPhone {
    AppModel *_appModel;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    EventListController_iPhone *eventListController = [[EventListController_iPhone alloc] initWithAppModel:_appModel];
    EventListMenuController_iPhone *eventListMenuController = [[EventListMenuController_iPhone alloc] init];

    self.centerPanel = [[UINavigationController alloc] initWithRootViewController:eventListController];
    self.leftPanel = eventListMenuController;
    self.leftGapPercentage = 0.82;
}

@end
