//
//  YearlyEventListHandler.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventListHandler.h"

@class AppModel;


@interface YearlyEventListHandler : NSObject <EventListHandler>

- (id)initWithAppModel:(AppModel *)appModel;

@end
