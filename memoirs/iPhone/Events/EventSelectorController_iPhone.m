//
//  EventSelectorController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/8/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventSelectorController_iPhone.h"
#import "EventListCell_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "Event.h"
#import "EventListItem.h"

@interface EventSelectorController_iPhone () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyMessage;

@end

@implementation EventSelectorController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trackedViewName = @"Event Selector";
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]]];

    if (self.events.count > 0) {
        self.ctlTableView.tableHeaderView = nil;
    } else {
        self.lblEmptyMessage.text = self.emptyMessage;
    }
}

#pragma mark UITableView Handlers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListCell_iPhone *cell = [EventListCell_iPhone dequeOrCreateInTable:tableView];

    Event *event = [self.events objectAtIndex:(NSUInteger) indexPath.row];
    cell.eventListItem = [[EventListItem alloc] initWithEvent:event andDate:event.date];
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self.events objectAtIndex:(NSUInteger) indexPath.row];

    [self.delegate eventSelectorController:self didSelectEvent:event];
}

@end
