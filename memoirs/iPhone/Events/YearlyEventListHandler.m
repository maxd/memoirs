//
//  YearlyEventListHandler.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "YearlyEventListHandler.h"
#import "EventListGroup.h"
#import "EventSelectorController_iPhone.h"
#import "AppModel.h"
#import "EventListItem.h"
#import "Event.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSDate+MTDates.h"
#import "GAI.h"

@interface YearlyEventListHandler () <EventSelectorControllerDelegate_iPhone>

@end

@implementation YearlyEventListHandler {
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
    return [eventListGroup.startDate stringFromDateWithFormat:@"yyyy"];
}

- (void)openEditorForViewController:(UIViewController *)viewController withEventListItem:(EventListItem *)eventListItem {
    EventSelectorController_iPhone *eventSelectorController = [[EventSelectorController_iPhone alloc] init];
    eventSelectorController.title = @"Выберите событие месяца";
    eventSelectorController.emptyMessage = @"Чтобы выбрать главное событие месяца сначала выберите главные события недели открыв раздел \"События недели\" в меню.";
    eventSelectorController.delegate = self;
    eventSelectorController.events = [_appModel mostImportantEventsOfWeeksBetween:eventListItem.startDate and:eventListItem.endDate];

    [viewController.navigationController pushViewController:eventSelectorController animated:YES];
}

- (void)eventSelectorController:(EventSelectorController_iPhone *)eventSelectorController didSelectEvent:(Event *)event {
    for (Event *e in eventSelectorController.events) {
        e.isImportantDateOfMonth = NO;
        e.isImportantDateOfYear = NO;
    }
    event.isImportantDateOfMonth = YES;
    [_appModel.context save];

    [eventSelectorController.navigationController popViewControllerAnimated:YES];

    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"User Action" withAction:@"Button Touch" withLabel:@"Select Monthly Event" withValue:nil];
}

@end
