//
//  PagedScrollView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 3/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "PagedScrollView.h"
#import <QuartzCore/CATransaction.h>

const CGFloat PageControlHeight = 23.0;

@interface PagedScrollView ()

@end

@implementation PagedScrollView {
    NSMutableArray *views;
    UIPageControl *pageControl;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;

        views = [NSMutableArray new];

        CGRect pageControlFrame = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, PageControlHeight);
        pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
        [pageControl addTarget:self action:@selector(changePageHandler:) forControlEvents:UIControlEventValueChanged];
        pageControl.defersCurrentPageDisplay = YES;
        pageControl.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
        [self addSubview:pageControl];
    }
    return self;
}

#pragma mark Interface methods

- (NSUInteger)page {
    return (NSUInteger)((self.contentOffset.x + self.frame.size.width / 2) / self.frame.size.width);
}

- (void)setPage:(NSUInteger)page {
    [self setPage:page animated:NO];
}

- (void)setPage:(NSUInteger)page animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(page * self.frame.size.width, -self.scrollIndicatorInsets.top) animated:animated];
}

- (NSUInteger)pageCount {
    return views.count;
}

- (void)addPage:(UIView *)view {
    [self addPage:view atIndex:views.count];
}

- (void)addPage:(UIView *)view atIndex:(NSUInteger)index {
    [self insertSubview:view atIndex:index];
    [views insertObject:view atIndex:index];
    [self updateViewPositionAndPageControl];
    self.contentOffset = CGPointMake(0, -self.scrollIndicatorInsets.top);
}

- (void)removePage:(UIView *)view {
    [view removeFromSuperview];
    
    [views removeObject:view];
    [self updateViewPositionAndPageControl];
}

- (void)removePageAtIndex:(NSUInteger)index {
    [self removePage:[views objectAtIndex:index]];
}

- (void)removeAllPages {
    for (UIView* view in views) {
        [view removeFromSuperview];
    }
    
    [views removeAllObjects];
    [self updateViewPositionAndPageControl];
}

#pragma mark Layout Handlers

- (void)updateViewPositionAndPageControl {
    for (NSUInteger i = 0; i < views.count; i++) {
        UIView *view = views[i];

        view.frame = self.frame;
        view.center = CGPointMake(i * self.frame.size.width + self.frame.size.width / 2, self.frame.size.height / 2);
    }

    UIEdgeInsets inset = self.scrollIndicatorInsets;
    CGFloat heightInset = inset.top + inset.bottom;
    self.contentSize = CGSizeMake(self.frame.size.width * views.count, self.frame.size.height - heightInset);
    
    pageControl.numberOfPages = views.count;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGRect frame = pageControl.frame;
    frame.origin.x = self.contentOffset.x;
    frame.origin.y = self.frame.size.height - PageControlHeight - self.scrollIndicatorInsets.bottom - self.scrollIndicatorInsets.top;
    frame.size.width = self.frame.size.width;
    pageControl.frame = frame;
    
    [CATransaction commit];
}

#pragma mark Helper methods

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    [self updateViewPositionAndPageControl];
}

- (void)changePageHandler:(UIPageControl *)aPageControl {
    [self setPage:(NSUInteger)aPageControl.currentPage animated:YES];
}

- (void)setContentOffset:(CGPoint)point {
    point.y = -self.scrollIndicatorInsets.top;
    [super setContentOffset:point];
    
    pageControl.currentPage = self.page;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    if (pagingEnabled) {
        [super setPagingEnabled:pagingEnabled];
    } else {
        [NSException raise:@"Disabling pagingEnabled" format:@"PagedScrollView must be set pagingEnabled to YES always."];
    }
}

@end
