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
#import "EventListHandler.h"
#import "WeeklyEventListHandler.h"
#import "MonthlyEventListHandler.h"
#import "YearlyEventListHandler.h"
#import "ImportantValueListController_iPhone.h"

@interface MainController_iPhone ()

@end

@implementation MainController_iPhone {
    AppModel *_appModel;

    EventListController_iPhone *_eventListController;
    EventListMenuController_iPhone *_eventListMenuPanel;

    UINavigationController *_eventListPanel;
    UINavigationController *_settingsPanel;
    UINavigationController *_importantValueListPane;
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

    self.leftPanel = [[UINavigationController alloc] initWithRootViewController:_eventListMenuPanel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (UINavigationController *)eventListPanel {
    if (!_eventListPanel) {
        _eventListController = [[EventListController_iPhone alloc] initWithAppModel:_appModel];

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_eventListController];
        [navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldSystemFontOfSize:14]}];
        [navigationController.navigationBar setTitleVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];

        _eventListPanel = navigationController;
    }

    return _eventListPanel;
}

- (UINavigationController *)settingsPanel {
    if (!_settingsPanel) {
        SettingsController_iPhone *settingsController = [SettingsController_iPhone new];
        settingsController.showDoneButton = NO;
        settingsController.showCreditsFooter = NO;

        _settingsPanel = [[UINavigationController alloc] initWithRootViewController:settingsController];
    }

    return _settingsPanel;
}

 - (UINavigationController *)importantValueListPane {
     if (!_importantValueListPane) {
         ImportantValueListController_iPhone *importantValueListController = [[ImportantValueListController_iPhone alloc] initWithAppModel:_appModel];

         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:importantValueListController];
         [navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldSystemFontOfSize:14]}];
         [navigationController.navigationBar setTitleVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];

         _importantValueListPane = navigationController;
     }
     return _importantValueListPane;
 }

-(void)showWeeklyEventList {
    WeeklyEventListTableModel *eventListTableModel = [[WeeklyEventListTableModel alloc] initWithAppModel:_appModel];
    WeeklyEventListHandler *eventListHandler = [[WeeklyEventListHandler alloc] initWithAppModel:_appModel];
    [self showEventListWithModel:eventListTableModel andHandler:eventListHandler];
}

-(void)showMonthlyEventList {
    MonthlyEventListTableModel *eventListTableModel = [[MonthlyEventListTableModel alloc] initWithAppModel:_appModel];
    MonthlyEventListHandler *eventListHandler = [[MonthlyEventListHandler alloc] initWithAppModel:_appModel];
    [self showEventListWithModel:eventListTableModel andHandler:eventListHandler];
}

-(void)showYearlyEventList {
    YearlyEventListTableModel *eventListTableModel = [[YearlyEventListTableModel alloc] initWithAppModel:_appModel];
    YearlyEventListHandler *eventListHandler = [[YearlyEventListHandler alloc] initWithAppModel:_appModel];
    [self showEventListWithModel:eventListTableModel andHandler:eventListHandler];
}

- (void)showEventListWithModel:(id <EventListTableModel>)eventListTableModel andHandler:(id <EventListHandler>)eventListHandler {
    if (self.centerPanel != [self eventListPanel]) {
        self.centerPanel = [self eventListPanel];
    } else {
        [self showCenterPanel:YES];
    }

    _eventListController.eventListTableModel = eventListTableModel;
    _eventListController.eventListHandler = eventListHandler;

    _eventListController.title = [eventListHandler navBarTitle];

    [_eventListController scrollToTodayAnimated:YES];
}

- (void)openEventListEditorForDate:(NSDate *)date {
    [_eventListController openEventListEditorForDate:date];
}

- (void)showSettings {
    if (self.centerPanel != [self settingsPanel]) {
        self.centerPanel = [self settingsPanel];
    } else {
        [self showCenterPanel:YES];
    }
}

- (void)showImportantValueList {
    if (self.centerPanel != [self importantValueListPane]) {
        self.centerPanel = [self importantValueListPane];
    } else {
        [self showCenterPanel:YES];
    }
}

@end
