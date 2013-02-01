//
//  ValuesLoader.h
//  memoirs
//
//  Created by Maxim Dobryakov on 2/1/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValuesLoader : NSObject

- (id)initWithManagedContext:(NSManagedObjectContext *)context;

- (void)loadPredefinedValuesIfRequired;

@end
