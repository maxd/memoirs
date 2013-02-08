//
//  EventListTableModel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/8/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventListTableModel <NSObject>

@property (strong, nonatomic) NSMutableArray *groups;

- (void)loadSectionsAroundDate:(NSDate *)currentDate;

- (void)loadPrevSection;

- (void)loadNextSection;

@end
