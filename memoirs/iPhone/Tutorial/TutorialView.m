//
//  TutorialView.m
//  memoirs
//
//  Created by Maxim Dobryakov on 3/3/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TutorialView.h"

@interface TutorialView ()

@property (weak, nonatomic) IBOutlet UIView *ctlShadow;
@property (weak, nonatomic) IBOutlet UIImageView *ctlImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation TutorialView

- (void)setImage:(UIImage *)image {
    _image = image;

    self.ctlImage.image = image;
    
    self.ctlImage.layer.cornerRadius = 5;
    self.ctlImage.layer.masksToBounds = YES;

    self.ctlShadow.layer.shadowRadius = 5;
    self.ctlShadow.layer.shadowOffset = CGSizeMake(0, 0);
    self.ctlShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ctlShadow.layer.shadowOpacity = 0.8;
}

- (void)setDescription:(NSString *)description {
    _description = description;

    _lblDescription.text = description;
}

@end
