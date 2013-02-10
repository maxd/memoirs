//
//  EventLoader.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/10/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppModel;

@interface EventLoader : NSObject

- (id)initWithAppModel:(AppModel *)appModel;

- (void)loadPredefinedEventsIfRequired;

@end
