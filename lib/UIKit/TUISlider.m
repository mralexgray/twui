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
		
		self.maximumValue = 0.0f;
		self.minimumValue = 1.0f;
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
	// seems like a burden, it takes around 25ms to configure.
	[slider setMinValue:self.minimumValue];
	[slider setMaxValue:self.maximumValue];
	[slider setDoubleValue:self.value];
	[slider setKnobThickness:self.knobThickness];
	[slider setNumberOfTickMarks:self.numberOfTickMarks];
	[slider setTickMarkPosition:(NSTickMarkPosition)self.drawTickMarksOnAlternateSide];
	[slider setAllowsTickMarkValuesOnly:self.snapToTickMarks];
	
	// Call appropriate drawing mechanisms.
	if(self.drawTrack)
		self.drawTrack(self, self.bounds);
	else
		[self drawTrack:self.bounds];
	
	if(self.drawKnob)
		self.drawKnob(self, self.bounds);
	else
		[self drawKnob:self.bounds];
}

- (void)drawTrack:(CGRect)rect {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	[slider calcDrawInfo:self.bounds];
	
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

- (CGFloat)sliderValueForPoint:(CGPoint)point {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	
	CGFloat value;
	if(self.bounds.size.width > self.bounds.size.height)
		value = ((self.bounds.size.width - point.x) / self.bounds.size.width) * (self.maximumValue - self.minimumValue) + self.minimumValue;
	else
		value = ((self.bounds.size.height - point.y) / self.bounds.size.height) * (self.maximumValue - self.minimumValue) + self.minimumValue;
	
	if(self.snapToTickMarks)
		return [slider closestTickMarkValueToValue:value];
	else
		return value;
}

- (BOOL)beginTrackingWithEvent:(NSEvent *)event {
	if(!self.enabled)
		return NO;
	
	CGPoint entryPoint = [self convertFromWindowPoint:[(NSWindow *)self.nsWindow convertScreenToBase:[NSEvent mouseLocation]]];
	self.value = [self sliderValueForPoint:entryPoint];
	
	return YES;
}

- (BOOL)continueTrackingWithEvent:(NSEvent *)event {
	if(!self.enabled)
		return NO;
	
	CGPoint entryPoint = [self convertFromWindowPoint:[(NSWindow *)self.nsWindow convertScreenToBase:[NSEvent mouseLocation]]];
	self.value = [self sliderValueForPoint:entryPoint];
	
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
