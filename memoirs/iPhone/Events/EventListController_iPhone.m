//
//  EventListController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListController_iPhone.h"
#import "AppDelegate.h"
#import "AppModel.h"
#import "EventListTableModelDecoratorForUITableView.h"
#import "EventListCell_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "EventListGroup.h"
#import "EventListItem.h"
#import "EventListHandler.h"
#import "UIColor+Helpers.h"
#import "EventListTableView.h"

@interface EventListController_iPhone () <UITableViewDataSource, UITableViewDelegate, EventListTableViewDelegate>

@property (weak, nonatomic) IBOutlet EventListTableView *ctlTableView;

- (IBAction)btMenuHandler:(id)sender;
- (IBAction)btTodayHandler:(id)sender;

@end

@implementation EventListController_iPhone {
    AppModel *_appModel;

    EventListTableModelDecoratorForUITableView *_eventListTableModelDecorator;
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

    UIBarButtonItem *btBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_btn"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = btBack;

    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;

    UIBarButtonItem *btToday = [[UIBarButtonItem alloc] initWithTitle:@"Сегодня" style:UIBarButtonItemStylePlain target:self action:@selector(btTodayHandler:)];
    self.navigationItem.rightBarButtonItem = btToday;

    [self scrollToTodayAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadData];
}

#pragma mark Button Handlers

- (IBAction)btMenuHandler:(id)sender {
    [[AppDelegate shared].mainController showLeftPanel:YES];
}

- (IBAction)btTodayHandler:(id)sender {
    [self scrollToTodayAnimated:YES];
}

#pragma mark UITableView Handlers

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_eventListTableModelDecorator numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_eventListTableModelDecorator numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [UILabel new];

    label.textColor = [UIColor colorWithHex:0xFF033143];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellheader_background"]];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];

    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListCell_iPhone *cell = [EventListCell_iPhone dequeOrCreateInTable:tableView];

    cell.eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(EventListCell_iPhone *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background"]];

    cell.ctlDateBackground.image = [[UIImage imageNamed:@"white-icon-overlay"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{5, 5, 5, 5}")];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    EventListGroup *eventListGroup = [_eventListTableModelDecorator eventListGroupBySection:section];

    return [self.eventListHandler sectionTitle:eventListGroup];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListItem *eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];

    [self.eventListHandler openEditorForViewController:self withEventListItem:eventListItem];
}

- (void)recalculateOffsetForTableView:(UITableView *)tableView {
    CGPoint contentOffset  = tableView.contentOffset;

    CGFloat sectionHeight = [tableView sectionHeaderHeight];
    CGFloat height = [tableView rowHeight];

    if (contentOffset.y <= 0) {
        [_eventListTableModelDecorator loadPrevSection];
        [self.ctlTableView reloadData];

        NSInteger numberOfRowsInSection = [tableView numberOfRowsInSection:0];
        contentOffset.y = 1 * (sectionHeight + numberOfRowsInSection * height);
    } else if (contentOffset.y >= (tableView.contentSize.height - tableView.bounds.size.height)) {
        [_eventListTableModelDecorator loadNextSection];
        [self.ctlTableView reloadData];

        NSInteger numberOfRowsInSection = [tableView numberOfRowsInSection:[tableView numberOfSections] - 1];
        contentOffset.y = tableView.contentSize.height - 1 * (sectionHeight + numberOfRowsInSection * height) - tableView.bounds.size.height;
    }

    [tableView setContentOffset: contentOffset];
}

- (void)scrollToTodayAnimated:(BOOL)animated {
    _eventListTableModelDecorator = [[EventListTableModelDecoratorForUITableView alloc] initWithEventListTableModel:self.eventListTableModel];
    [_eventListTableModelDecorator loadSectionsAroundDate:[NSDate date]];

    [self.ctlTableView reloadData];
    [self.ctlTableView scrollToRowAtIndexPath:[_eventListTableModelDecorator currentIndexPath] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)reloadData {
    CGPoint contentOffset = self.ctlTableView.contentOffset;

    [_eventListTableModelDecorator reloadData];

    [self.ctlTableView reloadData];

    self.ctlTableView.contentOffset = contentOffset;
}

@end
