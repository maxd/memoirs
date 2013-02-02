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
#import "SettingsController_iPhone.h"
#import "MainController_iPhone.h"

@interface EventListMenuController_iPhone () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation EventListMenuController_iPhone {
    NSArray *_menu;
    NSString *_selectedGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _menu = @[
        @{
            @"title": @"Показать события",
            @"menu": @[
                @{
                    @"title": @"Недели",
                    @"selector": @"menuGroupByWeek:"
                },
                @{
                    @"title": @"Месяца",
                    @"selector": @"menuGroupByMonth:"
                },
                @{
                    @"title": @"Года",
                    @"selector": @"menuGroupByYear:"
                },
            ]
        },
        @{
            @"title": @" ",
            @"menu": @[
                @{
                    @"title": @"Настройки",
                    @"selector": @"menuSettingsHandler:"
                }
            ]
        }
    ];

    _selectedGroup = @"menuGroupByWeek:";
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
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellheader_background"]];
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

    BOOL isSelected = [menuItem[@"selector"] isEqualToString:_selectedGroup];
    NSString *checkboxText = isSelected ? @"\u2713" : @"\u2001";

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", checkboxText, menuItem[@"title"]];
    cell.selected = isSelected;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(EventListMenuCell_iPhone *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background"]];
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
    _selectedGroup = @"menuGroupByWeek:";
    [tableView reloadData];

    [(MainController_iPhone *)self.sidePanelController showEventList];
    // ???
}

- (void)menuGroupByMonth:(UITableView *)tableView {
    _selectedGroup = @"menuGroupByMonth:";
    [tableView reloadData];

    [(MainController_iPhone *)self.sidePanelController showEventList];
    // ???
}

- (void)menuGroupByYear:(UITableView *)tableView {
    _selectedGroup = @"menuGroupByYear:";
    [tableView reloadData];

    [(MainController_iPhone *)self.sidePanelController showEventList];
    // ???
}

- (void)menuSettingsHandler:(UITableView *)tableView {
    [(MainController_iPhone *)self.sidePanelController showSettings];
}

@end
