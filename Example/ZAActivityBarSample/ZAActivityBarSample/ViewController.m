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

- (NSString *) actionForSender:(id)sender show:(BOOL)show {
    
    // Get the action
    UIButton *button = (UIButton *)sender;
    NSString *action = [NSString stringWithFormat:@"Action%i",button.tag];
    
    // Set the title
    UILabel *label = nil;
    if (button.tag == 1) label = _actionLabel1;
    if (button.tag == 2) label = _actionLabel2;
    if (button.tag == 3) label = _actionLabel3;
    
    NSString *buttonText = nil;
    if (show) {
        buttonText = [NSString stringWithFormat:@"%@: %@", action, _textbox.text];
    } else {
        buttonText = [NSString stringWithFormat:@"%@: -- dismissed --", action];
    }
    
    [label setText:buttonText];
    
    return action;
}

- (IBAction) show:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender show:YES];
    [ZAActivityBar showWithStatus:_textbox.text forAction:action];
}

- (IBAction) showSuccess:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender show:NO];
    [ZAActivityBar showSuccessWithStatus:_textbox.text forAction:action];
}

- (IBAction) showError:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender show:NO];
    [ZAActivityBar showErrorWithStatus:_textbox.text forAction:action];
}

- (IBAction) dismiss:(id)sender {
    [self dismissTextField];
    NSString *action = [self actionForSender:sender show:NO];
    [ZAActivityBar dismissForAction:action];
}

- (IBAction) dismissAll:(id)sender {
    [self dismissTextField];

    [_actionLabel1 setText:@"Action1: -- dismissed --"];
    [_actionLabel2 setText:@"Action2: -- dismissed --"];
    [_actionLabel3 setText:@"Action3: -- dismissed --"];
    
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

#pragma mark -
#pragma mark Rotation Methods

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
