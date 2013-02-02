//
//  EventListCell_iPhone.h
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventListItem;

@interface EventListCell_iPhone : UITableViewCell

@property (strong, nonatomic) EventListItem *eventListItem;

@property (weak, nonatomic) IBOutlet UIImageView *ctlDateBackground;

@end
