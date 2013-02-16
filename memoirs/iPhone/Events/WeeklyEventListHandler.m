//
//  WeeklyEventListHandler.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "WeeklyEventListHandler.h"
#import "AppModel.h"
#import "EventListGroup.h"
#import "EventListItem.h"
#import "EventEditorController_iPhone.h"

@interface WeeklyEventListHandler () <EventEditorController_iPhoneDelegate>

@end

@implementation WeeklyEventListHandler {
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
    return NSLocalizedString(@"All Events", @"NavBar title");
}

- (NSString *)sectionTitle:(EventListGroup *)eventListGroup {
    NSString *startDateFormatted = [NSDateFormatter localizedStringFromDate:eventListGroup.startDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    NSString *endDateFormatted = [NSDateFormatter localizedStringFromDate:eventListGroup.endDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];

    return [NSString stringWithFormat:NSLocalizedString(@"Week from %@ till %@", @"Section title"), startDateFormatted, endDateFormatted];
}

- (void)openEditorForViewController:(UIViewController *)viewController withEventListItem:(EventListItem *)eventListItem {
    EventEditorController_iPhone *eventEditorController = [[EventEditorController_iPhone alloc] initWithAppModel:_appModel];
    eventEditorController.delegate = self;

    eventEditorController.eventListItem = eventListItem;

    [viewController.navigationController pushViewController:eventEditorController animated:YES];
}

- (void)dismissEventEditorController:(EventEditorController_iPhone *)eventEditorController {
    [eventEditorController.navigationController popViewControllerAnimated:YES];
}

@end
