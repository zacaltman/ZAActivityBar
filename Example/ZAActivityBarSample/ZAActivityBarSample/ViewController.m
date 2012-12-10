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

- (IBAction) show:(id)sender {
    [self dismissTextField];
    [ZAActivityBar showWithStatus:_textbox.text];
}

- (IBAction) showSuccess:(id)sender {
    [self dismissTextField];
    [ZAActivityBar showSuccessWithStatus:_textbox.text];
}

- (IBAction) showError:(id)sender {
    [self dismissTextField];
    [ZAActivityBar showErrorWithStatus:_textbox.text];
}

- (IBAction) dismiss:(id)sender {
    [self dismissTextField];
    [ZAActivityBar dismiss];
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
