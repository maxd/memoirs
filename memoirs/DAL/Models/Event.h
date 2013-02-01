//
//  Event.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/30/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Value;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * mainPerMonth;
@property (nonatomic, retain) NSNumber * mainPerWeek;
@property (nonatomic, retain) NSNumber * mainPerYear;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Value *value;

@end
