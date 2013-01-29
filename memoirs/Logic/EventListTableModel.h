//
//  EventListTableModel.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppModel;

@interface EventListTableModel : NSObject

@property (strong, nonatomic) NSMutableArray *groups;

- (id)initWithAppModel:(AppModel *)appModel;

-(void)loadWeeksAroundCurrent;

-(void)loadPrev;

-(void)loadNext;
@end
