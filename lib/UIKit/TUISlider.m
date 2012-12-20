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

#import "TUISlider.h"
#import "NSImage+TUIExtensions.h"
#import "TUICGAdditions.h"
#import "TUINSView.h"

@interface TUIExtendedSliderCell : NSSliderCell
@property (nonatomic, assign) CGRect knobRect;
@end

@implementation TUISlider

+ (TUIExtendedSliderCell *)sharedGraphicsRenderer {
	static TUIExtendedSliderCell *_backingCell;
	if(_backingCell == nil)
		_backingCell = [TUIExtendedSliderCell new];
	return _backingCell;
}

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.backgroundColor = [NSColor clearColor];
		
		self.minValue = 0.0f;
		self.maxValue = 100.0f;
		self.value = 0.0f;
		
		self.knobThickness = 0.0f;
		self.numberOfTickMarks = 0;
		
		self.drawTickMarksOnAlternateSide = NO;
		self.snapToTickMarks = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	
	// Set up the graphics renderer before drawing. Although it
	// seems like a CPU burden, it takes ~0.000025 seconds to set.
	[slider setMinValue:self.minValue];
	[slider setMaxValue:self.maxValue];
	[slider setDoubleValue:self.value];
	[slider setKnobThickness:self.knobThickness];
	[slider setNumberOfTickMarks:self.numberOfTickMarks];
	[slider setTickMarkPosition:(NSTickMarkPosition)self.drawTickMarksOnAlternateSide];
	[slider setAllowsTickMarkValuesOnly:self.snapToTickMarks];
	
	// Calculates internal drawing info.
	[slider calcDrawInfo:self.bounds];
	[self drawTrack:self.bounds];
	[self drawKnob:self.bounds];
}

- (void)drawTrack:(CGRect)rect {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	CGPoint trackPoint = CGPointMake(NSMidX(slider.knobRect), NSMidY(slider.knobRect));
	
	if(self.tracking)
		[slider startTrackingAt:trackPoint inView:self.nsView];
	
	[slider drawWithFrame:rect inView:self.nsView];
	
	if(self.tracking)
		[slider stopTracking:trackPoint at:trackPoint inView:self.nsView mouseIsUp:YES];
}

- (void)drawKnob:(CGRect)rect {
	// NSSliderCell can't draw the knob seperately from the track.
}

- (CGFloat)snapValueToSlider:(CGFloat)value {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	
	if(self.snapToTickMarks)
		return [slider closestTickMarkValueToValue:value];
	else
		return value;
}

- (BOOL)beginTrackingWithEvent:(NSEvent *)event {
	if(!self.enabled)
		return NO;
	
	CGFloat value;
	CGPoint entryPoint = [self convertFromWindowPoint:[(NSWindow *)self.nsWindow convertScreenToBase:[NSEvent mouseLocation]]];
	
	if(self.bounds.size.width > self.bounds.size.height)
		value = (entryPoint.x / self.bounds.size.width) * (self.maxValue - self.minValue) + self.minValue;
	else
		value = (entryPoint.y / self.bounds.size.height) * (self.maxValue - self.minValue) + self.minValue;
	
	self.value = [self snapValueToSlider:value];
	
	return YES;
}

- (BOOL)continueTrackingWithEvent:(NSEvent *)event {
	if(!self.enabled)
		return NO;
	
	CGFloat value;
	CGPoint entryPoint = [self convertFromWindowPoint:[(NSWindow *)self.nsWindow convertScreenToBase:[NSEvent mouseLocation]]];
	
	if(self.bounds.size.width > self.bounds.size.height)
		value = (entryPoint.x / self.bounds.size.width) * (self.maxValue - self.minValue) + self.minValue;
	else
		value = (entryPoint.y / self.bounds.size.height) * (self.maxValue - self.minValue) + self.minValue;
	
	self.value = [self snapValueToSlider:value];
	
	return YES;
}

@end

@implementation TUIExtendedSliderCell

// Defer the drawing, but allow the cell to cache the rects.
- (void)calcDrawInfo:(NSRect)rect {
	[NSImage tui_imageWithSize:rect.size drawing:^(CGContextRef ctx) {
		[NSGraphicsContext saveGraphicsState];
		NSGraphicsContext *context = [NSGraphicsContext currentContext];
		if([context graphicsPort] != ctx) {
			context = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:YES];
			[NSGraphicsContext setCurrentContext:context];
		}
		
		[super drawWithFrame:(CGRect) { .size = rect.size } inView:nil];
		[NSGraphicsContext restoreGraphicsState];
	}];
}

// Cache the current knob rect, after calculating draw info.
- (void)drawKnob:(NSRect)knobRect {
	self.knobRect = knobRect;
	[super drawKnob:knobRect];
}

@end
