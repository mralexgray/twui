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

#import "TUIButton.h"
#import "TUICGAdditions.h"
#import "NSBezierPath+TUIExtensions.h"
#import "NSShadow+TUIExtensions.h"
#import "NSImage+TUIExtensions.h"
#import "TUIImageView.h"
#import "TUILabel.h"
#import "TUINSView.h"
#import "TUIStretchableImage.h"
#import "TUITextRenderer.h"

@interface TUIButtonContent : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSColor *titleColor;
@property (nonatomic, strong) NSColor *shadowColor;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *backgroundImage;

@end

@interface TUIButton () {
    struct {
        unsigned buttonType:8;
		unsigned wasHighlighted:1;
		
		unsigned dimsInBackground:1;
		unsigned adjustsImageWhenHighlighted:1;
		unsigned adjustsImageWhenDisabled:1;
		unsigned reversesTitleShadowWhenHighlighted:1;
    } _buttonFlags;
}

@property (nonatomic, strong) NSMutableDictionary *contentLookup;
@property (nonatomic, strong, readwrite) TUILabel *titleLabel;

@end

@implementation TUIButton

+ (NSButtonCell *)sharedGraphicsRenderer {
	static NSButtonCell *_backingCell = nil;
	if(!_backingCell)
		_backingCell = [NSButtonCell new];
	return _backingCell;
}

#pragma mark - Initialization

+ (instancetype)buttonWithType:(TUIButtonType)buttonType {
	TUIButton *b = [[self alloc] initWithFrame:CGRectZero];
	b->_buttonFlags.buttonType = buttonType;
	
	return b;
}

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		_buttonFlags.buttonType = TUIButtonTypeStandard;
		self.imagePosition = TUIControlImagePositionOverlap;
		
		self.contentLookup = [NSMutableDictionary dictionary];
		self.backgroundColor = [NSColor clearColor];
		self.opaque = NO;
		
		self.needsDisplayWhenWindowsKeyednessChanges = YES;
		_buttonFlags.adjustsImageWhenDisabled = YES;
		_buttonFlags.adjustsImageWhenHighlighted = YES;
		_buttonFlags.dimsInBackground = YES;
	}
	return self;
}

#pragma mark - Setup

- (BOOL)acceptsFirstResponder {
	return NO;
}

- (TUIButtonType)buttonType {
	return _buttonFlags.buttonType;
}

#pragma mark - Properties

