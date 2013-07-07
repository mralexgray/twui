
@interface TUIView (Event)

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
