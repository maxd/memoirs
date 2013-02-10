//
//  MonthlyEventListHandler.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "MonthlyEventListHandler.h"
#import "EventListGroup.h"
#import "EventSelectorController_iPhone.h"
#import "Event.h"
#import "AppModel.h"
#import "EventListItem.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSDate+MTDates.h"

@interface MonthlyEventListHandler () <EventSelectorControllerDelegate_iPhone>

@end

@implementation MonthlyEventListHandler {
    AppModel *_appModel;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
    }
    return self;
}

- (NSString *)navBarTitle {
    return @"События месяца";
}

- (NSString *)sectionTitle:(EventListGroup *)eventListGroup {
    return [eventListGroup.startDate stringFromDateWithFormat:@"LLLL yyyy"];
}

- (void)openEditorForViewController:(UIViewController *)viewController withEventListItem:(EventListItem *)eventListItem {
    EventSelectorController_iPhone *eventSelectorController = [[EventSelectorController_iPhone alloc] init];
    eventSelectorController.delegate = self;
    eventSelectorController.events = [_appModel eventsBetween:eventListItem.startDate and:eventListItem.endDate];

    [viewController.navigationController pushViewController:eventSelectorController animated:YES];
}

- (void)eventSelectorController:(EventSelectorController_iPhone *)eventSelectorController didSelectEvent:(Event *)event {
    for (Event *e in eventSelectorController.events) {
        e.isImportantDateOfWeek = NO;
    }
    event.isImportantDateOfWeek = YES;
    [_appModel.context save];

    [eventSelectorController.navigationController popViewControllerAnimated:YES];
}

@end
