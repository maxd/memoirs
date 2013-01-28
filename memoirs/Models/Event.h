//
//  Event.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * mainPerWeek;
@property (nonatomic, retain) NSNumber * mainPerMonth;
@property (nonatomic, retain) NSNumber * mainPerYear;
@property (nonatomic, retain) NSManagedObject *values;

@end
