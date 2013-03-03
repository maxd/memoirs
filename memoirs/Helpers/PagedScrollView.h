//
//  PagedScrollView.h
//  memoirs
//
//  Created by Maxim Dobryakov on 3/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedScrollView : UIScrollView

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign, readonly) NSUInteger pageCount;

- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

- (void)addPage:(UIView *)view;
- (void)addPage:(UIView *)view atIndex:(NSUInteger)index;

- (void)removePage:(UIView *)view;
- (void)removePageAtIndex:(NSUInteger)index;
- (void)removeAllPages;

- (id)initWithCoder:(NSCoder *)coder;

@end
