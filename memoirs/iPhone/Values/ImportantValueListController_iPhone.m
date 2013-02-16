//
//  ImportantValueListController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/14/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "ImportantValueListController_iPhone.h"
#import "AppModel.h"
#import "ImportantValueListCell_iPhone.h"
#import "UITableViewCell+NIB.h"
#import "Value.h"

@interface ImportantValueListController_iPhone () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ctlTableView;

@end

@implementation ImportantValueListController_iPhone {
    AppModel *_appModel;

    NSArray *_values;
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

    self.trackedViewName = @"Important Values";

    self.title = NSLocalizedString(@"TOP Life Values", @"NavBar title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _values = [_appModel topValues];
}

#pragma mark UITableView Handlers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Value *value = [_values objectAtIndex:(NSUInteger) indexPath.row];

    ImportantValueListCell_iPhone *cell = [ImportantValueListCell_iPhone dequeOrCreateInTable:tableView];

    cell.textLabel.text = value.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Events: %d", @"Detail text of cell"), value.events.count];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background"]];
}

@end
