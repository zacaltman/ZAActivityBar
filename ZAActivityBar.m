//
//  ZAActivityBar.m
//
//  Created by Zac Altman on 24/11/12.
//  Copyright (c) 2012 Zac Altman. All rights reserved.
//

#import "ZAActivityBar.h"
#import <QuartzCore/QuartzCore.h>

@interface ZAActivityBar ()

@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *barView;
@property (nonatomic, strong, readonly) UILabel *stringLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;
@property (nonatomic, strong, readonly) UIImageView *imageView;

- (void) showWithStatus:(NSString *)status;
- (void) setStatus:(NSString*)string;
- (void) showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration;

- (void) dismiss;

@end

@implementation ZAActivityBar

@synthesize fadeOutTimer, overlayWindow, barView, stringLabel, spinnerView, imageView;

- (void)dealloc {
	self.fadeOutTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    
    if(fadeOutTimer)
        [fadeOutTimer invalidate], fadeOutTimer = nil;
    
    if(newTimer)
        fadeOutTimer = newTimer;
}

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
	
    return self;
}

+ (ZAActivityBar *) sharedView {
    static dispatch_once_t once;
    static ZAActivityBar *sharedView;
    dispatch_once(&once, ^ { sharedView = [[ZAActivityBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

+ (void) showWithStatus:(NSString *)status {
    [[ZAActivityBar sharedView] showWithStatus:status];
}

+ (void) show {
    [[ZAActivityBar sharedView] showWithStatus:nil];
}

- (void) showWithStatus:(NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        self.fadeOutTimer = nil;
        self.imageView.hidden = YES;

        [self.overlayWindow setHidden:NO];
        [self setStatus:status];
        [self.spinnerView startAnimating];

        if (self.alpha != 1.0f) {
            [self positionBarOffscreen];
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self setYOffset:self.frame.size.height - (HEIGHT + PADDING) - 7];
                                 self.alpha = 1;
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [UIView animateWithDuration:0.1
                                                           delay:0.0f
                                                         options:UIViewAnimationCurveLinear
                                                      animations:^{
                                                          [self positionBar];
                                                      } completion:nil];
                                 }
                             }];

        }
        
        [self setNeedsDisplay];
    });
}


+ (void) showSuccessWithStatus:(NSString *)status {
    [ZAActivityBar showImage:[UIImage imageNamed:@"ZAActivityBar.bundle/success.png"]
                      status:status];
}

+ (void) showErrorWithStatus:(NSString *)status {
    [ZAActivityBar showImage:[UIImage imageNamed:@"ZAActivityBar.bundle/error.png"]
                      status:status];
}

+ (void)showImage:(UIImage *)image status:(NSString *)status {
    [[ZAActivityBar sharedView] showImage:image
                                   status:status
                                 duration:1.0];
}

- (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration {
    
    if(![ZAActivityBar isVisible])
        [ZAActivityBar show];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
        self.imageView.hidden = NO;
        [self setStatus:status];
        [self.spinnerView stopAnimating];
        
        self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                             target:self
                                                           selector:@selector(dismiss)
                                                           userInfo:nil
                                                            repeats:NO];
    });

}

+ (BOOL)isVisible {
    return ([ZAActivityBar sharedView].alpha == 1);
}


- (void)setStatus:(NSString *)string {
	
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    if(string) {
        float offset = (SPINNER_SIZE + 2 * ICON_OFFSET);
        float width = self.barView.frame.size.width - offset;
        CGSize stringSize = [string sizeWithFont:self.stringLabel.font
                               constrainedToSize:CGSizeMake(width, 300)];
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;

        labelRect = CGRectMake(offset, 0, stringWidth, HEIGHT);
        
//        if(stringWidth > hudWidth)
//            hudWidth = ceil(stringWidth/2)*2;
//        
//        if(hudHeight > 100) {
//            labelRect = CGRectMake(12, 66, hudWidth, stringHeight);
//            hudWidth+=24;
//        } else {
//            hudWidth+=24;
//            labelRect = CGRectMake(0, 66, hudWidth, stringHeight);
//        }
    }
	
//	self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
	self.stringLabel.frame = labelRect;
	
}


- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
		stringLabel.textAlignment = UITextAlignmentLeft;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:14];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.barView addSubview:stringLabel];
    
    return stringLabel;
}

- (void) positionBarOffscreen {
    [self setYOffset:self.frame.size.height + (HEIGHT + PADDING)];
}

- (void) positionBar {
    [self setYOffset:self.frame.size.height - (HEIGHT + PADDING)];
}

- (void) setYOffset:(float)yOffset {
    CGRect rect = self.barView.frame;
    rect.origin.y = yOffset;
    [self.barView setFrame:rect];    
}

- (void)drawRect:(CGRect)rect {
    
}

+ (void) dismiss {
	[[ZAActivityBar sharedView] dismiss];
}

- (void) dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                            float yOffset = self.barView.frame.origin.y - 4;
                            [self setYOffset:yOffset];
                         }completion:^(BOOL finished) {
                             if (finished) {
                                 [UIView animateWithDuration:0.25
                                                       delay:0
                                                     options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                                                  animations:^{
                                                      [self positionBarOffscreen];
                                                      self.alpha = 0;
                                                  }
                                                  completion:^(BOOL finished){
                                                      if(self.alpha == 0) {
                                                          [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                          [barView removeFromSuperview];
                                                          barView = nil;
                                                          
                                                          [overlayWindow removeFromSuperview];
                                                          overlayWindow = nil;
                                                          
                                                          // uncomment to make sure UIWindow is gone from app.windows
                                                          //NSLog(@"%@", [UIApplication sharedApplication].windows);
                                                          //NSLog(@"keyWindow = %@", [UIApplication sharedApplication].keyWindow);
                                                      }
                                                  }];

                             }
                         }];
    });
}


#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIView *)barView {
    if(!barView) {
        CGRect rect = CGRectMake(PADDING, FLT_MAX, self.frame.size.width, HEIGHT);
        rect.size.width -= 2 * PADDING;
        barView = [[UIView alloc] initWithFrame:rect];
        barView.layer.cornerRadius = 6;
		barView.backgroundColor = BORDER_COLOR;//[UIColor colorWithWhite:1 alpha:0.8];
        barView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);        
        [self addSubview:barView];
    }
    return barView;
}

- (UIActivityIndicatorView *)spinnerView {
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.frame = CGRectMake(ICON_OFFSET, ICON_OFFSET, SPINNER_SIZE, SPINNER_SIZE);
    }
    
    if(!spinnerView.superview)
        [self.barView addSubview:spinnerView];
    
    return spinnerView;
}

- (UIImageView *)imageView {
    if (imageView == nil)
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ICON_OFFSET, ICON_OFFSET, SPINNER_SIZE, SPINNER_SIZE)];
    
    if(!imageView.superview)
        [self.barView addSubview:imageView];
    
    return imageView;
}

@end
