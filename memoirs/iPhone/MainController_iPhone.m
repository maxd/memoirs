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
#import "RemindersSettingsController_iPhone.h"
#import "EventListTableModel.h"
#import "WeeklyEventListTableModel.h"
#import "MonthlyEventListTableModel.h"
#import "YearlyEventListTableModel.h"
#import "EventListHandler.h"
#import "WeeklyEventListHandler.h"
#import "MonthlyEventListHandler.h"
#import "YearlyEventListHandler.h"
#import "ImportantValueListController_iPhone.h"
#import "PurchaseController_iPhone.h"
#import "TutorialController.h"

#define IS_TUTORIAL_SHOWN_FIRST_TIME_KEY @"is-tutorial-shown-first-time"

@interface MainController_iPhone ()

@end

@implementation MainController_iPhone {
    AppModel *_appModel;

    EventListController_iPhone *_eventListController;
    EventListMenuController_iPhone *_eventListMenuPanel;

    UINavigationController *_eventListPanel;
    UINavigationController *_remindersSettingsPanel;
    UINavigationController *_importantValueListPane;
    UINavigationController *_purchasePanel;
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

- (void)viewDidAppear:(BOOL)animated {
    [self showTutorialFirstTime];
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

- (UINavigationController *)remindersSettingsPanel {
    if (!_remindersSettingsPanel) {
        RemindersSettingsController_iPhone *remindersSettingsController = [RemindersSettingsController_iPhone new];
        remindersSettingsController.showDoneButton = NO;
        remindersSettingsController.showCreditsFooter = NO;

        _remindersSettingsPanel = [[UINavigationController alloc] initWithRootViewController:remindersSettingsController];
    }

    return _remindersSettingsPanel;
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

#ifdef LITE
- (UINavigationController *)purchasePanel {
    if (!_purchasePanel) {
        PurchaseController_iPhone *purchaseController = [PurchaseController_iPhone new];
        
        _purchasePanel = [[UINavigationController alloc] initWithRootViewController:purchaseController];
    }
    
    return _purchasePanel;
}
#endif

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

- (void)showRemindersSettings {
    if (self.centerPanel != [self remindersSettingsPanel]) {
        self.centerPanel = [self remindersSettingsPanel];
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

#ifdef LITE
- (void)showPurchase {
    if (self.centerPanel != [self purchasePanel]) {
        self.centerPanel = [self purchasePanel];
    } else {
        [self showCenterPanel:YES];
    }
}
#endif

- (void)showTutorial {
    [self showCenterPanel:YES];

    TutorialController *tutorialController = [TutorialController new];
    tutorialController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:tutorialController animated:YES];
}

- (void)showTutorialFirstTime {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:IS_TUTORIAL_SHOWN_FIRST_TIME_KEY]) {
        [self showTutorial];
        
        [userDefaults setBool:YES forKey:IS_TUTORIAL_SHOWN_FIRST_TIME_KEY];
        [userDefaults synchronize];
    }
}

@end
