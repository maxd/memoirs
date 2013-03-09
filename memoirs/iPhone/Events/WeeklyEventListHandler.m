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
#import "WCAlertView.h"
#import "MainController_iPhone.h"
#import "UIViewController+JASidePanel.h"
#import "ProductIdentifiers.h"

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

    return [NSString stringWithFormat:NSLocalizedString(@"%@ – %@", @"Section title"), startDateFormatted, endDateFormatted];
}

- (void)openEditorForViewController:(UIViewController *)viewController withEventListItem:(EventListItem *)eventListItem {

#ifdef LITE
    BOOL isFullVersionPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:PURCHASE_FULL_VERSION_PRODUCT_IDENTIFIER] boolValue];
    NSInteger eventCount = [_appModel eventCount];

    if (!isFullVersionPurchased && eventCount >= 14) {
        [WCAlertView showAlertWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                message:NSLocalizedString(@"Purchase full version to add more events.", @"Alert text")
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [(MainController_iPhone *)viewController.sidePanelController showPurchase];
                            }
                        }
                      cancelButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"Close", @"Button title"), NSLocalizedString(@"\U0001F4B0 Purchase", @"Button title"), nil];
        return;
    }
#endif
    
    EventEditorController_iPhone *eventEditorController = [[EventEditorController_iPhone alloc] initWithAppModel:_appModel];
    eventEditorController.delegate = self;

    eventEditorController.eventListItem = eventListItem;

    [viewController.navigationController pushViewController:eventEditorController animated:YES];
}

- (void)dismissEventEditorController:(EventEditorController_iPhone *)eventEditorController {
    [eventEditorController.navigationController popViewControllerAnimated:YES];
}

@end
