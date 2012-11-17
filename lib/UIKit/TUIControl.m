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
#import "TUIView+Accessibility.h"
#import "TUINSView.h"

@interface TUIControlTargetAction : NSObject

// nil goes up the responder chain
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, assign) TUIControlEvents controlEvents;

@end

@implementation TUIControlTargetAction
@end

@interface TUIControl () {
	struct {
		unsigned tracking:1;
		unsigned acceptsFirstMouse:1;
		unsigned disabled:1;
		unsigned selected:1;
		unsigned highlighted:1;
		unsigned hover:1;
	} _controlFlags;
}

@property (nonatomic, strong) NSMutableArray *targetActions;

@end

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
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		_controlFlags.disabled = !e;
	}];
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
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		_controlFlags.selected = selected;
	}];
}

- (BOOL)isHighlighted {
	return _controlFlags.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted {
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		_controlFlags.highlighted = highlighted;
	}];
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
	[self applyStateChangeAnimated:self.animateStateChange block:^{
		if(track && !_controlFlags.tracking)
			_controlFlags.tracking = 1;
		else if(!track)
			_controlFlags.tracking = 0;
	}];
	
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
		[self applyStateChangeAnimated:self.animateStateChange block:^{
			if(track)
				_controlFlags.tracking = 1;
			else if(!track)
				_controlFlags.tracking = 0;
		}];
		
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
		[self applyStateChangeAnimated:self.animateStateChange block:^{
			_controlFlags.tracking = 0;
		}];
	}
}

// Support tracking cancelation.
- (void)willMoveToSuperview:(TUIView *)newSuperview {
	if(!_controlFlags.disabled && _controlFlags.tracking) {
		[self applyStateChangeAnimated:self.animateStateChange block:^{
			_controlFlags.tracking = 0;
		}];

		[self endTrackingWithEvent:nil];
		[self setNeedsDisplay];
	}
}

- (void)willMoveToWindow:(TUINSWindow *)newWindow {
	if(!_controlFlags.disabled && _controlFlags.tracking) {
		[self applyStateChangeAnimated:self.animateStateChange block:^{
			_controlFlags.tracking = 0;
		}];

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

- (void)applyStateChangeAnimated:(BOOL)animated block:(void (^)(void))block {
	[self stateWillChange];
	block();
	[self stateDidChange];
	
	if(animated) {
		[TUIView animateWithDuration:0.25f animations:^{
			[self redraw];
		}];
	} else [self setNeedsDisplay];
}

// Override.
- (void)stateWillChange {
	return;
}

- (void)stateDidChange {
	return;
}

@end

@implementation TUIControl (TargetAction)

// add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
// passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
// the action cannot be NULL.
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(TUIControlEvents)controlEvents
{
	if(action) {
		TUIControlTargetAction *t = [[TUIControlTargetAction alloc] init];
		t.target = target;
		t.action = action;
		t.controlEvents = controlEvents;
		[self.targetActions addObject:t];
	}
}

- (void)addActionForControlEvents:(TUIControlEvents)controlEvents block:(void(^)(void))block
{
	if(block) {
		TUIControlTargetAction *t = [[TUIControlTargetAction alloc] init];
		t.block = block;
		t.controlEvents = controlEvents;
		[self.targetActions addObject:t];
	}
}

// remove the target/action for a set of events. pass in NULL for the action to remove all actions for that target
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(TUIControlEvents)controlEvents
{
	NSMutableArray *targetActionsToRemove = [NSMutableArray array];
	
	for(TUIControlTargetAction *t in self.targetActions) {
		
		BOOL actionMatches = action == t.action;
		BOOL targetMatches = [target isEqual:t.target];
		BOOL controlMatches = controlEvents == t.controlEvents; // is this the way UIKit does it? Should I just remove certain bits from t.controlEvents?
		
		if((action && targetMatches && actionMatches && controlMatches) ||
		   (!action && targetMatches && controlMatches))
			{
			[targetActionsToRemove addObject:t];
			}
	}
	
	[self.targetActions removeObjectsInArray:targetActionsToRemove];
}

- (NSSet *)allTargets                                                                     // set may include NSNull to indicate at least one nil target
{
	NSMutableSet *targets = [NSMutableSet set];
	for(TUIControlTargetAction *t in self.targetActions) {
		id target = t.target;
		[targets addObject:target?target:[NSNull null]];
	}
	return targets;
}

- (TUIControlEvents)allControlEvents                                                       // list of all events that have at least one action
{
	TUIControlEvents e = 0;
	for(TUIControlTargetAction *t in self.targetActions) {
		e |= t.controlEvents;
	}
	return e;
}

- (NSArray *)actionsForTarget:(id)target forControlEvent:(TUIControlEvents)controlEvent    // single event. returns NSArray of NSString selector names. returns nil if none
{
	NSMutableArray *actions = [NSMutableArray array];
	for(TUIControlTargetAction *t in self.targetActions) {
		if([target isEqual:t.target] && controlEvent == t.controlEvents) {
			[actions addObject:NSStringFromSelector(t.action)];
		}
	}
	
	if([actions count])
		return actions;
	return nil;
}

// send the action. the first method is called for the event and is a point at which you can observe or override behavior. it is called repeately by the second.
- (void)sendAction:(SEL)action to:(id)target forEvent:(NSEvent *)event
{
	[NSApp sendAction:action to:target from:self];
}

- (void)sendActionsForControlEvents:(TUIControlEvents)controlEvents                        // send all actions associated with events
{
	for(TUIControlTargetAction *t in self.targetActions) {
		if(t.controlEvents == controlEvents) {
			if(t.target && t.action) {
				[self sendAction:t.action to:t.target forEvent:nil];
			} else if(t.block) {
				t.block();
			}
		}
	}
}

@end
