//
//  ZAActivityBar.h
//
//  Created by Zac Altman on 24/11/12.
//  Copyright (c) 2012 Zac Altman. All rights reserved.
//
//  Heavily influenced by SVProgressHUD by Sam Vermette
//  Pieces of code may have been directly copied.
//  Sam is a legend!
//  https://github.com/samvermette/SVProgressHUD
//

#import <UIKit/UIKit.h>

// This allows you to offet the position of the indicator. 49.0f for Tab Bars.
#define BOTTOM_OFFSET 0.0f

// Visual Properties
#define BAR_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.8f]
#define HEIGHT 40.0f
#define PADDING 10.0f

// Best not to change these
#define SPINNER_SIZE 24.0f
#define ICON_OFFSET (HEIGHT - SPINNER_SIZE) / 2.0f

@interface ZAActivityBar : UIView

+ (void) show;
+ (void) dismiss;

+ (void) showWithStatus:(NSString *)status;
+ (void) showSuccessWithStatus:(NSString *)status;
+ (void) showErrorWithStatus:(NSString *)status;
+ (void) showImage:(UIImage *)image status:(NSString *)status;

@end
