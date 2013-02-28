//
//  PurchaseController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/27/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "PurchaseController_iPhone.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "ProductIdentifiers.h"
#import "PurchaseFullVersionProductActivator.h"
#import "WCAlertView.h"
#import "InAppPurchaseManager.h"
#import "SKProduct+LocalizedPrice.h"
#import "WCAlertViewAlertHandler.h"
#import "NVUIGradientButton.h"
#import "UIColor+Helpers.h"

@interface PurchaseController_iPhone ()

@property (weak, nonatomic) IBOutlet UILabel *lblPurchasedFullVersion;

@property (weak, nonatomic) IBOutlet NVUIGradientButton *btPurchase;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btRestorePurchase;

@end

@implementation PurchaseController_iPhone {

    InAppPurchaseManager *_inAppPurchaseManager;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Purchase", @"NavBar title");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]];
    
    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuHandler:)];
    self.navigationItem.leftBarButtonItem = btMenu;
    
    self.btPurchase.text = NSLocalizedString(@"Full Version", @"Purchase button");
    self.btPurchase.tintColor = [UIColor colorWithHex:0xFFC61214];
    self.btPurchase.highlightedTintColor = [UIColor colorWithHex:0xFFB40A0B];
    self.btPurchase.textColor = [UIColor whiteColor];
    
    self.btRestorePurchase.text = NSLocalizedString(@"Restore Purchases", @"Restore Purchases button");
    self.btRestorePurchase.textColor = [UIColor blackColor];
    
    self.lblPurchasedFullVersion.text = NSLocalizedString(@"Thank you for purchase full version!", @"Purchase - Label text");

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(inAppPurchaseStartedHandler:)
                   name:IN_APP_PURCHASE_STARTED_NOTIFICATION
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(inAppPurchaseFinishedHandler:)
                   name:IN_APP_PURCHASE_FINISHED_NOTIFICATION
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(productsUpdateSuccessHandler:)
                   name:IN_APP_PURCHASE_PRODUCTS_UPDATE_SUCCESS_NOTIFICATION
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(fullVersionPurchased:)
                   name:FULL_VERSION_PURCHASED_NOTIFICATION
                 object:nil];

    BOOL isFullVersionPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:PURCHASE_FULL_VERSION_PRODUCT_IDENTIFIER] boolValue];
    self.btPurchase.enabled = NO;
    self.btPurchase.hidden = isFullVersionPurchased;
    self.btRestorePurchase.enabled = NO;
    self.btRestorePurchase.hidden = isFullVersionPurchased;
    self.lblPurchasedFullVersion.hidden = !isFullVersionPurchased;

    if (!isFullVersionPurchased) {
        WCAlertViewAlertHandler *alertHandler = [WCAlertViewAlertHandler new];
        _inAppPurchaseManager = [[InAppPurchaseManager alloc] initWithAlertHandler:alertHandler];
        [_inAppPurchaseManager addProductActivator:[PurchaseFullVersionProductActivator new]];
        [_inAppPurchaseManager updateProducts];
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];
}

#pragma mark In-App Purchase Handler

- (IBAction)purchaseHandler:(id)sender {
    if (_inAppPurchaseManager.canMakePurchases) {
        [_inAppPurchaseManager purchaseProduct:PURCHASE_FULL_VERSION_PRODUCT_IDENTIFIER];
    } else {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                                            message:NSLocalizedString(@"Purchases locked on this device.", @"Alert text")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

        [alertView show];
    }
}

- (IBAction)restorePurchasesHandler:(id)sender {
    if (_inAppPurchaseManager.canMakePurchases) {
        [_inAppPurchaseManager restorePurchases];
    } else {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                                            message:NSLocalizedString(@"Purchases locked on this device.", @"Alert text")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

        [alertView show];
    }
}

- (void)inAppPurchaseStartedHandler:(NSNotification *)notification {
    self.btPurchase.enabled = NO;
    self.btRestorePurchase.enabled = NO;
}

- (void)inAppPurchaseFinishedHandler:(NSNotification *)notification {
    self.btPurchase.enabled = YES;
    self.btRestorePurchase.enabled = YES;
}

- (void)productsUpdateSuccessHandler:(id)sender {
    SKProduct *product = [_inAppPurchaseManager productByIdentifier:PURCHASE_FULL_VERSION_PRODUCT_IDENTIFIER];

    if (product) {
        self.btPurchase.enabled = YES;
        self.btRestorePurchase.enabled = YES;

        self.btPurchase.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.btPurchase.text = [NSString stringWithFormat:@"%@ %@", product.localizedTitle, product.localizedPrice];
    }
}

- (void)fullVersionPurchased:(NSNotification *)notification {
    BOOL hideInAppButtons = ![[notification.userInfo objectForKey:@"visible"] boolValue];

    self.btPurchase.hidden = hideInAppButtons;
    self.btRestorePurchase.hidden = hideInAppButtons;
    
    self.lblPurchasedFullVersion.hidden = !hideInAppButtons;
}

#pragma mark Action Handlers

- (void)btMenuHandler:(id)sender {
    [self.sidePanelController showLeftPanel:YES];
}

@end
