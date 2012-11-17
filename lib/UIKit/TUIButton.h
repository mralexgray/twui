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

typedef enum {
	// Does not respond to .tintColor.
	TUIButtonTypeCustom,
	
	TUIButtonTypeStandard,
	TUIButtonTypeFlat,
	TUIButtonTypeMinimal,
	
	// Does not respond to .tintColor.
	// Overrides .selectable property as YES.
	TUIButtonTypeInline,
} TUIButtonType;

@interface TUIButton : TUIControl

@property (nonatomic, assign, readonly) TUIButtonType buttonType;

@property (nonatomic, assign) TUIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) TUIEdgeInsets titleEdgeInsets;
@property (nonatomic, assign) TUIEdgeInsets imageEdgeInsets;

@property (nonatomic, assign) BOOL dimsInBackground;
@property (nonatomic, assign) BOOL adjustsImageWhenHighlighted;
@property (nonatomic, assign) BOOL adjustsImageWhenDisabled;
@property (nonatomic, assign) BOOL reversesTitleShadowWhenHighlighted;
@property (nonatomic, assign, getter = isSelectable) BOOL selectable;

@property (nonatomic, strong, readonly) TUILabel *titleLabel;
@property (nonatomic, strong, readonly) TUIImageView *imageView;

// Setting this overrides .selectable property as YES.
@property (nonatomic, strong) NSMenu *menu;
@property (nonatomic, strong) NSSound *sound;

@property (nonatomic, strong) NSColor *tintColor;
@property (nonatomic, assign) CGFloat tintFactor;

+ (instancetype)buttonWithType:(TUIButtonType)buttonType;

- (CGRect)backgroundRectForBounds:(CGRect)bounds;
- (CGRect)contentRectForBounds:(CGRect)bounds;
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
- (CGRect)imageRectForContentRect:(CGRect)contentRect;

@end

@interface TUIButton (Content)

@property (nonatomic, strong, readonly) NSString *currentTitle;
@property (nonatomic, strong, readonly) NSColor *currentTitleColor;
@property (nonatomic, strong, readonly) NSColor *currentTitleShadowColor;
@property (nonatomic, strong, readonly) NSImage *currentImage;
@property (nonatomic, strong, readonly) NSImage *currentBackgroundImage;

- (void)setTitle:(NSString *)title forState:(TUIControlState)state;
- (void)setTitleColor:(NSColor *)color forState:(TUIControlState)state;
- (void)setTitleShadowColor:(NSColor *)color forState:(TUIControlState)state;
- (void)setImage:(NSImage *)image forState:(TUIControlState)state;
- (void)setBackgroundImage:(NSImage *)image forState:(TUIControlState)state;

- (NSString *)titleForState:(TUIControlState)state;
- (NSColor *)titleColorForState:(TUIControlState)state;
- (NSColor *)titleShadowColorForState:(TUIControlState)state;
- (NSImage *)imageForState:(TUIControlState)state;
- (NSImage *)backgroundImageForState:(TUIControlState)state;

@end
