//
//  UIView+NIB.h
//  memoirs
//
//  Created by Maxim Dobryakov on 3/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIView (NIB)

+ (id)loadFromNIB;
+ (id)loadFromNIBWithOwner:(id)owner;
+ (id)loadFromNIB:(NSString *)nibName;
+ (id)loadFromNIB:(NSString *)nibName owner:(id)owner;

@end
