//
//  PurchaseFullVersionProductActivator.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/27/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "PurchaseFullVersionProductActivator.h"
#import "ProductIdentifiers.h"

@implementation PurchaseFullVersionProductActivator

- (NSString *)productIdentifier {
    return PURCHASE_FULL_VERSION_PRODUCT_IDENTIFIER;
}

- (BOOL)activateProduct:(SKPaymentTransaction *)transaction {
    BOOL result = [super activateProduct:transaction];

    [[NSNotificationCenter defaultCenter]
            postNotificationName:FULL_VERSION_PURCHASED_NOTIFICATION
                          object:self
                        userInfo:[NSDictionary dictionaryWithObject:@(NO) forKey:@"visible"]];

    return result;
}

@end
