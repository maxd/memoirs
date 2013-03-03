//
//  TutorialView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 3/3/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "TutorialView.h"

@interface TutorialView ()

@property (weak, nonatomic) IBOutlet UIImageView *ctlImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation TutorialView

- (void)setImage:(UIImage *)image {
    _image = image;

    self.ctlImage.image = image;
}

- (void)setDescription:(NSString *)description {
    _description = description;

    _lblDescription.text = description;
}

@end
