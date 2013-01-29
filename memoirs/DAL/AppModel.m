//
//  AppModel.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/28/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppModel.h"
#import "NSManagedObjectContext+Helpers.h"
#import "Event.h"
#import "NSManagedObject+Helpers.h"

@implementation AppModel {
    NSManagedObjectContext *_context;
}

- (id)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];

    if (self) {
        _context = context;
    }

    return self;
}

- (NSArray *)eventsBetween:(NSDate *)from and:(NSDate *)to {
    NSFetchRequest *fetchRequest = [Event request];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", from, to];
    [fetchRequest setPredicate:predicate];

    return [_context objectsForRequest:fetchRequest];
}

@end
