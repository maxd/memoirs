//
//  ImportantValueListCell_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/15/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "ImportantValueListCell_iPhone.h"

@implementation ImportantValueListCell_iPhone

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.textLabel.frame;

    self.textLabel.frame = CGRectMake(frame.origin.x, (self.frame.size.height - frame.size.height) / 2, frame.size.width, frame.size.height);
}

@end
