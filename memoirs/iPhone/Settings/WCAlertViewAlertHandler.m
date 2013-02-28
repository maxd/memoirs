//
//  WCAlertViewAlertHandler.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/27/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "WCAlertViewAlertHandler.h"
#import "WCAlertView.h"

@implementation WCAlertViewAlertHandler

- (void)showWarning:(NSString *)message {
    [self showAlert:message withTitle:NSLocalizedString(@"Warning", @"Alert title")];
}

- (void)showError:(NSString *)message {
    [self showAlert:message withTitle:NSLocalizedString(@"Error", @"Alert title")];
}

- (void)showAlert:(NSString *)message withTitle:(NSString *)title {
    WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Close", @"Alert button")
                                              otherButtonTitles:nil];
    
    [alertView show];
}

@end
