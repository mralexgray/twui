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
#import "NSImage+TUIExtensions.h"
#import "TUIControl+Private.h"
#import "TUIImageView.h"
#import "TUILabel.h"
#import "TUINSView.h"
#import "TUIStretchableImage.h"
#import "TUITextRenderer.h"
#import "TUIAttributedString.h"

@interface TUIButtonContent : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSColor *titleColor;
@property (nonatomic, strong) NSColor *shadowColor;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *backgroundImage;

@end

@interface TUIButton () {
    struct {
        unsigned int buttonType:8;
		
		unsigned int dimsInBackground:1;
		unsigned int drawsGradientIconBackground:1;
		unsigned int lightButtonWhenHighlighted:1;
		unsigned int adjustsImageWhenHighlighted:1;
		unsigned int adjustsImageWhenDisabled:1;
		unsigned int reversesTitleShadowWhenHighlighted:1;
    } _buttonFlags;
}

@property (nonatomic, strong) NSMutableDictionary *contentLookup;

@property (nonatomic, strong, readwrite) TUILabel *titleLabel;
@property (nonatomic, strong, readwrite) TUIImageView *imageView;

@end

@implementation TUIButton

+ (id)buttonWithType:(TUIButtonType)buttonType {
	return [[self.class alloc] initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		_buttonFlags.buttonType = TUIButtonTypeBeveled;
		
		self.backgroundColor = [NSColor clearColor];
		self.opaque = NO;
		
		self.contentLookup = [[NSMutableDictionary alloc] init];
		
		self.needsDisplayWhenWindowsKeyednessChanges = YES;
		self.dimsInBackground = YES;
		self.reversesTitleShadowWhenHighlighted = NO;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame type:(TUIButtonType)type {
	if((self = [super initWithFrame:frame])) {
		_buttonFlags.buttonType = type;
		
		self.backgroundColor = [NSColor clearColor];
		self.opaque = NO;
		
		self.contentLookup = [[NSMutableDictionary alloc] init];
		
		self.needsDisplayWhenWindowsKeyednessChanges = YES;
		self.dimsInBackground = YES;
		self.reversesTitleShadowWhenHighlighted = NO;
	}
	return self;
}

- (BOOL)acceptsFirstResponder {
	return NO;
}

- (TUIButtonType)buttonType {
	return _buttonFlags.buttonType;
}

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

- (TUIImageView *)imageView {
	if(!_imageView) {
		_imageView = [[TUIImageView alloc] initWithFrame:TUIEdgeInsetsInsetRect(self.bounds, self.imageEdgeInsets)];
		_imageView.backgroundColor = [NSColor clearColor];
		
		[self addSubview:_imageView];
	}
	return _imageView;
}

- (BOOL)dimsInBackground {
	return _buttonFlags.dimsInBackground;
}

- (void)setDimsInBackground:(BOOL)dimsInBackground {
	_buttonFlags.dimsInBackground = dimsInBackground;
}

- (BOOL)drawsGradientIconBackground {
	return _buttonFlags.drawsGradientIconBackground;
}

- (void)setDrawsGradientIconBackground:(BOOL)drawsGradientIconBackground {
	_buttonFlags.drawsGradientIconBackground = drawsGradientIconBackground;
}

- (BOOL)lightButtonWhenHighlighted {
	return _buttonFlags.lightButtonWhenHighlighted;
}

- (void)setLightButtonWhenHighlighted:(BOOL)lightButtonWhenHighlighted {
	_buttonFlags.lightButtonWhenHighlighted = lightButtonWhenHighlighted;
}

- (BOOL)adjustsImageWhenHighlighted {
	return _buttonFlags.adjustsImageWhenHighlighted;
}

- (void)setAdjustsImageWhenHighlighted:(BOOL)adjustsImageWhenHighlighted {
	_buttonFlags.adjustsImageWhenHighlighted = adjustsImageWhenHighlighted;
}

- (BOOL)adjustsImageWhenDisabled {
	return _buttonFlags.adjustsImageWhenDisabled;
}

- (void)setAdjustsImageWhenDisabled:(BOOL)adjustsImageWhenDisabled {
	_buttonFlags.adjustsImageWhenDisabled = adjustsImageWhenDisabled;
}

- (BOOL)reversesTitleShadowWhenHighlighted {
	return _buttonFlags.reversesTitleShadowWhenHighlighted;
}

- (void)setReversesTitleShadowWhenHighlighted:(BOOL)reversesTitleShadowWhenHighlighted {
	_buttonFlags.reversesTitleShadowWhenHighlighted = reversesTitleShadowWhenHighlighted;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
	return bounds;
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
	return bounds;
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

- (void)drawBackground:(CGRect)rect {
	if(self.buttonType == TUIButtonTypeCustom) {
		NSImage *backgroundImage = self.currentBackgroundImage;
		if(backgroundImage) {
			[backgroundImage drawInRect:[self backgroundRectForBounds:self.bounds]
							   fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		} else {
			[self.backgroundColor setFill];
			CGContextFillRect(TUIGraphicsGetCurrentContext(), self.bounds);
		}
	} else if(self.buttonType == TUIButtonTypeStandard) {
		CGFloat level = self.state == TUIControlStateHighlighted ? 0.93 : 0.99;
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 0.5, 0.5)
															 xRadius:3.5f yRadius:3.5f];
		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.93 alpha:1.0]
															 endingColor:[NSColor colorWithCalibratedWhite:level alpha:1.0]];
		
		[gradient drawInBezierPath:path angle:90.0f];
		[[NSColor grayColor] setStroke];
		[path stroke];
		
		if(self.state == TUIControlStateHighlighted) {
			NSColor *shadowColor = [[NSColor shadowColor] colorWithAlphaComponent:0.5];
			NSShadow *shadow = [NSShadow shadowWithRadius:2.0f offset:CGSizeMake(0, -1) color:shadowColor];
			
			[NSGraphicsContext saveGraphicsState]; {
				[path setClip];
				[shadow set];
				[path stroke];
			} [NSGraphicsContext restoreGraphicsState];
		}
	} else if(self.buttonType == TUIButtonTypeBeveled) {
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:self.bounds];
		NSGradient *bevel = [[NSGradient alloc] initWithColorsAndLocations:
							 [NSColor colorWithCalibratedWhite:0.95 alpha:0.5], 0.0,
							 [NSColor colorWithCalibratedWhite:0.90 alpha:0.5], 0.5,
							 [NSColor colorWithCalibratedWhite:0.85 alpha:0.5], 0.5,
							 [NSColor colorWithCalibratedWhite:0.84 alpha:0.5], 1.0, nil];
		
		[self.backgroundColor set];
		[path fill];
		
		[NSGraphicsContext saveGraphicsState];
		[[NSShadow shadowWithRadius:1.0
							 offset:NSMakeSize(0, -1.0)
							  color:[NSColor colorWithCalibratedWhite:.863 alpha:.75]] set];
		[path fill];
		[NSGraphicsContext restoreGraphicsState];
		
		[bevel drawInBezierPath:path angle:-90.0];
		if(self.state == TUIControlStateHighlighted) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			[path fill];
		}
		
		[[NSColor colorWithCalibratedWhite:0.569 alpha:1.0] setStroke];
		[path strokeInside];
		
		[path fillWithInnerShadow:[NSShadow shadowWithRadius:4.0
													  offset:NSMakeSize(0.0, -1.0)
													   color:[NSColor colorWithCalibratedWhite:0.0 alpha:.52]]];
	}
}

