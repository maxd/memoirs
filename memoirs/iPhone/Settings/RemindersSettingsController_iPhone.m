//
//  RemindersSettingsController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "RemindersSettingsController_iPhone.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface RemindersSettingsController_iPhone ()

@end

@implementation RemindersSettingsController_iPhone {
    UIColor *_regularBackground;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Reminders", @"NavBar title");

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]];

    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;

    _regularBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg"]];
}

#pragma mark Action Handlers

- (void)btMenuHandler:(id)sender {
    [self.sidePanelController showLeftPanel:YES];
}

#pragma mark Table Handler

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = _regularBackground;
}

@end
