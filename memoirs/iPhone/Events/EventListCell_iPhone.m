//
//  EventListCell_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListCell_iPhone.h"
#import "Event.h"

@interface EventListCell_iPhone ()

@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *txtText;

@end

@implementation EventListCell_iPhone

- (void)setEvent:(Event *)event {
    _event = event;

    self.txtText.text = @"test";
    
//    NSDateFormatter *df = [NSDateFormatter new];
//    
//    [df setDateFormat:@"dd"];
//    self.lblDay.text = [NSString stringWithFormat:@"%@", [df stringFromDate:event.date]];
//    
//    [df setDateFormat:@"MMM"];
//    self.lblMonth.text = [NSString stringWithFormat:@"%@", [df stringFromDate:event.date]];
//    
//    self.txtText.text = event.text;
}

@end