- (TUILabel *)titleLabel {
	if(!_titleLabel) {
		_titleLabel = [[TUILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.userInteractionEnabled = NO;
		_titleLabel.backgroundColor = [NSColor clearColor];
		
		// We'll draw the title ourselves.
		_titleLabel.hidden = YES;
		[self addSubview:_titleLabel];
	}
	return _titleLabel;
}

- (BOOL)dimsInBackground {
	return _buttonFlags.dimsInBackground;
}

- (void)setDimsInBackground:(BOOL)flag {
	_buttonFlags.dimsInBackground = flag;
}

- (BOOL)adjustsImageWhenHighlighted {
	return _buttonFlags.adjustsImageWhenHighlighted;
}

- (void)setAdjustsImageWhenHighlighted:(BOOL)flag {
	_buttonFlags.adjustsImageWhenHighlighted = flag;
}

- (BOOL)adjustsImageWhenDisabled {
	return _buttonFlags.adjustsImageWhenDisabled;
}

- (void)setAdjustsImageWhenDisabled:(BOOL)flag {
	_buttonFlags.adjustsImageWhenDisabled = flag;
}

- (BOOL)reversesTitleShadowWhenHighlighted {
	return _buttonFlags.reversesTitleShadowWhenHighlighted;
}

- (void)setReversesTitleShadowWhenHighlighted:(BOOL)flag {
	_buttonFlags.reversesTitleShadowWhenHighlighted = flag;
}

#pragma mark - Overrides

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
	if(self.buttonType == TUIButtonTypeStandard) {
		bounds.origin.y -= 2.0f;
		bounds.size.width += 10.0f;
		bounds.origin.x -= 5.0f;
	}
	
	return CGRectIntegral(bounds);
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
	if(self.buttonType == TUIButtonTypeStandard) {
		bounds.origin.y -= 2.0f;
		bounds.size.width += 10.0f;
		bounds.origin.x -= 5.0f;
	}
	
	return CGRectIntegral(bounds);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
	return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
	return contentRect;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return self.currentImage.size;
}

#pragma mark - Drawing

- (void)drawBackground:(CGRect)rect {
	CGRect drawingRect = [self backgroundRectForBounds:self.bounds];
	
	// Secondary State holds either highlighted or selected states.
	// Background State holds window background and disabled states.
	BOOL secondaryState = (self.state & TUIControlStateHighlighted) || (self.state & TUIControlStateSelected);
	BOOL backgroundState = (![self.nsView isWindowKey] && _buttonFlags.dimsInBackground) || !self.enabled;
	
	// Determine the correct graphics renderer style, and use
	// NSNotFound for Inline and Custom drawing styles.
	NSBezelStyle graphicsStyle = NSNotFound;
	if(self.buttonType == TUIButtonTypeStandard)
		graphicsStyle = NSRoundedBezelStyle;
	else if(self.buttonType == TUIButtonTypeMinimal)
		graphicsStyle = NSRoundRectBezelStyle;
	else if(self.buttonType == TUIButtonTypeTextured)
		graphicsStyle = NSTexturedRoundedBezelStyle;
	else if(self.buttonType == TUIButtonTypeRectangular)
		graphicsStyle = NSSmallSquareBezelStyle;
	else if(self.buttonType == TUIButtonTypeCircular)
		graphicsStyle = NSCircularBezelStyle;
	
	// Set the graphics renderer states so CoreUI draws the button for us properly.
	[[TUIButton sharedGraphicsRenderer] setHighlighted:secondaryState];
	[[TUIButton sharedGraphicsRenderer] setEnabled:!backgroundState];
	
	// If we found the proper graphics style, allow the graphics renderer to draw it.
	// If not, draw it ourselves (Inline or Custom styles only, currently).
	if(graphicsStyle != NSNotFound) {
		[[TUIButton sharedGraphicsRenderer] setBezelStyle:graphicsStyle];
		[[TUIButton sharedGraphicsRenderer] drawBezelWithFrame:drawingRect inView:self.nsView];
		
	} else if(self.buttonType == TUIButtonTypeInline) {
		CGFloat radius = self.bounds.size.height / 2;
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:drawingRect xRadius:radius yRadius:radius];
		
		if(secondaryState) {
			[[NSColor colorWithCalibratedWhite:0.15 alpha:0.85] set];
			[path fill];
			
			if(self.state & TUIControlStateSelected) {
				[path tui_fillWithInnerShadow:[NSShadow tui_shadowWithRadius:3.0 offset:NSZeroSize
																	   color:[NSColor shadowColor]]];
			}
		} else if(self.state & TUIControlStateHover) {
			[[NSColor colorWithCalibratedWhite:0.15 alpha:0.5] set];
			[path fill];
		}
	} else if(self.buttonType == TUIButtonTypeCustom) {
		NSImage *backgroundImage = self.currentBackgroundImage;
		if(backgroundImage) {
			[backgroundImage tui_drawInRect:rect];
		} else {
			[self.backgroundColor setFill];
			CGContextFillRect(TUIGraphicsGetCurrentContext(), self.bounds);
		}
	}
}

