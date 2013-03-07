//
//  AppDelegate.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/25/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "MainController_iPhone.h"
#import "NSManagedObjectModel+Helpers.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSURL+Helpers.h"
#import "AppModel.h"
#import "ValuesLoader.h"
#import "WCAlertView.h"
#import "UIColor+Helpers.h"
#import "NSDate+MTDates.h"
#import "EventLoader.h"
#import "NotificationManager.h"
#import "GAI.h"

@implementation AppDelegate {
    AppModel *_appModel;
}

+ (AppDelegate *)shared {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self configureAnalytics];
    [self configureNSDate];
    [self configureUserDefaults];

    _appModel = [self createAppModel];
    if (!_appModel)
        return NO;

    [self loadPredefinedValues];

    #ifdef DEBUG
    [self loadPredefinedEvents];
    #endif

    [self createWindow:_appModel];

    [self applyTheme];

    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self localNotificationHandler:localNotification];
    }

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotification {
    [self localNotificationHandler:localNotification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [self rescheduleNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configureAnalytics {
    [GAI sharedInstance].dispatchInterval = 10;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-38508832-1"];

    #ifdef DEBUG
    [GAI sharedInstance].optOut = YES;
    #endif
}

- (void)configureNSDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [NSDate setFirstDayOfWeek:calendar.firstWeekday];
    [NSDate setTimeZone:calendar.timeZone];
}

- (void)configureUserDefaults {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"];
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:path];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (AppModel *)createAppModel {
    AppModel *appModel = nil;

    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel modelWithName:@"Model"];

    NSURL *storageUrl = [NSURL fileURLWithPathInLibrary:@"memoirs.sqlite"];
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedContextWithModel:managedObjectModel storageUrl:storageUrl error:&error];

    if (managedObjectContext) {
        appModel = [[AppModel alloc] initWithContext:managedObjectContext];
    } else {
        NSLog(@"Failed to create data context: %@", error);
    }

    return appModel;
}

- (void)createWindow:(AppModel *)appModel {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.mainController = [[MainController_iPhone alloc] initWithAppModel:appModel];

    self.window.rootViewController = self.mainController;
    [self.window makeKeyAndVisible];
}

- (void)applyTheme {
    self.mainController.view.backgroundColor = [UIColor blackColor];

    UIImage *navigationBackground = [[UIImage imageNamed:@"header_bkd_dark"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{5, 5, 0, 5}")];
    [[UINavigationBar appearance] setBackgroundImage:navigationBackground forBarMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"header_button_bkd_dark"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"header_button_bkd_dark_tap"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"header_button_bkd_dark"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"header_button_bkd_dark_tap"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithHex:0xFF033143]];

    [WCAlertView setDefaultCustomiaztonBlock:^(WCAlertView *alertView) {
        alertView.labelTextColor = [UIColor colorWithHex:0xFF033143];
        alertView.labelShadowColor = [UIColor whiteColor];

        UIColor *topGradient = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        UIColor *middleGradient = [UIColor colorWithRed:0.93f green:0.94f blue:0.96f alpha:1.0f];
        UIColor *bottomGradient = [UIColor colorWithRed:0.89f green:0.89f blue:0.92f alpha:1.00f];
        alertView.gradientColors = @[topGradient,middleGradient,bottomGradient];

        alertView.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];

        alertView.buttonTextColor = [UIColor colorWithHex:0xFF033143];
        alertView.buttonShadowColor = [UIColor whiteColor];
    }];
}

- (void)rescheduleNotifications {
    NotificationManager *notificationManager = [[NotificationManager alloc] initWithAppModel:_appModel];
    notificationManager.alertHour = 22;
    notificationManager.alertMinute = 0;

    #ifndef DEBUG
    notificationManager.enableAlertSound = YES;
    #endif

    [notificationManager rescheduleNotifications];
}

- (void)localNotificationHandler:(UILocalNotification *)localNotification {
    NSString *notificationType = localNotification.userInfo[@"type"];

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([notificationType isEqualToString:@"daily"]) {
            [self.mainController showWeeklyEventList];
        } else if ([notificationType isEqualToString:@"weekly"]) {
            [self.mainController showMonthlyEventList];
        } else if ([notificationType isEqualToString:@"monthly"]) {
            [self.mainController showYearlyEventList];
        }

        [self.mainController openEventListEditorForDate:localNotification.fireDate];
    });

    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"User Action" withAction:@"Open Notification" withLabel:notificationType withValue:nil];
}

- (void)loadPredefinedEvents {
    EventLoader *eventLoader = [[EventLoader alloc] initWithAppModel:_appModel];
    [eventLoader loadPredefinedEventsIfRequired];
}

- (void)loadPredefinedValues {
    ValuesLoader *valuesLoader = [[ValuesLoader alloc] initWithManagedContext:[_appModel context]];
    [valuesLoader loadPredefinedValuesIfRequired];
}

@end
