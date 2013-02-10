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

- (id)initWithEvent:(Event *)event andDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.event = event;
        self.startDate = date;
        self.endDate = date;
    }
    return self;
}

- (id)initWithEvent:(Event *)event startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self = [super init];
    if (self) {
        self.event = event;
        self.startDate = startDate;
        self.endDate = endDate;
    }
    return self;
}

@end