- (void)drawRect:(CGRect)rect {
	BOOL key = self.nsView.isWindowKey;
	CGFloat alpha = 1.0f;
	if(_buttonFlags.dimsInBackground)
		alpha = key ? alpha : 0.5;
	
	[self drawBackground:rect];
	
	NSImage *image = self.currentImage;
	if(image) {
		CGRect imageRect = self.bounds;
		if(![image isKindOfClass:[TUIStretchableImage class]]) {
			
			// Not a stretchable image, so center it.
			imageRect.origin = CGPointZero;
			imageRect.size = image.size;
			
			CGRect b = self.bounds;
			b.origin.x += _imageEdgeInsets.left;
			b.origin.y += _imageEdgeInsets.bottom;
			b.size.width -= _imageEdgeInsets.left + _imageEdgeInsets.right;
			b.size.height -= _imageEdgeInsets.bottom + _imageEdgeInsets.top;
			imageRect = ABRectRoundOrigin(ABRectCenteredInRect(imageRect, b));
		}

		[image drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
	}
	
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
		CGContextTranslateCTM(ctx, _titleEdgeInsets.left, _titleEdgeInsets.bottom);
		CGContextSetAlpha(ctx, alpha);
		
		CGRect titleFrame = self.bounds;
		titleFrame.size.width -= (_titleEdgeInsets.left + _titleEdgeInsets.right);
		titleFrame.size.height -= (_titleEdgeInsets.top + _titleEdgeInsets.bottom);
		
		self.titleLabel.frame = titleFrame;
		[self.titleLabel drawRect:self.titleLabel.bounds];
	} CGContextRestoreGState(ctx);
}

