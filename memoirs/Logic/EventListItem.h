//
//  EventListItem.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/29/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface EventListItem : NSObject

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

- (id)initWithEvent:(Event *)event andDate:(NSDate *)date;

- (id)initWithEvent:(Event *)event startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
