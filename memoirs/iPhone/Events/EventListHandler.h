//
//  EventListHandler.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventListGroup;
@class EventListItem;

@protocol EventListHandler <NSObject>

- (NSString *)navBarTitle;

- (NSString *)sectionTitle:(EventListGroup *)eventListGroup;

- (void)openEditorForViewController:(UIViewController *)viewController withEventListItem:(EventListItem *)eventListItem;

@end
