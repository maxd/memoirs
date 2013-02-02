//
//  MainController_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"

@class AppModel;

@interface MainController_iPhone : JASidePanelController

- (id)initWithAppModel:(AppModel *)appModel;

-(void)showEventList;

-(void)showSettings;
@end
