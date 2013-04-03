/*

 */

#import "TUIView+PasteboardDragging.h"
#import "TUICGAdditions.h"
#import "TUINSView.h"

@implementation TUIView (PasteboardDragging)

- (BOOL)pasteboardDraggingEnabled
{
	return _viewFlags.pasteboardDraggingEnabled;
}

- (void)setPasteboardDraggingEnabled:(BOOL)e
{
	_viewFlags.pasteboardDraggingEnabled = e;
}

- (void)startPasteboardDragging
{
	// implemented by subclasses
}

- (void)endPasteboardDragging:(NSDragOperation)operation
{
	// implemented by subclasses
}

- (id<NSPasteboardWriting>)representedPasteboardObject
{
	return nil;
}

- (TUIView *)handleForPasteboardDragView
{
	return self;
}

- (void)pasteboardDragMouseDown:(NSEvent *)event
{
	_viewFlags.pasteboardDraggingIsDragging = NO;
}

- (void)pasteboardDragMouseDragged:(NSEvent *)event
{
	if(!_viewFlags.pasteboardDraggingIsDragging) {
		_viewFlags.pasteboardDraggingIsDragging = YES;
		
		TUIView *dragView = [self handleForPasteboardDragView];
		id<NSPasteboardWriting> pasteboardObject = [dragView representedPasteboardObject];
		
		NSImage *dragNSImage = TUIGraphicsDrawAsImage(dragView.frame.size, ^{
			[TUIGraphicsGetImageForView(dragView) drawAtPoint:CGPointZero fromRect:CGRectZero operation:NSCompositeSourceOver fraction:0.75];
		});
		
		NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
		[pasteboard clearContents];
		[pasteboard writeObjects:[NSArray arrayWithObject:pasteboardObject]];
		
		[self.nsView dragImage:dragNSImage 
							at:[dragView frameInNSView].origin
						offset:NSZeroSize 
						 event:event 
					pasteboard:pasteboard 
						source:self 
					 slideBack:YES];
	}
}

- (void)draggedImage:(NSImage *)anImage beganAt:(NSPoint)aPoint
{
	[[self handleForPasteboardDragView] startPasteboardDragging];
}

- (void)draggedImage:(NSImage *)image movedTo:(NSPoint)screenPoint
{
}

- (void)draggedImage:(NSImage *)anImage endedAt:(NSPoint)aPoint operation:(NSDragOperation)operation
{
	[self.nsView mouseUp:nil]; // will clear _trackingView
	[[self handleForPasteboardDragView] endPasteboardDragging:operation];
}

@end
