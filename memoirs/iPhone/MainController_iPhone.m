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
#import "SettingsController_iPhone.h"

@interface MainController_iPhone ()

@end

@implementation MainController_iPhone {
    AppModel *_appModel;

    EventListMenuController_iPhone *_eventListMenuPanel;

    UINavigationController *_eventListPanel;
    UINavigationController *_settingsPanel;
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

    [self showEventList];

    _eventListMenuPanel = [EventListMenuController_iPhone new];

    self.leftPanel = _eventListMenuPanel;
    self.leftGapPercentage = 0.82;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (UINavigationController *)eventListPanel {
    if (!_eventListPanel) {
        EventListController_iPhone *eventListController = [[EventListController_iPhone alloc] initWithAppModel:_appModel];
        _eventListPanel = [[UINavigationController alloc] initWithRootViewController:eventListController];
    }

    return _eventListPanel;
}

- (UINavigationController *)settingsPanel {
    if (!_settingsPanel) {
        SettingsController_iPhone *settingsController = [SettingsController_iPhone new];
        _settingsPanel = [[UINavigationController alloc] initWithRootViewController:settingsController];
    }

    return _settingsPanel;
}

- (void)showEventList {
    if (self.centerPanel != [self eventListPanel]) {
        self.centerPanel = [self eventListPanel];
    } else {
        [self showCenterPanel:YES];
    }
}

- (void)showSettings {
    if (self.centerPanel != [self settingsPanel]) {
        self.centerPanel = [self settingsPanel];
    } else {
        [self showCenterPanel:YES];
    }
}

@end
