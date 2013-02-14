//
//  ImportantValueListController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/14/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "ImportantValueListController_iPhone.h"

@interface ImportantValueListController_iPhone () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;

@end

@implementation ImportantValueListController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"TOP 10 ценностей";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
