/*

 */

@interface TUIView (Event)

// Allows a TUIView to recieve touchesBegan/Moved/Ended/Cancelled events.
// Defaults to NO.
@property (nonatomic, assign) BOOL acceptsTouchEvents;

// Allows a TUIView that can receive touch events to receive resting touches.
// Defaults to NO.
@property (nonatomic, assign) BOOL wantsRestingTouches;

// Returns the set of touches for this TUIView provided by the NSEvent.
// Note that you should not use -[NSEvent touchesMatchingPhase:inView:]
- (NSSet *)touchesMatchingPhase:(NSTouchPhase)phase forEvent:(NSEvent *)event;

- (BOOL)didDrag; // valid when called from mouseUp: will determine if a drag happened in this event sequence

- (void)viewWillStartLiveResize; // call super to propogate to subviews
- (void)viewDidEndLiveResize;

/* Observing events in subviews
 * 
 * The subview parameter is the view which recieved the event, not the
 * immediate subview of the view recieving the message. To determine if
 * the event belongs to a subview of a particular immediate subview, use
 * -isDescendantOfView:.
 */
- (void)mouseDown:(NSEvent *)event onSubview:(TUIView *)subview;
- (void)mouseDragged:(NSEvent *)event onSubview:(TUIView *)subview;
- (void)mouseUp:(NSEvent *)event fromSubview:(TUIView *)subview;
- (void)rightMouseDown:(NSEvent *)event onSubview:(TUIView *)subview;
- (void)rightMouseUp:(NSEvent *)event fromSubview:(TUIView *)subview;
- (void)mouseEntered:(NSEvent *)event onSubview:(TUIView *)subview;
- (void)mouseExited:(NSEvent *)event fromSubview:(TUIView *)subview;

@end
