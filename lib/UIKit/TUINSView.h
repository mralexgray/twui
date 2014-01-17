
#import <Cocoa/Cocoa.h>
#import "TUIHostView.h"
#import "TUIView+TUIBridgedView.h"

@class TUITextRenderer;

/**
 TUINSView is the bridge that hosts a TUIView-based interface heirarchy. You may add it as the contentView of your window if you want to build a pure TwUI-based UI, or you can use it for a small part.
 */
@interface TUINSView : NSView <TUIHostView>
{
	TUIView *_hoverView;

	__unsafe_unretained TUIView *_hyperFocusView; // hyperfocus view, weak

	TUIView *_hyperFadeView;
	void(^_hyperCompletion)(BOOL);
	
	NSTrackingArea *_trackingArea;
	
	__unsafe_unretained TUITextRenderer *_tempTextRendererForTextInputClient; // weak, set temporarily while NSTextInputClient dicks around
	
	BOOL deliveringEvent;
	BOOL inLiveResize;
	
	BOOL opaque;
}

/**
 Set this as the root TUIView-based view.
 */
@property (nonatomic, strong) TUIView *rootView;

- (TUIView *)viewForLocationInWindow:(NSPoint)locationInWindow;
- (TUIView *)viewForEvent:(NSEvent *)event; // ignores views with 'userInteractionEnabled=NO'

- (void)setEverythingNeedsDisplay;
- (void)invalidateHoverForView:(TUIView *)v;

- (NSMenu *)menuWithPatchedItems:(NSMenu *)menu; // don't use this

- (BOOL)isTrackingSubviewOfView:(TUIView *)v;
- (BOOL)isHoveringSubviewOfView:(TUIView *)v; // v or subview of v
- (BOOL)isHoveringView:(TUIView *)v; // only v

- (void)tui_setOpaque:(BOOL)o;

- (BOOL)isWindowKey;

@end
