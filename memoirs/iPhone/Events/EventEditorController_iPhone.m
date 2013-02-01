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

@interface EventEditorController_iPhone () <UITextViewDelegate, ValueListControllerDelegate_iPhone>

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btSelectValue;
@property (weak, nonatomic) IBOutlet UITextView *txtText;

@end

@implementation EventEditorController_iPhone {
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

    self.title = @"Событие дня";

    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(btCancelHandler:)];
    self.navigationItem.leftBarButtonItem = btCancel;

    UIBarButtonItem *btSave = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStylePlain target:self action:@selector(btSaveHandler:)];
    self.navigationItem.rightBarButtonItem = btSave;

    self.lblDate.text = [self.date stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
    [self.btSelectValue setTitle:self.value.title forState:UIControlStateNormal];
    self.txtText.text = self.text;
}

- (IBAction)btSelectValueHandler:(id)sender {
    ValueListController_iPhone *valueListController = [[ValueListController_iPhone alloc] initWithAppModel:_appModel];
    valueListController.delegate = self;
    valueListController.value = self.value;

    [self.navigationController pushViewController:valueListController animated:YES];
}

- (void)valueListControllerDidSelectedValue:(ValueListController_iPhone *)valueListController {
    self.value = valueListController.value;

    [self.btSelectValue setTitle:self.value.title forState:UIControlStateNormal];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.text = textView.text;
}

- (IBAction)btCancelHandler:(id)sender {
    [self.delegate eventEditorController:self didFinishedWithSaveState:NO];
}

- (IBAction)btSaveHandler:(id)sender {
    [self.delegate eventEditorController:self didFinishedWithSaveState:YES];
}

@end
