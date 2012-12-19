_**If your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `ZAActivityBar.m` in Target Settings > Build Phases > Compile Sources._

# ZAActivityBar

ZAActivityBar is an easy-to-use activity bar that's meant to non-intrusively display the progress of a task.

## Installation

* Drag the `ZAActivityBar` folder into your project.
* Drag the `External` folder into your project (If you do not have them yet).
* Add the **QuartzCore** framework to your project.

## Video

[Link to Video](https://www.dropbox.com/s/bwv8z9u595ehngi/ZAActivityBar.mov)

## How to Use

_It's quite easy_

Show loading indicator

    [ZAActivityBar showWithStatus:@"Loading..."];

Show success or error messages (this will dismiss the indicator automatically)

    [ZAActivityBar showSuccessWithStatus:@"Success!"];
    [ZAActivityBar showErrorWithStatus:@"Success!"];

Dismiss the indicator

    [ZAActivityBar dismiss];
    
Notes:
* ZAActivityBar is completely thread safe.
* ZAActivityBar has been tested on iOS5 and iOS6.
* When using 'showWithStatus:' you will need to dismiss the bar either by calling 'dismiss' or showing an error or success message.
* ZAActivityBar is screen independent. That is, if you switch screens via any means the bar will remain on screen.

## Credits

ZAActivityBar is brought to you by [Zac Altman](https://github.com/zacaltman). It was heavily influenced by [SVProgressHUD](https://raw.github.com/samvermette/SVProgressHUD) by [Sam Vermette](http://samvermette.com). The success and error icons are from [Pictos](http://pictos.cc/). The bounce animation was masterfully crafted by [Soroush Khanlou](http://khanlou.com/) and can be found here: [ZKBounceAnimation](https://github.com/khanlou/SKBounceAnimation). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/zacaltman/ZAActivityBar/issues/new). If you're using ZAActivityBar in your project, attribution would be nice.