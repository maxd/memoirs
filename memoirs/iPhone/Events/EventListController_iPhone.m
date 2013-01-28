//
//  EventListController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListController_iPhone.h"
#import "AppDelegate.h"
#import "EventEditorController_iPhone.h"
#import "EventListTableModel.h"
#import "EventListTableModelDecoratorForUITableView.h"
#import "EventListCell_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "EventListGroup.h"
#import "NSDate+MTDates.h"

@interface EventListController_iPhone () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;

- (IBAction)btMenuHandler:(id)sender;
- (IBAction)btTodayHandler:(id)sender;

@end

@implementation EventListController_iPhone {
    EventListTableModel *_eventListTableModel;
    EventListTableModelDecoratorForUITableView *_eventListTableModelDecorator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithTitle:@"Меню" style:UIBarButtonItemStyleDone target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;

    UIBarButtonItem *btToday = [[UIBarButtonItem alloc] initWithTitle:@"Сегодня" style:UIBarButtonItemStyleDone target:self action:@selector(btTodayHandler:)];
    self.navigationItem.rightBarButtonItem = btToday;

    _eventListTableModel = [EventListTableModel new];
    _eventListTableModelDecorator = [[EventListTableModelDecoratorForUITableView alloc] initWithEventListTableModel:_eventListTableModel];

    [self scrollToTodayAnimated:NO];
}

#pragma mark Button Handlers

- (IBAction)btMenuHandler:(id)sender {
    [[AppDelegate shared].mainController showLeft];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListCell_iPhone *cell = [EventListCell_iPhone dequeOrCreateInTable:tableView];

    cell.event = [_eventListTableModelDecorator eventByIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    EventListGroup *eventListGroup = [_eventListTableModelDecorator eventGroupBySection:section];

    return [NSString stringWithFormat:@"%@ - %@", [eventListGroup.startDate stringFromDateWithFormat:@"d MMM yyyy"], [eventListGroup.endDate stringFromDateWithFormat:@"d MMM yyyy"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventEditorController_iPhone *eventEditorController = [EventEditorController_iPhone new];
    [self.navigationController pushViewController:eventEditorController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat controlHeight = scrollView.bounds.size.height;

    if (contentHeight != 0) {
        if (actualPosition <= 0) {
            [_eventListTableModelDecorator loadPrev];
            [self.ctlTableView reloadData];
        } else if (actualPosition + controlHeight >= contentHeight) {
            [_eventListTableModelDecorator loadNext];
            [self.ctlTableView reloadData];
        }
    }
}

- (void)scrollToTodayAnimated:(BOOL)animated {
    [_eventListTableModelDecorator loadWeeksAroundCurrent];

    [self.ctlTableView reloadData];
    [self.ctlTableView scrollToRowAtIndexPath:[_eventListTableModelDecorator currentIndexPath] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

@end
