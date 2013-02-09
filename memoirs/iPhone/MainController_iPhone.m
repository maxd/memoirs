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
#import "EventListTableModel.h"
#import "WeeklyEventListTableModel.h"
#import "MonthlyEventListTableModel.h"
#import "YearlyEventListTableModel.h"

@interface MainController_iPhone ()

@end

@implementation MainController_iPhone {
    AppModel *_appModel;

    EventListController_iPhone *_eventListController;
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

    [self showWeeklyEventList];

    _eventListMenuPanel = [EventListMenuController_iPhone new];

    self.leftPanel = _eventListMenuPanel;
    self.leftGapPercentage = 0.82;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (UINavigationController *)eventListPanel {
    if (!_eventListPanel) {
        _eventListController = [[EventListController_iPhone alloc] initWithAppModel:_appModel];
        _eventListPanel = [[UINavigationController alloc] initWithRootViewController:_eventListController];
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

-(void)showWeeklyEventList {
    [self showEventListWithModel:[[WeeklyEventListTableModel alloc] initWithAppModel:_appModel]];
}

-(void)showMonthlyEventList {
    [self showEventListWithModel:[[MonthlyEventListTableModel alloc] initWithAppModel:_appModel]];
}

-(void)showYearlyEventList {
    [self showEventListWithModel:[[YearlyEventListTableModel alloc] initWithAppModel:_appModel]];
}

- (void)showEventListWithModel:(id <EventListTableModel>)eventListTableModel {
    if (self.centerPanel != [self eventListPanel]) {
        self.centerPanel = [self eventListPanel];
    } else {
        [self showCenterPanel:YES];
    }

    _eventListController.eventListTableModel = eventListTableModel;
    [_eventListController scrollToTodayAnimated:YES];
}

- (void)showSettings {
    if (self.centerPanel != [self settingsPanel]) {
        self.centerPanel = [self settingsPanel];
    } else {
        [self showCenterPanel:YES];
    }
}

@end
