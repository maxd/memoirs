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
#import "ValueEditorController_iPhone.h"
#import "NSManagedObjectContext+Helpers.h"
#import "WCAlertView.h"
#import "GAITracker.h"

@interface ValueListController_iPhone () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, ValueEditorControllerDelegate_iPhone>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;

@end

@implementation ValueListController_iPhone {
    AppModel *_appModel;
    NSFetchedResultsController *_valuesResultController;

    UIBarButtonItem *btAdd;
    UIBarButtonItem *btEdit;
    UIBarButtonItem *btDone;
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

    self.trackedViewName = @"Value List";

    self.title = NSLocalizedString(@"Life Values", @"NavBar title");

    btAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btAddHandler:)];
    btEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(btEditHandler:)];
    btDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btEditHandler:)];

    self.navigationItem.rightBarButtonItem = btEdit;

    _valuesResultController = [_appModel values];
    _valuesResultController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_valuesResultController performFetch:nil];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Value *value = [_valuesResultController objectAtIndexPath:indexPath];

    if (tableView.isEditing) {
        [self editValue:value];
    } else {
        [self selectValue:value];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Value *value = [_valuesResultController objectAtIndexPath:indexPath];

        [self deleteValue:value];
    }
}

#pragma mark NSFetchResultController Handlers

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.ctlTableView reloadData];
}

#pragma mark Action Handlers

- (void)btAddHandler:(id)sender {
    [self addValue];
}

- (void)btEditHandler:(id)sender {
    BOOL isMoveToEditMode = ![self.ctlTableView isEditing];
    if (isMoveToEditMode) {
        self.navigationItem.rightBarButtonItem = btDone;
        self.navigationItem.leftBarButtonItem = btAdd;
    } else {
        self.navigationItem.rightBarButtonItem = btEdit;
        self.navigationItem.leftBarButtonItem = nil;
    }

    [self.ctlTableView setEditing:isMoveToEditMode animated:YES];
}

#pragma mark Operations

- (void)selectValue:(Value *)value {
    self.value = value;

    [self.delegate valueListControllerDidSelectedValue:self];
}

- (void)addValue {
    ValueEditorController_iPhone *valueEditorController = [[ValueEditorController_iPhone alloc] initWithAppModel:_appModel];
    valueEditorController.delegate = self;

    [self.navigationController pushViewController:valueEditorController animated:YES];
}

- (void)editValue:(Value *)value {
    ValueEditorController_iPhone *valueEditorController = [[ValueEditorController_iPhone alloc] initWithAppModel:_appModel];
    valueEditorController.delegate = self;
    valueEditorController.value = value;

    [self.navigationController pushViewController:valueEditorController animated:YES];
}

- (void)deleteValue:(Value *)value {
    if (value.events.count > 0) {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                                            message:NSLocalizedString(@"You can't remove already used life value.", @"Alert text")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

        [alertView show];
    } else {
        NSManagedObjectContext *context = [_appModel context];

        [context deleteObject:value];
        [context save];

        [self.tracker sendEventWithCategory:@"User Action" withAction:@"Button Touch" withLabel:@"Delete Value" withValue:nil];
    }
}

- (void)dismissValueEditorController:(ValueEditorController_iPhone *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
