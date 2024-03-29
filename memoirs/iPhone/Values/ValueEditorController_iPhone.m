//
//  ValueEditorController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "ValueEditorController_iPhone.h"
#import "WCAlertView.h"
#import "AppModel.h"
#import "Value.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObject+Helpers.h"
#import "GAITracker.h"
#import "UIImage+Resize.h"

@interface ValueEditorController_iPhone ()

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgDescriptionBg;

@end

@implementation ValueEditorController_iPhone {
    AppModel *_appModel;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trackedViewName = @"Value Editor";

    self.title = NSLocalizedString(@"Life Value", @"NavBar title");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]];

    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel button") style:UIBarButtonItemStylePlain target:self action:@selector(btCancelHandler:)];
    self.navigationItem.leftBarButtonItem = btCancel;

    UIBarButtonItem *btSave = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save button") style:UIBarButtonItemStylePlain target:self action:@selector(btSaveHandler:)];
    self.navigationItem.rightBarButtonItem = btSave;

    self.txtTitle.background = [[UIImage imageNamed:@"edit_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.txtTitle.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.txtTitle.leftViewMode = UITextFieldViewModeAlways;
    self.txtTitle.placeholder = NSLocalizedString(@"Life Value", @"Placeholder text");
    [self.txtTitle becomeFirstResponder];

    UIImage *txtTextBgImage = [[UIImage imageNamed:@"edit_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    txtTextBgImage = [txtTextBgImage scaleToSize:self.txtDescription.frame.size];
    self.imgDescriptionBg.image = txtTextBgImage;

    self.txtTitle.text = self.value.title;
    self.txtDescription.text = self.value.text;
}

#pragma mark Action Handler

- (void)btCancelHandler:(id)sender {
    [self.delegate dismissValueEditorController:self];
}

- (void)btSaveHandler:(id)sender {
    NSString *title = self.txtTitle.text;
    NSString *description = self.txtDescription.text;

    if (!title.length) {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                                            message:NSLocalizedString(@"Please enter the life value name.", @"Alert text")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

        [alertView show];
    } else {
        if (!self.value) {
            self.value = [[_appModel context] newObjectWithEntityName:[Value entityName]];
        }

        self.value.title = title;
        self.value.text = description;

        [[_appModel context] save];

        [self.tracker sendEventWithCategory:@"User Action" withAction:@"Button Touch" withLabel:@"Save Value" withValue:nil];

        [self.delegate dismissValueEditorController:self];
    }
}

@end
