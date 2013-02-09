//
//  YearlyEventListTableModel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/9/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventListTableModel.h"

@class AppModel;

@interface YearlyEventListTableModel : NSObject <EventListTableModel>

- (id)initWithAppModel:(AppModel *)appModel;

@end
