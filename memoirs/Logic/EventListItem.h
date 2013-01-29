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

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) Event *event;

- (id)initWithDate:(NSDate *)date andEvent:(Event *)event;

@end
