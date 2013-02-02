//
//  UIImage+Resize.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;
}

@end
