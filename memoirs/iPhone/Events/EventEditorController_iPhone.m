//
//  EventEditorController_iPhone.m
//  memoirs
//
//  Created by Maxim Dobryakov on 1/26/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import "EventEditorController_iPhone.h"
#import "Value.h"
#import "NSDate+MTDates.h"
#import "ValueListController_iPhone.h"
#import "AppModel.h"
#import "UIColor+Helpers.h"
#import "UIImage+Resize.h"
#import "WCAlertView.h"
#import "EventListItem.h"
#import "Event.h"
#import "NSManagedObjectContext+Helpers.h"
#import "NSManagedObject+Helpers.h"
#import "GAITracker.h"

@interface EventEditorController_iPhone () <UITextViewDelegate, ValueListControllerDelegate_iPhone>

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btSelectValue;
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UIImageView *imgTextBg;

@end

@implementation EventEditorController_iPhone {
    AppModel *_appModel;

    Value *_value;
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

    self.trackedViewName = @"Event Editor";

    self.title = NSLocalizedString(@"Event of Day", @"NavBar title");

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_bg"]]];

    [self.btSelectValue setBackgroundImage:[[UIImage imageNamed:@"edit_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.btSelectValue setBackgroundImage:[[UIImage imageNamed:@"edit_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [self.btSelectValue setImageEdgeInsets:UIEdgeInsetsMake(0, self.btSelectValue.frame.size.width - 20, 0, 0)];

    UIImage *txtTextBgImage = [[UIImage imageNamed:@"edit_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    txtTextBgImage = [txtTextBgImage scaleToSize:self.txtText.frame.size];

    self.imgTextBg.image = txtTextBgImage;

    UIBarButtonItem *btBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_btn"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = btBack;

    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel button") style:UIBarButtonItemStylePlain target:self action:@selector(btCancelHandler:)];
    self.navigationItem.leftBarButtonItem = btCancel;

    UIBarButtonItem *btSave = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save button") style:UIBarButtonItemStylePlain target:self action:@selector(btSaveHandler:)];
    self.navigationItem.rightBarButtonItem = btSave;

    self.lblDate.text = [self.eventListItem.startDate stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
    [self setSelectValue:self.eventListItem.event.value];
    self.txtText.text = self.eventListItem.event.text;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([_value isFault]) {
        [self setSelectValue:nil];
    }
}

- (IBAction)btSelectValueHandler:(id)sender {
    ValueListController_iPhone *valueListController = [[ValueListController_iPhone alloc] initWithAppModel:_appModel];
    valueListController.delegate = self;
    valueListController.value = _value;

    [self.navigationController pushViewController:valueListController animated:YES];
}

- (void)valueListControllerDidSelectedValue:(ValueListController_iPhone *)valueListController {
    [self setSelectValue:valueListController.value];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btCancelHandler:(id)sender {
    [self.delegate dismissEventEditorController:self];
}

- (IBAction)btSaveHandler:(id)sender {
    if (!_value) {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                                            message:NSLocalizedString(@"Please select life value from list.", @"Alert text")
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    } else if (!self.txtText.text.length) {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Alert title")
                                                            message:NSLocalizedString(@"Please describe event of day.", @"Alert text")
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

        [alertView show];
    } else {
        if (!self.eventListItem.event) {
            self.eventListItem.event = [_appModel.context newObjectWithEntityName:[Event entityName]];
        }

        self.eventListItem.event.date = self.eventListItem.startDate;
        self.eventListItem.event.value = _value;
        self.eventListItem.event.text = self.txtText.text;

        [_appModel.context save];

        [self.tracker sendEventWithCategory:@"User Action" withAction:@"Button Touch" withLabel:@"Save Event" withValue:nil];

        [self.delegate dismissEventEditorController:self];
    }
}

#pragma mark Helper Methods

- (void)setSelectValue:(Value *)value {
    _value = value;

    if (value.title.length) {
        [self.btSelectValue setTitle:value.title forState:UIControlStateNormal];
        [self.btSelectValue setTitleColor:[UIColor colorWithHex:0xFF033143] forState:UIControlStateNormal];
    } else {
        [self.btSelectValue setTitle:NSLocalizedString(@"Select Life Value", @"Placeholder text") forState:UIControlStateNormal];
        [self.btSelectValue setTitleColor:[UIColor colorWithHex:0xFF999999] forState:UIControlStateNormal];
    }
}

@end
