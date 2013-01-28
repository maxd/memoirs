//
//  EventListTableView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/27/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListTableView.h"

@implementation EventListTableView

- (void)layoutSubviews {
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
}

- (void)resetContentOffsetIfNeeded {
    CGPoint contentOffset  = self.contentOffset;

    CGFloat sectionHeight = [self sectionHeaderHeight];
    CGFloat height = [self rowHeight];

    NSInteger numberOfRowsInSection = [self numberOfRowsInSection:0];

    if (contentOffset.y <= 0) {
        contentOffset.y = 1 * (sectionHeight + numberOfRowsInSection * height);
    } else if (contentOffset.y >= (self.contentSize.height - self.bounds.size.height)) {
        contentOffset.y = self.contentSize.height - 1 * (sectionHeight + numberOfRowsInSection * height) - self.bounds.size.height;
    }

    [self setContentOffset: contentOffset];
}

@end
