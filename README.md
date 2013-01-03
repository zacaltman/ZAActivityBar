_**If your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `ZAActivityBar.m` in Target Settings > Build Phases > Compile Sources._

# ZAActivityBar

ZAActivityBar is an easy-to-use queueable activity bar that's meant to non-intrusively display the progress of a task.

![ScreenShot](https://raw.github.com/zacaltman/ZAActivityBar/master/screenshot.png)

## Installation

* Drag the `ZAActivityBar` folder into your project.
* Drag `SKBounceAnimation.h` and `SKBounceAnimation.m` files into your project (found in `External/SKBounceAnimation/SKBounceAnimation`)
* Add the **QuartzCore** framework to your project.

## Video

[Basic Use](https://www.dropbox.com/s/bwv8z9u595ehngi/ZAActivityBar.mov)

[Advanced Use (Queuing)](https://www.dropbox.com/s/g1ka7j90z81jgjr/ZAActivityBarQueue.mov)

[Fast Updating Data](https://www.dropbox.com/s/0b9h8cfrcfgtweo/ZAActivityBarFastUpdating.mov) - updated every 0.01 seconds

## Notes
* ZAActivityBar is completely thread safe.
* ZAActivityBar has been tested on iOS5 and iOS6.
* When using 'showWithStatus:' you will need to dismiss the bar either by calling 'dismiss' or showing an error or success message.
* ZAActivityBar is screen independent. That is, if you switch screens via any means the bar will remain on screen.

## Basic Use

_It's quite easy_

Show loading indicator

    [ZAActivityBar showWithStatus:@"Loading..."];

Show success or error messages (this will dismiss the indicator automatically)

    [ZAActivityBar showSuccessWithStatus:@"Success!"];
    [ZAActivityBar showErrorWithStatus:@"Success!"];

Dismiss the indicator

    [ZAActivityBar dismiss];
    
## Advanced Use (Queuing)

You can add actions to a display queue. This means that you could have several async actions going on and independently set the actions for each and `ZAActivityBar` will handle what the user sees for you. No more disappearing bars or annoying dependencies!

Here's the absolute basics for you:

	#define DATA_ACTION @"DataAction"
	#define IMAGE_ACTION @"ImageAction"
	
	- (void) loadEverything {
		[self loadDataAsync];
		[self loadImagesAsync];
	}
	
	- (void) loadDataAsync {
		
		// Dispatch into a thread here
		
		[ZAActivityBar showWithStatus:@"Loading Data" forAction:DATA_ACTION];
		
		// Load here
		
	    [ZAActivityBar showSuccessWithStatus:@"Data Loaded!" forAction:DATA_ACTION];
	}
	
	- (void) loadImagesAsync {
	
		// Dispatch into a thread here
		
		[ZAActivityBar showWithStatus:@"Loading Images" forAction:IMAGE_ACTION];
		
		// Load here
		
		[ZAActivityBar dismissForAction:DATA_ACTION];
	}
	
In this example, the `Loading Data` message will be shown until the data is loaded, then the `Data Loaded!` success message will be shown. Then...
* If the images have loaded, the bar will be removed.
* If the images are still loading, the `Loading Images` message will be shown, and when they have loaded, the bar will disappear from the screen.

### How do I dismiss all actions?

This is the catch all method:

	[ZAActivityBar dismiss];

### How does it determine what to show?

Pretty simple, first action in is the primary action. Everything else is queued up and ignored until the primary action is dismissed. Once the primary action is dismissed, the next item in the queue becomes the primary action.

### Can I change the order or set items have a higher priority?
_No_

## Credits

ZAActivityBar is brought to you by [Zac Altman](https://github.com/zacaltman). It was heavily influenced by [SVProgressHUD](https://raw.github.com/samvermette/SVProgressHUD) by [Sam Vermette](http://samvermette.com). The success and error icons are from [Pictos](http://pictos.cc/). The bounce animation was masterfully crafted by [Soroush Khanlou](http://khanlou.com/) and can be found here: [ZKBounceAnimation](https://github.com/khanlou/SKBounceAnimation). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/zacaltman/ZAActivityBar/issues/new). If you're using ZAActivityBar in your project, attribution would be nice.