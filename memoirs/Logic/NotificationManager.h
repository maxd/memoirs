//
//  NotificationManager.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/12/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppModel;


@interface NotificationManager : NSObject

@property (assign, nonatomic) BOOL enableAlertSound;

@property (assign, nonatomic) NSUInteger alertHour;
@property (assign, nonatomic) NSUInteger alertMinute;

- (id)initWithAppModel:(AppModel *)appModel;

- (void)rescheduleNotifications;

@end
