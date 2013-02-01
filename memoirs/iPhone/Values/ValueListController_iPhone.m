//
//  ValueListController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ValueListController_iPhone.h"
#import "AppModel.h"
#import "ValueListCell_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "Value.h"

@interface ValueListController_iPhone () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ValueListController_iPhone {
    AppModel *_appModel;
    NSFetchedResultsController *_valuesResultController;
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

    self.title = @"Ценности";

    UIBarButtonItem *btAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btAddHandler:)];
    self.navigationItem.rightBarButtonItem = btAdd;

    _valuesResultController = [_appModel values];
    [_valuesResultController performFetch:nil];
}

#pragma mark Control Handlers

- (void)btAddHandler:(id)sender {

}

#pragma mark UITableView Handlers

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_valuesResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[_valuesResultController sections] objectAtIndex:(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Value *value = [_valuesResultController objectAtIndexPath:indexPath];

    ValueListCell_iPhone *cell = [ValueListCell_iPhone dequeOrCreateInTable:tableView];
    cell.textLabel.text = value.title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Value *value = [_valuesResultController objectAtIndexPath:indexPath];

    self.value = value;

    [self.delegate valueListControllerDidSelectedValue:self];
}

@end
