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

#import "TUIView.h"

enum {
	TUIControlEventMouseDown			= 1 <<  0,
	TUIControlEventMouseDownRepeat		= 1 <<  1,
	TUIControlEventMouseDragInside		= 1 <<  2,
	TUIControlEventMouseDragOutside		= 1 <<  3,
	/*
	 Needs:
	 TUIControlEventMouseDragEnter		= 1 <<  4,
	 TUIControlEventMouseDragExit		= 1 <<  5,
	 */
	TUIControlEventMouseUpInside		= 1 <<  6,
	TUIControlEventMouseUpOutside		= 1 <<  7,
	TUIControlEventMouseCancel			= 1 <<  8,
	
	TUIControlEventMouseHoverBegan		= 1 <<  9,
	TUIControlEventMouseHoverEnded		= 1 <<  9,
	TUIControlEventValueChanged			= 1 << 12,
	
	/*
	 Needs:
	TUIControlEventEditingDidBegin		= 1 << 16,
	TUIControlEventEditingChanged		= 1 << 17,
	TUIControlEventEditingDidEnd		= 1 << 18,
	 */
	TUIControlEventEditingDidEndOnExit	= 1 << 19,
	
	TUIControlEventAllMouseEvents		= 0x00000FFF,
	TUIControlEventAllEditingEvents		= 0x000F0000,
	TUIControlEventApplicationReserved	= 0x0F000000,
	TUIControlEventSystemReserved		= 0xF0000000,
	TUIControlEventAllEvents			= 0xFFFFFFFF
};
typedef NSUInteger TUIControlEvents;

enum {
	TUIControlStateNormal			= 0,					   
	TUIControlStateHighlighted		= 1 << 0,
	TUIControlStateDisabled			= 1 << 1,
	TUIControlStateSelected			= 1 << 2,
	TUIControlStateHover			= 1 << 3,
	TUIControlStateNotKey			= 1 << 11,
	TUIControlStateApplication		= 0x00FF0000,
	TUIControlStateReserved			= 0xFF000000
};
typedef NSUInteger TUIControlState;

@interface TUIControl : TUIView

@property (nonatomic, readonly) TUIControlState state;
@property (nonatomic, assign) BOOL acceptsFirstMouse;
@property (nonatomic, assign) BOOL animateStateChange;

@property (nonatomic, readonly, getter = isTracking) BOOL tracking;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, assign, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, assign, getter = isContinuous) BOOL continuous;

// These methods should be used to react to a state change.
// The default method implementation does nothing, but if you
// are subclassing a subclass of TUIControl, such as TUIButton,
// you must call the superclass implementation of the method.
- (void)stateWillChange;
- (void)stateDidChange;

// As your custom control changes a state property, it is
// recommended the control assign the state using this method.
// This automatically invokes -stateWillChange and -stateDidChange,
// and calls -setNeedsDisplay or animates -redraw if required.
- (void)applyStateChangeAnimated:(BOOL)animated block:(void (^)(void))block;

// When control tracking begins, usually by mouse down or
// swipe start, this method is called to validate the event.
// If YES is returned, tracking will continue, otherwise
// if NO is returned, tracking ends there itself.
- (BOOL)beginTrackingWithEvent:(NSEvent *)event;

// If the control opts to continue tracking, then this method
// will be continuously called to validate each event in the
// chain of tracking events, and should be used to update the
// control view to reflect tracking changes. If YES is returned,
// the control continues to receive tracking events. If NO
// is returned, tracking ends there itself.
- (BOOL)continueTrackingWithEvent:(NSEvent *)event;

// When control tracking ends, this method is called to allow
// the control to clean up. It is NOT called when the control
// opts to cancel it - only when the user cancels the tracking.
- (void)endTrackingWithEvent:(NSEvent *)event;

// Add target/action for particular event. You can call this
// multiple times and you can specify multiple target/actions
// for a particular event. Passing in nil as the target goes
// up the responder chain. The action may optionally include
// the sender and the event as parameters, in that order. The
// action cannot be NULL. You may also choose to submit a block
// as an action for a control event mask. You may add any
// number of blocks as well.
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(TUIControlEvents)controlEvents;
- (void)addActionForControlEvents:(TUIControlEvents)controlEvents block:(void(^)(void))action;

// Remove the target and action for a set of events. Pass NULL
// for the action to remove all actions for that target. You
// may not, however, remove a block target, due to its unidentifiablity.
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(TUIControlEvents)controlEvents;

// Get all targets, actions, and control events registered.
// May include NSNull to indicate at least one nil target.
// -actionsForTarget... returns NSArray of NSString selector
// names or nil if none.
- (NSSet *)allTargets;
- (TUIControlEvents)allControlEvents;
- (NSArray *)actionsForTarget:(id)target forControlEvent:(TUIControlEvents)controlEvent;

// As a TUIControl subclass, these methods enable you to dispatch
// actions when an event occurs. The first -sendAction:to:forEvent:
// method call is for the event and is a point at which you can
// observe or override behavior. It is then called repeately after
// the second call to this method.
- (void)sendAction:(SEL)action to:(id)target forEvent:(NSEvent *)event;
- (void)sendActionsForControlEvents:(TUIControlEvents)controlEvents;

@end