- (void)mouseDown:(NSEvent *)event {
	[super mouseDown:event];
	
	// BUG: Happens even for large clickCount.
	if(self.popUpMenu) {
		NSMenu *menu = self.popUpMenu;
		NSPoint p = [self frameInNSView].origin;
		p.x += 6;
		p.y -= 2;
		[menu popUpMenuPositioningItem:nil atLocation:p inView:self.nsView];
		
		// After this happens, we never get a mouseUp: in the TUINSView.
		// This screws up _trackingView. For now, fake it with a fake mouseUp:.
		[self.nsView performSelector:@selector(mouseUp:) withObject:event afterDelay:0.0];
		
		_controlFlags.tracking = 0;
		[TUIView animateWithDuration:0.2 animations:^{
			[self redraw];
		}];
	}
}

- (void)_stateDidChange {
	[super _stateDidChange];
	
	[self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
	if(self.highlighted != highlighted && self.reversesTitleShadowWhenHighlighted) {
		_titleLabel.renderer.shadowOffset = CGSizeMake(_titleLabel.renderer.shadowOffset.width,
													   -_titleLabel.renderer.shadowOffset.height);
	}
	
	[super setHighlighted:highlighted];
}

@end

@implementation TUIButtonContent
@end

@implementation TUIButton (Content)

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
	[self _stateWillChange];
	[[self _contentForState:state] setTitle:title];
	[self setNeedsDisplay];
	[self _stateDidChange];
}

- (void)setTitleColor:(NSColor *)color forState:(TUIControlState)state {
	[self _stateWillChange];
	[[self _contentForState:state] setTitleColor:color];
	[self setNeedsDisplay];
	[self _stateDidChange];
}

- (void)setTitleShadowColor:(NSColor *)color forState:(TUIControlState)state {
	[self _stateWillChange];
	[[self _contentForState:state] setShadowColor:color];
	[self setNeedsDisplay];
	[self _stateDidChange];
}

- (void)setImage:(NSImage *)i forState:(TUIControlState)state {
	[self _stateWillChange];
	[[self _contentForState:state] setImage:i];
	[self setNeedsDisplay];
	[self _stateDidChange];
}

- (void)setBackgroundImage:(NSImage *)i forState:(TUIControlState)state {
	[self _stateWillChange];
	[[self _contentForState:state] setBackgroundImage:i];
	[self setNeedsDisplay];
	[self _stateDidChange];
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
	if(title == nil)
		title = [self titleForState:TUIControlStateNormal];
	
	return title;
}

- (NSColor *)currentTitleColor {
	NSColor *color = [self titleColorForState:self.state];
	if(color == nil)
		color = [self titleColorForState:TUIControlStateNormal];
	
	return color;
}

- (NSColor *)currentTitleShadowColor {
	NSColor *color = [self titleShadowColorForState:self.state];
	if(color == nil)
		color = [self titleShadowColorForState:TUIControlStateNormal];
	
	return color;
}

- (NSImage *)currentImage {
	NSImage *image = [self imageForState:self.state];
	if(image == nil)
		image = [self imageForState:TUIControlStateNormal];
	
	return image;
}

- (NSImage *)currentBackgroundImage {
	NSImage *image = [self backgroundImageForState:self.state];
	if(image == nil)
		image = [self backgroundImageForState:TUIControlStateNormal];
	
	return image;
}

@end
