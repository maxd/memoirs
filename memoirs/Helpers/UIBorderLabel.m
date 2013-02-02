//
//  UIBorderLabel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "UIBorderLabel.h"

@implementation UIBorderLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.topInset, self.leftInset, self.bottomInset, self.rightInset};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
