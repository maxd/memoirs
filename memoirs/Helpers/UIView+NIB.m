//
//  UIView+NIB.m
//  memoirs
//
//  Created by Maxim Dobryakov on 3/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//
#import "UIView+NIB.h"

@implementation UIView (NIB)

+ (NSString *)nibName {
    return [self description];
}

+ (id)loadFromNIB:(NSString *)nibName owner:(id)owner {
    Class klass = [self class];
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    
    for (id object in objects) {
        if ([object isKindOfClass:klass]) {
            return object;
        }
    }
    
    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", nibName, NSStringFromClass(klass)];

    return nil;
}

+ (id)loadFromNIBWithOwner:(id)owner {
    return [self loadFromNIB:[self nibName] owner:owner];
}

+ (id)loadFromNIB:(NSString *)nibName {
    return [self loadFromNIB:nibName owner:self];
}

+ (id)loadFromNIB {
    return [self loadFromNIBWithOwner:self];
}

@end
