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
@property (weak, nonatomic) IBOutlet UILabel *txtText;
@property (weak, nonatomic) IBOutlet UILabel *lblImportantEvent;

@end

@implementation EventListCell_iPhone

- (void)setEventListItem:(EventListItem *)eventListItem {
    _eventListItem = eventListItem;

    self.lblTopDate.text = [@([eventListItem.date dayOfMonth]) stringValue];
    self.lblBottomDate.text = [eventListItem.date stringFromDateWithFullMonth];
    self.txtText.text = eventListItem.event ? eventListItem.event.text : @"";
    
    if ([eventListItem.event.mainPerYear boolValue]) {
        self.lblImportantEvent.text = @"\U0001F49D";
    } else if ([eventListItem.event.mainPerMonth boolValue]) {
        self.lblImportantEvent.text = @"\U0001F49B";
    } else if ([eventListItem.event.mainPerWeek boolValue]) {
        self.lblImportantEvent.text = @"\U0001F49A";
    } else {
        self.lblImportantEvent.text = @"";
    }
}

@end
