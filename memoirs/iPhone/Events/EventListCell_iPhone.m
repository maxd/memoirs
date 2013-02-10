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
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UILabel *lblImportantEvent;

@property (weak, nonatomic) IBOutlet UIImageView *imgAnimatedHighlight;

@end

@implementation EventListCell_iPhone

- (void)setEventListItem:(EventListItem *)eventListItem {
    _eventListItem = eventListItem;

    Event *event = eventListItem.event;

    if (event) {
        // http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
        self.lblTopDate.text = [event.date stringFromDateWithFormat:@"dd"];
        self.lblBottomDate.text = [event.date stringFromDateWithFullMonth];
        self.lblText.text = event.text;

        if (event.isImportantDateOfYear) {
            self.lblImportantEvent.text = @"\U0001F49D";
        } else if (event.isImportantDateOfMonth) {
            self.lblImportantEvent.text = @"\U0001F49B";
        } else if (event.isImportantDateOfWeek) {
            self.lblImportantEvent.text = @"\U0001F49A";
        } else {
            self.lblImportantEvent.text = @"";
        }
    } else {
        if ([eventListItem.startDate isWithinSameDay:eventListItem.endDate]) {
            self.lblTopDate.text = [eventListItem.startDate stringFromDateWithFormat:@"dd"];
            self.lblBottomDate.text = [eventListItem.startDate stringFromDateWithFullMonth];
        } else if ([eventListItem.startDate isWithinSameWeek:eventListItem.endDate]) {
            self.lblTopDate.text = @"?";
            self.lblBottomDate.text = [eventListItem.endDate stringFromDateWithFormat:@"LLLL"];
        } else if ([eventListItem.startDate isWithinSameMonth:eventListItem.endDate]) {
            self.lblTopDate.text = @"?";
            self.lblBottomDate.text = [eventListItem.endDate stringFromDateWithFormat:@"LLLL"];
        } else {
            self.lblTopDate.text = @"";
            self.lblBottomDate.text = @"";
        }
        self.lblText.text = @"";
        self.lblImportantEvent.text = @"";
    }

    if ([[NSDate date] isBetweenDate:eventListItem.startDate andDate:eventListItem.endDate]) {
        [self highlightWithAnimation];
    }
}

- (void)awakeFromNib {
    self.ctlDateBackground.image = [[UIImage imageNamed:@"white-icon-overlay"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{5, 5, 5, 5}")];
}

- (void)highlightWithAnimation {
    CGRect rect;

    rect = self.imgAnimatedHighlight.frame;
    rect.origin.x = -self.imgAnimatedHighlight.frame.size.width;
    self.imgAnimatedHighlight.frame = rect;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    rect = self.imgAnimatedHighlight.frame;
    rect.origin.x = self.frame.size.width + self.imgAnimatedHighlight.frame.size.width;
    self.imgAnimatedHighlight.frame = rect;

    [UIView commitAnimations];
}

@end
