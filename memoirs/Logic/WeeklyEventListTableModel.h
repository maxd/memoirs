//
//  WeeklyEventListTableModel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventListTableModel.h"

@class AppModel;

@interface WeeklyEventListTableModel : NSObject <EventListTableModel>

- (id)initWithAppModel:(AppModel *)appModel;

@end
