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
#import "AppModel.h"
#import "EventListTableModelDecoratorForUITableView.h"
#import "EventListCell_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "EventListGroup.h"
#import "EventListItem.h"
#import "Event.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObject+Helpers.h"

@interface EventListController_iPhone () <UITableViewDataSource, UITableViewDelegate, EventEditorController_iPhoneDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;

- (IBAction)btMenuHandler:(id)sender;
- (IBAction)btTodayHandler:(id)sender;

@end

@implementation EventListController_iPhone {
    AppModel *_appModel;

    EventListTableModel *_eventListTableModel;
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
    
    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;

    UIBarButtonItem *btToday = [[UIBarButtonItem alloc] initWithTitle:@"Сегодня" style:UIBarButtonItemStylePlain target:self action:@selector(btTodayHandler:)];
    self.navigationItem.rightBarButtonItem = btToday;

    _eventListTableModel = [[EventListTableModel alloc] initWithAppModel:_appModel];
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

    cell.eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    EventListGroup *eventListGroup = [_eventListTableModelDecorator eventListGroupBySection:section];

    NSString *startDateFormatted = [NSDateFormatter localizedStringFromDate:eventListGroup.startDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    NSString *endDateFormatted = [NSDateFormatter localizedStringFromDate:eventListGroup.endDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
    return [NSString stringWithFormat:@"%@ - %@", startDateFormatted, endDateFormatted];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListItem *eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];

    EventEditorController_iPhone *eventEditorController = [[EventEditorController_iPhone alloc] initWithAppModel:_appModel];
    eventEditorController.delegate = self;

    eventEditorController.date = eventListItem.date;
    eventEditorController.value = eventListItem.event.value;
    eventEditorController.text = eventListItem.event.text;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eventEditorController];

    [self presentModalViewController:navigationController animated:YES];
}

- (void)eventEditorController:(EventEditorController_iPhone *)eventEditorController didFinishedWithSaveState:(BOOL)save {
    NSIndexPath *indexPath = [self.ctlTableView indexPathForSelectedRow];

    EventListItem *eventListItem = [_eventListTableModelDecorator eventListItemByIndexPath:indexPath];
    if (save) {
        if (!eventListItem.event) {
            eventListItem.event = [_appModel.context newObjectWithEntityName:[Event entityName]];
        }

        eventListItem.event.date = eventEditorController.date;
        eventListItem.event.value = eventEditorController.value;
        eventListItem.event.text = eventEditorController.text;

        [_appModel.context save];

        [self.ctlTableView reloadData];
    }

    [self dismissModalViewControllerAnimated:YES];
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
