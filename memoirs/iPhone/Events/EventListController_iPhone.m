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
#import "GAITracker.h"
#import "NSDate+MTDates.h"

@interface EventListController_iPhone () <UITableViewDataSource, UITableViewDelegate, EventListTableViewDelegate>

@property (weak, nonatomic) IBOutlet EventListTableView *ctlTableView;

- (IBAction)btMenuHandler:(id)sender;
- (IBAction)btTodayHandler:(id)sender;

@end

@implementation EventListController_iPhone {
    AppModel *_appModel;

    UIColor *_highlightedBackground;
    UIColor *_regularBackground;

    EventListTableModelDecoratorForUITableView *_eventListTableModelDecorator;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;

        _highlightedBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg_highlight"]];
        _regularBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trackedViewName = @"Event List";

    self.ctlTableView.scrollsToTop = NO;

    UIBarButtonItem *btBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_btn"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = btBack;

    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;

    UIBarButtonItem *btToday = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", @"Button text") style:UIBarButtonItemStylePlain target:self action:@selector(btTodayHandler:)];
    self.navigationItem.rightBarButtonItem = btToday;

    [self scrollToTodayAnimated:NO];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(applicationDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bg"]];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    EventListGroup *eventListGroup = [_eventListTableModelDecorator eventListGroupBySection:section];

    return [self.eventListHandler sectionTitle:eventListGroup];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListItem *eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];

    [self.eventListHandler openEditorForViewController:self withEventListItem:eventListItem];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListItem *eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];

    if ([[NSDate date] isBetweenDate:eventListItem.startDate andDate:eventListItem.endDate]) {
        cell.backgroundColor = _highlightedBackground;
    } else {
        cell.backgroundColor = _regularBackground;
    }
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

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[_eventListTableModelDecorator indexPathForDate:[NSDate date]].section];
    [self.ctlTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];

    [self.tracker sendEventWithCategory:@"User Action" withAction:@"Button Touch" withLabel:@"Today" withValue:nil];
}

- (void)openEventListEditorForDate:(NSDate *)date {
    NSIndexPath *indexPath = [_eventListTableModelDecorator indexPathForDate:date];
    EventListItem *eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];

    [self.eventListHandler openEditorForViewController:self withEventListItem:eventListItem];
}

- (void)reloadData {
    CGPoint contentOffset = self.ctlTableView.contentOffset;

    [_eventListTableModelDecorator reloadData];

    [self.ctlTableView reloadData];

    self.ctlTableView.contentOffset = contentOffset;
}

#pragma mark NotificationCenter Handlers

- (void)applicationDidBecomeActive:(id)sender {
    [self scrollToTodayAnimated:NO];
}

@end
