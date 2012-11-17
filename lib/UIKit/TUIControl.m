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
#import "TUIControl+Private.h"
#import "TUIView+Accessibility.h"
#import "TUINSView.h"

@implementation TUIControl

- (id)initWithFrame:(CGRect)rect {
	if((self = [super initWithFrame:rect])) {
		self.targetActions = [NSMutableArray array];
		self.accessibilityTraits |= TUIAccessibilityTraitButton;
	}
	
	return self;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return self.acceptsFirstMouse;
}

- (TUIControlState)state {
	// Start with the normal state, then OR in an implicit
	// state that is based on other properties.
	TUIControlState actual = TUIControlStateNormal;
	
	if(_controlFlags.disabled)
		actual |= TUIControlStateDisabled;
	if(![self.nsView isWindowKey])
		actual |= TUIControlStateNotKey;
	
	if(!_controlFlags.selected) {
		if(_controlFlags.hover)
			actual |= TUIControlStateHover;
		
		if(_controlFlags.tracking || _controlFlags.highlighted)
			actual |= TUIControlStateHighlighted;
	} else
		actual |= TUIControlStateSelected;
	
	return actual;
}

- (BOOL)acceptsFirstMouse {
	return _controlFlags.acceptsFirstMouse;
}

- (void)setAcceptsFirstMouse:(BOOL)s {
	_controlFlags.acceptsFirstMouse = s;
}

- (BOOL)isEnabled {
	return !_controlFlags.disabled;
}

- (void)setEnabled:(BOOL)e {
	[self _stateWillChange];
	_controlFlags.disabled = !e;
	[self _stateDidChange];
	[self setNeedsDisplay];
}

- (BOOL)isTracking {
	return _controlFlags.tracking;
}

- (void)setTracking:(BOOL)t {
	_controlFlags.tracking = t;
}

- (BOOL)isSelected {
  return _controlFlags.selected;
}

- (void)setSelected:(BOOL)selected {
	[self _stateWillChange];
	_controlFlags.selected = selected;
	[self _stateDidChange];
	[self setNeedsDisplay];
}

- (BOOL)isHighlighted {
	return _controlFlags.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted {
	[self _stateWillChange];
	_controlFlags.highlighted = highlighted;
	[self _stateDidChange];
	[self setNeedsDisplay];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	_controlFlags.hover = 1;
	[self sendActionsForControlEvents:TUIControlEventMouseHoverBegan];
	[self setNeedsDisplay];
}

- (void)mouseExited:(NSEvent *)theEvent {
	_controlFlags.hover = 0;
	[self sendActionsForControlEvents:TUIControlEventMouseHoverEnded];
	[self setNeedsDisplay];
}

- (void)mouseDown:(NSEvent *)event {
	if(_controlFlags.disabled)
		return;
	[super mouseDown:event];
	
	_controlFlags.hover = 0;
	[self sendActionsForControlEvents:TUIControlEventMouseHoverEnded];
	[self setNeedsDisplay];
	
	BOOL track = [self beginTrackingWithEvent:event];
	if(track && !_controlFlags.tracking) {
		[self _stateWillChange];
		_controlFlags.tracking = 1;
		[self _stateDidChange];
	} else if(!track) {
		[self _stateWillChange];
		_controlFlags.tracking = 0;
		[self _stateDidChange];
	}
	[self setNeedsDisplay];
	
	if(_controlFlags.tracking) {
		TUIControlEvents currentEvents = (([event clickCount] >= 2) ?
										  TUIControlEventMouseDownRepeat :
										  TUIControlEventMouseDown);
		
		[self sendActionsForControlEvents:currentEvents];
	}
}

- (void)mouseDragged:(NSEvent *)event {
	if(_controlFlags.disabled)
		return;
	[super mouseDragged:event];
	
	if(_controlFlags.tracking) {
		BOOL track = [self continueTrackingWithEvent:event];
		if(track) {
			[self _stateWillChange];
			_controlFlags.tracking = 1;
			[self _stateDidChange];
		} else {
			[self _stateWillChange];
			_controlFlags.tracking = 0;
			[self _stateDidChange];
		}
		[self setNeedsDisplay];
		
		if(_controlFlags.tracking) {
			TUIControlEvents currentEvents = (([self eventInside:event])?
											  TUIControlEventMouseDragInside :
											  TUIControlEventMouseDragOutside);
			
			[self sendActionsForControlEvents:currentEvents];
		}
	}
	
}

- (void)mouseUp:(NSEvent *)event {
	if(_controlFlags.disabled)
		return;
	[super mouseUp:event];
	
	if([self eventInside:event]) {
		_controlFlags.hover = 1;
		[self sendActionsForControlEvents:TUIControlEventMouseHoverBegan];
		[self setNeedsDisplay];
	}
	
	if(_controlFlags.tracking) {
		[self endTrackingWithEvent:event];
		
		TUIControlEvents currentEvents = (([self eventInside:event])?
										  TUIControlEventMouseUpInside :
										  TUIControlEventMouseUpOutside);
		
		[self sendActionsForControlEvents:currentEvents];
		
		[self _stateWillChange];
		_controlFlags.tracking = 0;
		[self _stateDidChange];
		[self setNeedsDisplay];
	}
}

// Support tracking cancelation.
- (void)willMoveToSuperview:(TUIView *)newSuperview {
	if(!_controlFlags.disabled && _controlFlags.tracking) {
		[self _stateWillChange];
		_controlFlags.tracking = 0;
		[self _stateDidChange];

		[self endTrackingWithEvent:nil];
		[self setNeedsDisplay];
	}
}

- (void)willMoveToWindow:(TUINSWindow *)newWindow {
	if(!_controlFlags.disabled && _controlFlags.tracking) {
		[self _stateWillChange];
		_controlFlags.tracking = 0;
		[self _stateDidChange];

		[self endTrackingWithEvent:nil];
		[self setNeedsDisplay];
	}
}

// Override.
- (BOOL)beginTrackingWithEvent:(NSEvent *)event {
	return YES;
}

- (BOOL)continueTrackingWithEvent:(NSEvent *)event {
	return YES;
}

- (void)endTrackingWithEvent:(NSEvent *)event {
	return;
}

// Override.
- (void)_stateWillChange {
	return;
}

- (void)_stateDidChange {
	return;
}

@end
