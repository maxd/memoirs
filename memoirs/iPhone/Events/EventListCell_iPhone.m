//
//  EventListCell_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "EventListCell_iPhone.h"
#import "EventListItem.h"
#import "NSDate+MTDates.h"
#import "Event.h"

@interface EventListCell_iPhone ()

@property (weak, nonatomic) IBOutlet UILabel *lblTopDate;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCenterDate;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UILabel *lblImportantEvent;

@property (weak, nonatomic) IBOutlet UIImageView *ctlDateBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnimatedHighlight;

@end

@implementation EventListCell_iPhone

- (void)setEventListItem:(EventListItem *)eventListItem {
    _eventListItem = eventListItem;

    Event *event = eventListItem.event;

    if (event) {
        // http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
        self.lblTopDate.text = [event.date stringFromDateWithFormat:@"d"];
        self.lblBottomDate.text = [event.date stringFromDateWithFullMonth];
        self.lblCenterDate.text = @"";
        self.lblText.text = event.text;

        self.ctlDateBackground.image = [UIImage imageNamed:@"date_holder_blue"];
    } else {
        if ([eventListItem.startDate isWithinSameDay:eventListItem.endDate]) {
            self.lblTopDate.text = [eventListItem.startDate stringFromDateWithFormat:@"d"];
            self.lblBottomDate.text = [eventListItem.startDate stringFromDateWithFullMonth];
            self.lblCenterDate.text = @"";
        } else if ([eventListItem.startDate isWithinSameWeek:eventListItem.endDate]) {
            self.lblTopDate.text = @"";
            self.lblBottomDate.text = @"";
            self.lblCenterDate.text = [eventListItem.endDate stringFromDateWithFormat:@"LLLL"];
        } else if ([eventListItem.startDate isWithinSameMonth:eventListItem.endDate]) {
            self.lblTopDate.text = @"";
            self.lblBottomDate.text = @"";
            self.lblCenterDate.text = [eventListItem.endDate stringFromDateWithFormat:@"LLLL"];
        } else {
            self.lblTopDate.text = @"";
            self.lblBottomDate.text = @"";
            self.lblCenterDate.text = @"";
        }
        self.lblText.text = @"";
        self.ctlDateBackground.image = [UIImage imageNamed:@"date_holder"];
    }

    if ([[NSDate date] isBetweenDate:eventListItem.startDate andDate:eventListItem.endDate]) {
        [self highlightWithAnimation];
    }
}

- (void)highlightWithAnimation {
    CGRect rect;

    rect = self.imgAnimatedHighlight.frame;
    rect.origin.x = -self.imgAnimatedHighlight.frame.size.width;
    self.imgAnimatedHighlight.frame = rect;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.6];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    rect = self.imgAnimatedHighlight.frame;
    rect.origin.x = self.frame.size.width + self.imgAnimatedHighlight.frame.size.width;
    self.imgAnimatedHighlight.frame = rect;

    [UIView commitAnimations];
}

@end