- (void)drawContent:(CGRect)rect {
	//rect = CGRectInset(rect, 2.0f, 2.0f);
	
	// Secondary State holds either highlighted or selected states.
	// Background State holds window background and disabled states.
	BOOL secondaryState = (self.state & TUIControlStateHighlighted) || (self.state & TUIControlStateSelected);
	secondaryState &= self.adjustsImageWhenHighlighted;
	BOOL backgroundState = (![self.nsView isWindowKey] && _buttonFlags.dimsInBackground);
	backgroundState |= !self.enabled;
	
	// Handle the image if it exists.
	NSImage *image = self.currentImage;
	CGRect appliedImageRect = CGRectZero;
	if(image != nil && self.imagePosition != TUIControlImagePositionNone) {
		CGRect imageRect = rect;
		if(![image isKindOfClass:[TUIStretchableImage class]]) {
			
			// Not a stretchable image, so center it.
			imageRect.origin = CGPointZero;
			imageRect.size = image.size;
			
			// Make sure we respect our .imagePosition property, and
			// adjust the frame accordingly for both image and text.
			CGRect b = rect;
			if(self.imagePosition == TUIControlImagePositionBelow || self.imagePosition == TUIControlImagePositionAbove) {
				b.size.height /= 2;
				if(self.imagePosition == TUIControlImagePositionAbove)
					b.origin.y += b.size.height;
			} else if(self.imagePosition == TUIControlImagePositionLeft || self.imagePosition == TUIControlImagePositionRight) {
				b.size.width = imageRect.size.width;
				if(self.imagePosition == TUIControlImagePositionRight)
					b.origin.x = rect.size.width - imageRect.size.width;
			}
			
			appliedImageRect = imageRect = ABRectCenteredInRect(imageRect, TUIEdgeInsetsInsetRect(b, self.imageEdgeInsets));
		}
		
		// Using the shared graphics renderer, we get free template image drawing,
		// along with disabled and highlighted state drawing.
		[[TUIButton sharedGraphicsRenderer] setEnabled:!backgroundState];
		[[TUIButton sharedGraphicsRenderer] setHighlighted:secondaryState];
		[[TUIButton sharedGraphicsRenderer] drawImage:image withFrame:imageRect inView:self.nsView];
	}
	
	if(self.imagePosition != TUIControlImagePositionOnly) {
		NSString *title = self.currentTitle;
		if(title != nil)
			self.titleLabel.text = title;
		
		NSColor *color = self.currentTitleColor;
		if(color != nil)
			self.titleLabel.textColor = color;
		
		// The renderer's shadow color may have been manually set,
		// in which case we don't want to reset it to nothing.
		NSColor *shadowColor = self.currentTitleShadowColor;
		if(shadowColor != nil)
			self.titleLabel.renderer.shadowColor = shadowColor;
		
		CGContextRef ctx = TUIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx); {
			CGFloat alpha = ((self.nsView.isWindowKey && _buttonFlags.dimsInBackground) ? 1.0f : 0.5);
			CGContextSetAlpha(ctx, alpha);
			
			// Make sure we respect our .imagePosition property, and
			// adjust the frame accordingly for both image and text.
			CGRect b = rect;
			if(self.imagePosition == TUIControlImagePositionBelow || self.imagePosition == TUIControlImagePositionAbove) {
				b.size.height /= 2;
				if(self.imagePosition == TUIControlImagePositionBelow)
					CGContextTranslateCTM(ctx, 0, b.origin.y + b.size.height);
			} else if(self.imagePosition == TUIControlImagePositionLeft || self.imagePosition == TUIControlImagePositionRight) {
				b.size.width -= appliedImageRect.size.width;
				if(self.imagePosition == TUIControlImagePositionLeft)
					CGContextTranslateCTM(ctx, appliedImageRect.size.width, 0);
			}
			
			CGContextTranslateCTM(ctx, _titleEdgeInsets.left, _titleEdgeInsets.bottom);
			b.size.width -= (_titleEdgeInsets.left + _titleEdgeInsets.right);
			b.size.height -= (_titleEdgeInsets.top + _titleEdgeInsets.bottom);
			
			self.titleLabel.frame = b;
			[self.titleLabel drawRect:self.titleLabel.bounds];
		} CGContextRestoreGState(ctx);
	}
}

- (void)drawRect:(CGRect)rect {
	[self drawBackground:self.bounds];
	[self drawContent:self.bounds];
}

#pragma mark - Menu and Selected State

// FIXME: Happens even for large clickCount.
- (void)mouseDown:(NSEvent *)event {
	[super mouseDown:event];
	
	if(self.menu) {
		self.selected = YES;
		[self.menu popUpMenuPositioningItem:nil atLocation:(CGPoint) {
			.x = self.frameInNSView.origin.x + 6,
			.y = self.frameInNSView.origin.y - 2
		} inView:self.nsView];
		
		// After this happens, we never get a mouseUp: in the TUINSView.
		// This screws up _trackingView. For now, fake it with a fake mouseUp:.
		[self.nsView performSelector:@selector(mouseUp:) withObject:event afterDelay:0.0];
		[TUIView animateWithDuration:0.25f animations:^{
			[self redraw];
		}];
	}
}

- (void)mouseUp:(NSEvent *)event {
	[super mouseUp:event];
	if(![self eventInside:event])
		return;
	
	if((self.selectable || self.buttonType == TUIButtonTypeInline || self.menu) && self.enabled)
		self.selected = !self.selected;
}

#pragma mark - Highlight Reversing

