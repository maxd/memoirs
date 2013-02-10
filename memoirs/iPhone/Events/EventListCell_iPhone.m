//
//  EventListCell_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventListCell_iPhone.h"
#import "EventListItem.h"
#import "NSDate+MTDates.h"
#import "Event.h"

@interface EventListCell_iPhone ()

@property (weak, nonatomic) IBOutlet UILabel *lblTopDate;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomDate;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UILabel *lblImportantEvent;

@end

@implementation EventListCell_iPhone

- (void)setEventListItem:(EventListItem *)eventListItem {
    _eventListItem = eventListItem;

    NSDate *date = eventListItem.startDate;

    NSUInteger dayOfMonth = [date dayOfMonth];

    self.lblTopDate.text = dayOfMonth > 0 ? [@(dayOfMonth) stringValue]: nil;
    self.lblBottomDate.text = [date stringFromDateWithFullMonth];
    self.lblText.text = eventListItem.event ? eventListItem.event.text : @"";
    
    if (eventListItem.event.isImportantDateOfYear) {
        self.lblImportantEvent.text = @"\U0001F49D";
    } else if (eventListItem.event.isImportantDateOfMonth) {
        self.lblImportantEvent.text = @"\U0001F49B";
    } else if (eventListItem.event.isImportantDateOfWeek) {
        self.lblImportantEvent.text = @"\U0001F49A";
    } else {
        self.lblImportantEvent.text = @"";
    }
}

- (void)awakeFromNib {
    self.ctlDateBackground.image = [[UIImage imageNamed:@"white-icon-overlay"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{5, 5, 5, 5}")];
}

@end
