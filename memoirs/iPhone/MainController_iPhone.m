//
//  MainController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "MainController_iPhone.h"
#import "EventListMenuController_iPhone.h"
#import "EventListController_iPhone.h"

@interface MainController_iPhone ()

@end

@implementation MainController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.centerViewController = [[UINavigationController alloc] initWithRootViewController:[[EventListController_iPhone alloc] init]];
    self.leftViewController = [[EventListMenuController_iPhone alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
