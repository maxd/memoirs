//
//  SettingsController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "SettingsController_iPhone.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface SettingsController_iPhone () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;

@end

@implementation SettingsController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Настройки";

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];

    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;
}

#pragma mark UITableView Handlers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark Action Handlers

- (void)btMenuHandler:(id)sender {
    [self.sidePanelController showLeftPanel:YES];
}

@end
