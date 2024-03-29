//
//  AppModel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/28/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;
@class Value;

@interface AppModel : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

- (id)initWithContext:(NSManagedObjectContext *)context;

- (NSArray *)eventsBetween:(NSDate *)from and:(NSDate *)to;

- (NSArray *)mostImportantEventsOfWeeksBetween:(NSDate *)from and:(NSDate *)to;

- (NSArray *)mostImportantEventsOfMonthsBetween:(NSDate *)from and:(NSDate *)to;

- (BOOL)isEventOfDayExists:(NSDate *)date;

- (BOOL)isEventOfWeekExists:(NSDate *)date;

- (BOOL)isEventOfMonthExists:(NSDate *)date;

- (NSFetchedResultsController *)values;

- (NSArray *)topValues;

- (NSInteger)eventCount;

@end
