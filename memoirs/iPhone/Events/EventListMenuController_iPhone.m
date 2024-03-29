//
//  EventListMenuController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListMenuController_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "EventListMenuCell_iPhone.h"
#import "UIColor+Helpers.h"
#import "UIBorderLabel.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "MainController_iPhone.h"

@interface EventListMenuController_iPhone () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation EventListMenuController_iPhone {
    NSArray *_menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trackedViewName = @"Menu";

    self.title = NSLocalizedString(@"My Memoirs", @"App name in NavBar");

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]]];

    _menu = @[
        @{
            @"title": NSLocalizedString(@"Sections", @"Menu header"),
            @"menu": @[
                @{
                    @"title": NSLocalizedString(@"All Events", @"Menu item"),
                    @"selector": @"menuGroupByWeek:",
                    @"prefix": @"\u2B50"
                },
                @{
                    @"title": NSLocalizedString(@"Events of Weeks", @"Menu item"),
                    @"selector": @"menuGroupByMonth:",
                    @"prefix": @"\u2B50"
                },
                @{
                    @"title": NSLocalizedString(@"Events of Months", @"Menu item"),
                    @"selector": @"menuGroupByYear:",
                    @"prefix": @"\u2B50"
                },
                @{
                    @"title": NSLocalizedString(@"Main Life Values", @"Menu item"),
                    @"selector": @"menuImportantValuesHandler:",
                    @"prefix": @"\U0001F3AF"
                },
            ]
        },
        @{
            @"title": NSLocalizedString(@"Settings", @"Menu item"),
            @"menu": @[
                @{
                    @"title": NSLocalizedString(@"Reminders", @"Menu item"),
                    @"selector": @"menuSettingsHandler:",
                    @"prefix": @"\U0001F514"
                },
#ifdef LITE
                @{
                    @"title": NSLocalizedString(@"Purchase Full Version!", @"Menu item"),
                    @"selector": @"menuPurchaseHandler:",
                    @"prefix": @"\U0001F4B0"
                },
#endif
                @{
                    @"title": NSLocalizedString(@"Tutorial", @"Menu item"),
                    @"selector": @"menuTutorialHandler:",
                    @"prefix": @"\U0001F393"
                },
            ]
        }
    ];
}

#pragma mark UITableView Handlers

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menu[(NSUInteger) section][@"menu"] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIBorderLabel *label = [UIBorderLabel new];

    label.textColor = [UIColor colorWithHex:0xFF033143];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bg"]];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.leftInset = 10.0;

    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionItem = _menu[(NSUInteger) section];
    return sectionItem[@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *menuItem = _menu[(NSUInteger) indexPath.section][@"menu"][(NSUInteger) indexPath.row];

    EventListMenuCell_iPhone *cell = [EventListMenuCell_iPhone dequeOrCreateInTable:tableView];

    NSString *prefix = @"\u2001";
    
    if (menuItem[@"prefix"]) {
        prefix = menuItem[@"prefix"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", prefix, menuItem[@"title"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(EventListMenuCell_iPhone *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *menuItem = _menu[(NSUInteger) indexPath.section][@"menu"][(NSUInteger) indexPath.row];
    NSString *selectorName = menuItem[@"selector"];

    SEL selector = NSSelectorFromString(selectorName);

    if ([self respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:tableView];
        #pragma clang diagnostic pop
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Menu Handlers

- (void)menuGroupByWeek:(UITableView *)tableView {
    [(MainController_iPhone *)self.sidePanelController showWeeklyEventList];
}

- (void)menuGroupByMonth:(UITableView *)tableView {
    [(MainController_iPhone *)self.sidePanelController showMonthlyEventList];
}

- (void)menuGroupByYear:(UITableView *)tableView {
    [(MainController_iPhone *)self.sidePanelController showYearlyEventList];
}

- (void)menuImportantValuesHandler:(UITableView *)tableView {
    [(MainController_iPhone *)self.sidePanelController showImportantValueList];
}

- (void)menuSettingsHandler:(UITableView *)tableView {
    [(MainController_iPhone *) self.sidePanelController showRemindersSettings];
}

#ifdef LITE
- (void)menuPurchaseHandler:(UITableView *)tableView {
    [(MainController_iPhone *)self.sidePanelController showPurchase];
}
#endif

- (void)menuTutorialHandler:(UITableView *)tableView {
    [(MainController_iPhone *) self.sidePanelController showTutorial:YES];
}

@end
