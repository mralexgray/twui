/*
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
 */

#import "TUIControl.h"
#import "TUIGeometry.h"

@class TUILabel;
@class TUIImageView;

// The TUIButtonType is used to determine how a button should
// look and feel. A button's type cannot be changed after initialization.
//
// TUIButtonTypeCustom		- A completely unstyled custom button.
// TUIButtonTypeStandard	- A standard Aqua-style tinted button.
//							  This button type has a standard height.
//							  This button style automatically adjusts
//							  its tint to match the user control tint.
// TUIButtonTypeRectangular	- A rectangular two-phase gradiented button.
// TUIButtonTypeCircular	- A centered circular "glowing" button.
// TUIButtonTypeTextured	- A standard popover or toolbar-appropriate
//							  button whose gradient assumes its tint
//							  from the background view's color.
// TUIButtonTypeMinimal		- A pill-shaped convex button with a slight
//							  gradient, used primarily for toggles.
// TUIButtonTypeInline		- A pill-shaped button with a light gray
//							  fill on hover, a dark gray fill on mouse
//							  press, and a shadowed recess on selection.
//							  Should be primarily used for token fields.
typedef enum TUIButtonType : NSUInteger {
	TUIButtonTypeCustom,
	TUIButtonTypeStandard,
	TUIButtonTypeRectangular,
	TUIButtonTypeCircular,
	TUIButtonTypeTextured,
	TUIButtonTypeMinimal,
	TUIButtonTypeInline
} TUIButtonType;

// An instance of the TUIButton class implements a button on the screen.
// A button intercepts touch events and sends an action message to a
// target object when clicked. Methods for setting the target and action
// are inherited from TUIControl. This class provides methods for setting
// the title, image, and other appearance properties of a button. By using
// these accessors, you can specify a different appearance for each state.
@interface TUIButton : TUIControl

// Indicates the current button type. See TUIButtonType for the possible values.
@property (nonatomic, assign, readonly) TUIButtonType buttonType;

// Use this property to resize and reposition the effective drawing
// rectangle for the button content. The content comprises the button 
// image and button title. The default is TUIEdgeInsetsZero.
@property (nonatomic, assign) TUIEdgeInsets contentEdgeInsets;

// Use this property to resize and reposition the effective drawing
// rectangle for the button title. The default value is TUIEdgeInsetsZero.
// The insets you specify are applied to the title rectangle after
// that rectangle has been sized to fit the button’s text. Thus,
// positive inset values may actually clip the title text.
@property (nonatomic, assign) TUIEdgeInsets titleEdgeInsets;

// Use this property to resize and reposition the effective drawing
// rectangle for the button image. The default value is TUIEdgeInsetsZero.
@property (nonatomic, assign) TUIEdgeInsets imageEdgeInsets;

// Sets the position of the button's image relative to its title.
// See TUIControlImagePosition for the definitions of possible values.
@property (nonatomic, assign) TUIControlImagePosition imagePosition;

// If YES, the title is drawn lighter when the window is not key. The default value is YES.
@property (nonatomic, assign) BOOL dimsInBackground;

// If YES, the image is drawn lighter when the button is highlighted. The default value is YES.
@property (nonatomic, assign) BOOL adjustsImageWhenHighlighted;

// If YES, the image is drawn darker when the button is disabled. The default value is YES.
@property (nonatomic, assign) BOOL adjustsImageWhenDisabled;

// If YES, the shadow changes from engrave to emboss appearance when highlighted. The default value is NO.
@property (nonatomic, assign) BOOL reversesTitleShadowWhenHighlighted;

// If YES, the button can be triggered into a stable selected state and back. The default is NO.
@property (nonatomic, assign, getter = isSelectable) BOOL selectable;

// The titleLabel is the label on which the button text will be dynamically drawn.
@property (nonatomic, strong, readonly) TUILabel *titleLabel;

// The imageView is the view on which the button content image will be drawn.
@property (nonatomic, strong, readonly) TUIImageView *imageView;

// Allows a pop up menu to be displayed if the button is pressed.
// Setting this overrides selectable property as YES.
@property (nonatomic, strong) NSMenu *menu;

// This method is a convenience constructor for creating button objects
// with specific configurations. It you subclass TUIButton, this method
// does not return an instance of your subclass. If you want to create
// an instance of a specific subclass, you must alloc/init the button
// directly or override this class method to return your button's newly
// initialized object. You must always call the superclass implementation
// if you are not returning a new button object. When creating a button
// the frame of the button is set to CGRectZero initially. Before adding
// the button to your interface, you should update the frame.
+ (instancetype)buttonWithType:(TUIButtonType)buttonType;

// The default implementation of this method returns the value in the bounds
// parameter. This rectangle represents the area in which the button draws
// its standard background content. Subclasses that provide custom background
// adornments can override this method and return a modified bounds rectangle
// to prevent the button from drawing over any custom content.
- (CGRect)backgroundRectForBounds:(CGRect)bounds;

// The content rectangle is the area needed to display the image and title
// including any padding and adjustments for alignment and other settings.
- (CGRect)contentRectForBounds:(CGRect)bounds;

// The rectangle in which the receiver draws its title.
- (CGRect)titleRectForContentRect:(CGRect)contentRect;

// The rectangle in which the receiver draws its image.
- (CGRect)imageRectForContentRect:(CGRect)contentRect;

@end

// In general, if a property is not specified for a state, the default
// is to use the TUIControlStateNormal value. If the TUIControlStateNormal
// value is not set, then the property defaults to a system value.
// Therefore, at a minimum, you should set the value for the normal state.
@interface TUIButton (Content)

@property (nonatomic, strong, readonly) NSString *currentTitle;
@property (nonatomic, strong, readonly) NSColor *currentTitleColor;
@property (nonatomic, strong, readonly) NSColor *currentTitleShadowColor;
@property (nonatomic, strong, readonly) NSImage *currentImage;
@property (nonatomic, strong, readonly) NSImage *currentBackgroundImage;

// The title for a given button state.
- (NSString *)titleForState:(TUIControlState)state;

// The title color for a given button state.
- (NSColor *)titleColorForState:(TUIControlState)state;

// The title shadow color for a given button state.
- (NSColor *)titleShadowColorForState:(TUIControlState)state;

// The image for a given button state.
- (NSImage *)imageForState:(TUIControlState)state;

// The background image for a given button state.
// This is only applicable if the button type is TUIButtonTypeCustom.
- (NSImage *)backgroundImageForState:(TUIControlState)state;

// Set the title for the button. The title derives its formatting from
// the button’s associated label.
- (void)setTitle:(NSString *)title forState:(TUIControlState)state;

// Set the title color for the button. The color derives its formatting
// from the button’s associated label.
- (void)setTitleColor:(NSColor *)color forState:(TUIControlState)state;

// Set the shadow color for the button. The shadow color derives its
// formatting from the button’s associated label.
- (void)setTitleShadowColor:(NSColor *)color forState:(TUIControlState)state;

// Set the image for the button.
- (void)setImage:(NSImage *)image forState:(TUIControlState)state;

// Set the background image for the button.
- (void)setBackgroundImage:(NSImage *)image forState:(TUIControlState)state;

@end
