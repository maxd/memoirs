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

@implementation AppDelegate {
    AppModel *_appModel;
}

+ (AppDelegate *)shared {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _appModel = [self createAppModel];
    if (!_appModel)
        return NO;

    ValuesLoader *valuesLoader = [[ValuesLoader alloc] initWithManagedContext:[_appModel context]];
    [valuesLoader loadPredefinedValuesIfRequired];

    [self createWindow:_appModel];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mainController = [[MainController_iPhone alloc] initWithAppModel:appModel];
    } else {
//        self.mainController = [[EventListController_iPad alloc] initWithAppModel:appModel];
    }

    self.window.rootViewController = self.mainController;
    [self.window makeKeyAndVisible];
}

@end