- (void)stateWillChange {
	_buttonFlags.wasHighlighted = (self.state & TUIControlStateHighlighted);
}

- (void)stateDidChange {
	BOOL reverseShadow = (self.state & TUIControlStateHighlighted) != _buttonFlags.wasHighlighted;
	
	if(reverseShadow && self.reversesTitleShadowWhenHighlighted) {
		CGSize shadow = _titleLabel.renderer.shadowOffset;
		_titleLabel.renderer.shadowOffset = (CGSize) {
			.height = shadow.height * -1,
			.width = shadow.width * -1
		};
	}
}

#pragma mark -

@end

@implementation TUIButtonContent
@end

@implementation TUIButton (Content)

#pragma mark - Button Content Lookup

- (TUIButtonContent *)_contentForState:(TUIControlState)state {
	id key = @(state);
	TUIButtonContent *c = [_contentLookup objectForKey:key];
	
	// Try matching without the NotKey state.
	if(c == nil && (state & TUIControlStateNotKey))
		c = [_contentLookup objectForKey:@(state & ~TUIControlStateNotKey)];
	
	if(c == nil) {
		c = [[TUIButtonContent alloc] init];
		[_contentLookup setObject:c forKey:key];
	}
	
	return c;
}

- (void)setTitle:(NSString *)title forState:(TUIControlState)state {
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		[[self _contentForState:state] setTitle:title];
	}];
}

- (void)setTitleColor:(NSColor *)color forState:(TUIControlState)state {
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		[[self _contentForState:state] setTitleColor:color];
	}];
}

- (void)setTitleShadowColor:(NSColor *)color forState:(TUIControlState)state {
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		[[self _contentForState:state] setShadowColor:color];
	}];
}

- (void)setImage:(NSImage *)i forState:(TUIControlState)state {
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		[[self _contentForState:state] setImage:i];
	}];
}

- (void)setBackgroundImage:(NSImage *)i forState:(TUIControlState)state {
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		[[self _contentForState:state] setBackgroundImage:i];
	}];
}

- (NSString *)titleForState:(TUIControlState)state {
	return [[self _contentForState:state] title];
}

- (NSColor *)titleColorForState:(TUIControlState)state {
	return [[self _contentForState:state] titleColor];
}

- (NSColor *)titleShadowColorForState:(TUIControlState)state {
	return [[self _contentForState:state] shadowColor];
}

- (NSImage *)imageForState:(TUIControlState)state {
	return [[self _contentForState:state] image];
}

- (NSImage *)backgroundImageForState:(TUIControlState)state {
	return [[self _contentForState:state] backgroundImage];
}

- (NSString *)currentTitle {
	NSString *title = [self titleForState:self.state];
	if(title == nil) {
		if(self.state & TUIControlStateSelected)
			title = [self titleForState:TUIControlStateHighlighted];
		if(title == nil)
			title = [self titleForState:TUIControlStateNormal];
	}
	
	return title;
}

- (NSColor *)currentTitleColor {
	NSColor *color = [self titleColorForState:self.state];
	if(color == nil) {
		if(self.state & TUIControlStateSelected)
			color = [self titleColorForState:TUIControlStateHighlighted];
		if(color == nil)
			color = [self titleColorForState:TUIControlStateNormal];
	}
	
	return color;
}

- (NSColor *)currentTitleShadowColor {
	NSColor *color = [self titleShadowColorForState:self.state];
	if(color == nil) {
		if(self.state & TUIControlStateSelected)
			color = [self titleShadowColorForState:TUIControlStateHighlighted];
		if(color == nil)
			color = [self titleShadowColorForState:TUIControlStateNormal];
	}
	
	return color;
}

- (NSImage *)currentImage {
	NSImage *image = [self imageForState:self.state];
	if(image == nil) {
		if(self.state & TUIControlStateSelected)
			image = [self imageForState:TUIControlStateHighlighted];
		if(image == nil)
			image = [self imageForState:TUIControlStateNormal];
	}
	
	return image;
}

- (NSImage *)currentBackgroundImage {
	NSImage *image = [self backgroundImageForState:self.state];
	if(image == nil) {
		if(self.state & TUIControlStateSelected)
			image = [self backgroundImageForState:TUIControlStateHighlighted];
		if(image == nil)
			image = [self backgroundImageForState:TUIControlStateNormal];
	}
	
	return image;
}

#pragma mark -

@end
