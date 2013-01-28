//
//  Value.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Value : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Event *events;

@end
