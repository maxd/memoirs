//
//  TutorialController.m
//  memoirs
//
//  Created by Maxim Dobryakov on 3/2/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "TutorialController.h"
#import "PagedScrollView.h"
#import "TutorialView.h"
#import "UIView+NIB.h"
#import "NVUIGradientButton.h"

@interface TutorialController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PagedScrollView *ctlPagedScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btClose;

@end

@implementation TutorialController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]];
    self.btClose.hidden = !self.showCloseButton;

    [_ctlPagedScrollView addPage:[self createTutorialPageWithImage:[UIImage imageNamed:@"tutorial-page-1"] andDescription:NSLocalizedString(@"tutorial-page-1", @"Tutorial text")]];
    [_ctlPagedScrollView addPage:[self createTutorialPageWithImage:[UIImage imageNamed:@"tutorial-page-2"] andDescription:NSLocalizedString(@"tutorial-page-2", @"Tutorial text")]];
    [_ctlPagedScrollView addPage:[self createTutorialPageWithImage:[UIImage imageNamed:@"tutorial-page-3"] andDescription:NSLocalizedString(@"tutorial-page-3", @"Tutorial text")]];
    [_ctlPagedScrollView addPage:[self createTutorialPageWithImage:[UIImage imageNamed:@"tutorial-page-4"] andDescription:NSLocalizedString(@"tutorial-page-4", @"Tutorial text")]];
    [_ctlPagedScrollView addPage:[self createTutorialPageWithImage:[UIImage imageNamed:@"tutorial-page-5"] andDescription:NSLocalizedString(@"tutorial-page-5", @"Tutorial text")]];
}

- (TutorialView *)createTutorialPageWithImage:(UIImage *)image andDescription:(NSString *)description {
    TutorialView *tutorialView = [TutorialView loadFromNIB];

    tutorialView.image = image;
    tutorialView.description = description;

    return tutorialView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > (self.ctlPagedScrollView.pageCount - 1) * self.ctlPagedScrollView.frame.size.width) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)closeButtonHandler:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
