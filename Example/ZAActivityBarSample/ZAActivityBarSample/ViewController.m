//
//  ViewController.m
//  ZAActivityBarSample
//
//  Created by Zac Altman on 10/12/12.
//  Copyright (c) 2012 Zac Altman. All rights reserved.
//

#import "ViewController.h"
#import "ZAActivityBar.h"

@implementation ViewController

///////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark Action Methods

- (NSString *) actionForSender:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *action = [NSString stringWithFormat:@"Action%i",button.tag];
    return action;
}

- (IBAction) show:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender];
    [ZAActivityBar showWithStatus:_textbox.text forAction:action];
}

- (IBAction) showSuccess:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender];
    [ZAActivityBar showSuccessWithStatus:_textbox.text forAction:action];
}

- (IBAction) showError:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender];
    [ZAActivityBar showErrorWithStatus:_textbox.text forAction:action];
}

- (IBAction) dismiss:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender];
    [ZAActivityBar dismissForAction:action];
}

///////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark TextField Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self dismissTextField];
    return YES;
}

- (void) dismissTextField {
    if ([_textbox isFirstResponder]) {
        [_textbox resignFirstResponder];
    }
}

///////////////////////////////////////////////////////////////

@end
