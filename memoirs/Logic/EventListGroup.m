//
//  EventListGroup.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListGroup.h"

@implementation EventListGroup

- (id)init {
    self = [super init];
    if (self) {
        self.eventListItems = [NSMutableArray new];
    }
    return self;
}

@end
