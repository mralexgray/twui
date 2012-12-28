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

#pragma mark - Initialization

+ (TUIExtendedSliderCell *)sharedGraphicsRenderer {
	static TUIExtendedSliderCell *_backingCell;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		_backingCell = [TUIExtendedSliderCell new];
	});
	return _backingCell;
}

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.backgroundColor = [NSColor clearColor];
		
		self.minimumValue = 0.0f;
		self.maximumValue = 1.0f;
		self.value = 0.0f;
		
		self.knobThickness = 0.0f;
		self.numberOfTickMarks = 0;
		
		self.drawTickMarksOnAlternateSide = NO;
		self.snapsToTickMarks = NO;
	}
	return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	
	// Set up the graphics renderer before drawing. Although it
	// seems like a burden, it takes around 25ms to configure.
	[slider setControlSize:(NSControlSize)self.controlSize];
	[slider setMinValue:self.minimumValue];
	[slider setMaxValue:self.maximumValue];
	[slider setDoubleValue:self.value];
	[slider setKnobThickness:self.knobThickness];
	[slider setNumberOfTickMarks:self.numberOfTickMarks];
	[slider setTickMarkPosition:(NSTickMarkPosition)self.drawTickMarksOnAlternateSide];
	[slider setAllowsTickMarkValuesOnly:self.snapsToTickMarks];
	[slider calcDrawInfo:self.bounds];
	
	// Call appropriate drawing mechanisms.
	if(self.drawTrack)
		self.drawTrack(self, self.bounds);
	else
		[self drawTrack:self.bounds];
	
	if(self.drawKnob)
		self.drawKnob(self, slider.knobRect);
	else
		[self drawKnob:slider.knobRect];
}

- (void)drawTrack:(CGRect)rect {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	
	if(self.tracking) {
		CGPoint trackPoint = CGPointMake(NSMidX(slider.knobRect), NSMidY(slider.knobRect));
		[slider startTrackingAt:trackPoint inView:self.nsView];
		[slider drawWithFrame:rect inView:self.nsView];
		[slider stopTracking:trackPoint at:trackPoint inView:self.nsView mouseIsUp:YES];
	} else {
		[slider drawWithFrame:rect inView:self.nsView];
	}
}

- (void)drawKnob:(CGRect)rect {
	// NSSliderCell can't draw the knob seperately from the track.
	// The rect passed in, however, is the correct knob rect.
}

#pragma mark - User Interaction

- (CGFloat)sliderValueForPoint:(CGPoint)point {
	TUIExtendedSliderCell *slider = [TUISlider sharedGraphicsRenderer];
	[slider startTrackingAt:point inView:self.nsView];
	[slider stopTracking:point at:point inView:self.nsView mouseIsUp:YES];
	
	if(self.snapsToTickMarks)
		return [slider closestTickMarkValueToValue:slider.doubleValue];
	else
		return slider.doubleValue;
}

- (BOOL)beginTrackingWithEvent:(NSEvent *)event {
	if(!self.enabled)
		return NO;
	
	self.value = [self sliderValueForPoint:[self convertFromWindowPoint:event.locationInWindow]];
	self.highlighted = YES;
	return YES;
}

- (BOOL)continueTrackingWithEvent:(NSEvent *)event {
	if(!self.enabled)
		return NO;
	
	self.value = [self sliderValueForPoint:[self convertFromWindowPoint:event.locationInWindow]];
	return YES;
}

- (void)endTrackingWithEvent:(NSEvent *)event {
	self.highlighted = NO;
}

#pragma mark - Properties

// Wrap the value between minimum and maximum values.
- (void)setValue:(CGFloat)value {
	if(value > _maximumValue)
		value = _maximumValue;
	if(value < _minimumValue)
		value = _minimumValue;
	
	_value = value;
	[self sendActionsForControlEvents:TUIControlEventValueChanged];
}

// Wrap the minimum value below the value and maximum values.
- (void)setMinimumValue:(CGFloat)minimumValue {
	if(_maximumValue < minimumValue)
		_maximumValue = minimumValue;
	if(_value < minimumValue)
		_value = minimumValue;
	
	_minimumValue = minimumValue;
	[self sendActionsForControlEvents:TUIControlEventValueChanged];
}

// Wrap the maximum value above the value and minimum values.
- (void)setMaximumValue:(CGFloat)maximumValue {
	if(_minimumValue > maximumValue)
		_minimumValue = maximumValue;
	if(_value > maximumValue)
		_value = maximumValue;
	
	_maximumValue = maximumValue;
	[self sendActionsForControlEvents:TUIControlEventValueChanged];
}

#pragma mark -

@end

@implementation TUIExtendedSliderCell

#pragma mark - Calculation

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

#pragma mark -

@end
