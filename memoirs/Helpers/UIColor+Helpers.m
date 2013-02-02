//
//  UIColor+Helpers.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

+ (UIColor *)colorWithHex:(NSUInteger)hex {
    int blue = hex & 0x000000FF;
    int green = ((hex & 0x0000FF00) >> 8);
    int red = ((hex & 0x00FF0000) >> 16);
    int alpha = ((hex & 0xFF000000) >> 24);
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}

@end
