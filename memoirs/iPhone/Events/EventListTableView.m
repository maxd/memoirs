//
//  EventListTableView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/27/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListTableView.h"

@implementation EventListTableView

@dynamic delegate;

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetContentOffsetIfNeeded];
}

- (void)resetContentOffsetIfNeeded {
    [self.delegate recalculateOffsetForTableView:self];
}

@end
