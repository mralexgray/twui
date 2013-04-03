/*

 */

#import "TUIView.h"

@interface TUIView (PasteboardDragging)

@property (nonatomic, assign) BOOL pasteboardDraggingEnabled; // default NO

- (void)startPasteboardDragging;
- (void)endPasteboardDragging:(NSDragOperation)operation;

- (id<NSPasteboardWriting>)representedPasteboardObject;
- (TUIView *)handleForPasteboardDragView; // reciever can act as a "drag handle" for another view, returns self by default

- (void)pasteboardDragMouseDown:(NSEvent *)event;
- (void)pasteboardDragMouseDragged:(NSEvent *)event;

@end
