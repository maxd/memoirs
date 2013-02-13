//
//  NotificationManager.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/12/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "NotificationManager.h"
#import "AppModel.h"
#import "NSDate+MTDates.h"

@implementation NotificationManager {
    AppModel *_appModel;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
    }
    return self;
}

- (void)rescheduleNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    [self scheduleDailyNotification];
    [self scheduleWeeklyNotification];
    [self scheduleMonthlyNotification];
}

- (void)scheduleDailyNotification {
    UILocalNotification *localNotification = [UILocalNotification new];

    NSDate *date = [[NSDate date] endOfCurrentDay];
    NSDate *fireDate = [NSDate dateFromYear:date.year month:date.monthOfYear day:date.dayOfMonth hour:self.alertHour minute:self.alertMinute];

    if ([_appModel isEventOfDayExists:fireDate]) {
        fireDate = [fireDate oneDayNext];
    }

    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.alertAction = @"Записать";
    localNotification.alertBody = @"Запишите главное событие вашего дня в Мемуарник.";

    if (self.enableAlertSound) {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }

    localNotification.userInfo = @{
        @"type": @"daily"
    };

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)scheduleWeeklyNotification {
    UILocalNotification *localNotification = [UILocalNotification new];

    NSDate *date = [[NSDate date] endOfCurrentWeek];
    NSDate *fireDate = [NSDate dateFromYear:date.year month:date.monthOfYear day:date.dayOfMonth hour:self.alertHour minute:self.alertMinute];

    if ([_appModel isEventOfWeekExists:fireDate]) {
        fireDate = [fireDate oneWeekNext];
    }

    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSWeekCalendarUnit;
    localNotification.alertAction = @"Выбрать";
    localNotification.alertBody = @"Выберите главное событие недели в Мемуарнике.";

    if (self.enableAlertSound) {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }

    localNotification.userInfo = @{
            @"type": @"weekly"
    };

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)scheduleMonthlyNotification {
    UILocalNotification *localNotification = [UILocalNotification new];

    NSDate *date = [[NSDate date] endOfCurrentMonth];
    NSDate *fireDate = [NSDate dateFromYear:date.year month:date.monthOfYear day:date.dayOfMonth hour:self.alertHour minute:self.alertMinute];

    if ([_appModel isEventOfMonthExists:fireDate]) {
        fireDate = [fireDate oneMonthNext];
    }

    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSMonthCalendarUnit;
    localNotification.alertAction = @"Выбрать";
    localNotification.alertBody = @"Выберите главное событие месяца в Мемуарнике.";

    if (self.enableAlertSound) {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }

    localNotification.userInfo = @{
            @"type": @"monthly"
    };

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end