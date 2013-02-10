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

@interface EventEditorController_iPhone () <UITextViewDelegate, ValueListControllerDelegate_iPhone>

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btSelectValue;
@property (weak, nonatomic) IBOutlet UITextView *txtText;

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

    self.title = @"Событие дня";

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];

    [self.btSelectValue setBackgroundImage:[[UIImage imageNamed:@"btn"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6, 6, 6, 6}")] forState:UIControlStateNormal];
    [self.btSelectValue setBackgroundImage:[[UIImage imageNamed:@"btn_active"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6, 6, 6, 6}")] forState:UIControlStateHighlighted];
    [self.btSelectValue setImageEdgeInsets:UIEdgeInsetsMake(0, self.btSelectValue.frame.size.width - 20, 0, 0)];

    UIImage *txtTextBgImage = [[UIImage imageNamed:@"edit_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    txtTextBgImage = [txtTextBgImage scaleToSize:self.txtText.frame.size];

    self.txtText.backgroundColor = [UIColor colorWithPatternImage:txtTextBgImage];

    UIBarButtonItem *btBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_btn"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = btBack;

    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(btCancelHandler:)];
    self.navigationItem.leftBarButtonItem = btCancel;

    UIBarButtonItem *btSave = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStylePlain target:self action:@selector(btSaveHandler:)];
    self.navigationItem.rightBarButtonItem = btSave;

    self.lblDate.text = [self.eventListItem.startDate stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
    [self setSelectValue:self.eventListItem.event.value];
    self.txtText.text = self.eventListItem.event.text;
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
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:@"Предупреждение"
                                                            message:@"Пожалуйста выберите ценность дня из списка ценностей."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    } else if (!self.txtText.text.length) {
        WCAlertView *alertView = [[WCAlertView alloc] initWithTitle:@"Предупреждение"
                                                            message:@"Пожалуйста опишите событие дня."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
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
        [self.btSelectValue setTitle:@"Выберите ценность" forState:UIControlStateNormal];
        [self.btSelectValue setTitleColor:[UIColor colorWithHex:0xFF999999] forState:UIControlStateNormal];
    }
}

@end
