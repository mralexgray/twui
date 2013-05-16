# TwUI

TwUI is a hardware accelerated UI framework for Mac, inspired by UIKit.  It enables:

* GPU accelerated rendering backed by CoreAnimation
* Simple model/view/controller development familiar to iOS developers

It differs from UIKit in a few ways:

* Simplified table view cells
* Block-based layout and drawRect
* A consistent coordinate system (bottom left origin)
* Sub-pixel text rendering

## Mysterious Trousers Fork

We're currently using TwUI to build [Firehose](https://www.getfirehose.com/). As we fix bugs and make improvements we will list them here. If you have a fix or improvement that you'd like to contribute, please open a pull request and we'll merge it in.

**Fixed:**
- (05/09/13) TUITextView: now calls super in drawRect. Multiple draws was making the text look thicker and thicker.
- (05/09/13) TUIStretchableImage: capInsets are now scaled based on retina/non-retina.
- (05/10/13) TUIStretchableImage: variable names were wrong, referring to the wrong image slices.
- (05/10/13) TUIButton: If a button is disabled, it no longer highlights the title on hover.
- (05/11/13) TUIStretchableImage: fixed so that 9-slice images display correctly on retina displays.
- (05/15/13) TUITableView: Making the table view clip subviews by default
- (05/15/13) TUIRefreshControl: got rid of dismiss animation until it can be done correctly.

**Added**
- (05/11/13) TUITextView: added `lineSpacing` property.
- (05/11/13) TUITextField: added `textFieldShouldTabToPrevious` delegate method.
- (05/11/13) TUIRefreshControl: pulled in `TUIRefreshControl` from githubs branch. (from github.com/galaxas0 & github.com/Sephiroth87)
- (05/15/13) TUIRefreshControl: added `arrowColor` property.
- (05/15/13) TUIButton: added `TUIButtonTypePush` to make a `TUIButton` that *kinda* looks like default AppKit button.



## Setup

Add

    pod 'TwUI', git: "https://github.com/mysterioustrousers/twui"

to your Podfile.

## Usage

Your `TUIView`-based view hierarchy is hosted inside an `TUINSView`, which is the bridge between AppKit and TwUI.  You may set a `TUINSView` as the content view of your window, if you'd like to build your whole UI with TwUI.  Or you may opt to have a few smaller `TUINSViews`, using TwUI just where it makes sense and continue to use AppKit everywhere else.

You can also add `NSViews` to a TwUI hierarchy using `TUIViewNSViewContainer`, which bridges back into AppKit from TwUI.

## Example Project

An included example project shows off the basic construction of a pure TwUI-based app.  A `TUINSView` is added as the content view of the window, and some `TUIView`-based views are hosted in that.  Within the table view cells, some `NSTextFields` are also added using `TUIViewNSViewContainer`.  It includes a table view and a tab bar (which is a good example of how you might build your own custom controls).

## Status

TwUI is currently shipping in Twitter for Mac and GitHub for Mac, in use 24/7 by many, many users, and has proven itself very stable.

This project follows the [SemVer](http://semver.org/) standard. The API may change in backwards-incompatible ways between major releases.

The goal of TwUI is to build a high-quality UI framework designed specifically for the Mac.  Much inspiration comes from UIKit, but diverging to try new things (i.e. block-based layout and drawRect), and optimizing for Mac-specific interactions is encouraged.

## Community

TwUI has a mailing list, subscribe by sending an email to <twui@librelist.com>.

## Copyright and License

Copyright 2011 Twitter, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this work except in compliance with the License.
   You may obtain a copy of the License in the LICENSE file, or at:

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
