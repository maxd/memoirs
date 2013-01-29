//
//  AppModel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/28/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

-(id)initWithContext:(NSManagedObjectContext *)context;

- (NSArray *)eventsBetween:(NSDate *)from and:(NSDate *)to;

@end
