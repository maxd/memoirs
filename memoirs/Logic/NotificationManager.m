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

//#define TEST_DAILY_NOTIFICATIONS    10
//#define TEST_WEEKLY_NOTIFICATIONS   10
//#define TEST_MONTHLY_NOTIFICATIONS  10

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

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"daily_reminders"]) {
        [self scheduleDailyNotification];
    }

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"weekly_reminders"]) {
        [self scheduleWeeklyNotification];
    }

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"monthly_reminders"]) {
        [self scheduleMonthlyNotification];
    }
}

- (void)scheduleDailyNotification {
    UILocalNotification *localNotification = [UILocalNotification new];

    NSDate *fireDate;

    #ifdef TEST_DAILY_NOTIFICATIONS
        fireDate = [NSDate dateWithTimeIntervalSinceNow:TEST_DAILY_NOTIFICATIONS];
    #else
        NSDate *date = [[NSDate date] endOfCurrentDay];
        fireDate = [NSDate dateFromYear:date.year month:date.monthOfYear day:date.dayOfMonth hour:self.alertHour minute:self.alertMinute];

        if ([_appModel isEventOfDayExists:fireDate]) {
            fireDate = [fireDate oneDayNext];
        }
    #endif

    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.alertAction = NSLocalizedString(@"Create Event", @"Remind title");
    localNotification.alertBody = NSLocalizedString(@"Please add the main event of the day to My Memoirs", @"Remind text");

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

    NSDate *fireDate;

    #ifdef TEST_WEEKLY_NOTIFICATIONS
        fireDate = [NSDate dateWithTimeIntervalSinceNow:TEST_WEEKLY_NOTIFICATIONS];
    #else
        NSDate *date = [[NSDate date] endOfCurrentWeek];
        fireDate = [NSDate dateFromYear:date.year month:date.monthOfYear day:date.dayOfMonth hour:self.alertHour minute:self.alertMinute];

        if ([_appModel isEventOfWeekExists:fireDate]) {
            fireDate = [fireDate oneWeekNext];
        }
    #endif

    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSWeekCalendarUnit;
    localNotification.alertAction = NSLocalizedString(@"Select Event", @"Remind title");
    localNotification.alertBody = NSLocalizedString(@"Select the main event of the week in My Memoirs", @"Remind text");

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

    NSDate *fireDate;

    #ifdef TEST_MONTHLY_NOTIFICATIONS
        fireDate = [NSDate dateWithTimeIntervalSinceNow:TEST_MONTHLY_NOTIFICATIONS];
    #else
        NSDate *date = [[NSDate date] endOfCurrentMonth];
        fireDate = [NSDate dateFromYear:date.year month:date.monthOfYear day:date.dayOfMonth hour:self.alertHour minute:self.alertMinute];

        if ([_appModel isEventOfMonthExists:fireDate]) {
            fireDate = [fireDate oneMonthNext];
        }
    #endif

    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSMonthCalendarUnit;
    localNotification.alertAction = NSLocalizedString(@"Select Event", @"Remind title");
    localNotification.alertBody = NSLocalizedString(@"Select the main event of the month in My Memoirs", @"Remind text");

    if (self.enableAlertSound) {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }

    localNotification.userInfo = @{
            @"type": @"monthly"
    };

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
