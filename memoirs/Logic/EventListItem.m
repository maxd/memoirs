//
//  EventListItem.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/29/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListItem.h"
#import "Event.h"

@implementation EventListItem

- (id)initWithDate:(NSDate *)date andEvent:(Event *)event {
    self = [super init];
    if (self) {
        self.date = date;
        self.event = event;
    }
    return self;
}

@end
