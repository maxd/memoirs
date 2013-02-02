//
//  UIBorderLabel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBorderLabel : UILabel

@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat leftInset;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) CGFloat rightInset;

@end
