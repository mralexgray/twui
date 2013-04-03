/*

 */

#import "TUIView.h"

typedef void (^TUIMouseDraggedHandler)(NSEvent *dragEvent);

@class TUITextRenderer;

@interface TUIView ()

@property (nonatomic, retain) NSArray *textRenderers;
@property (nonatomic, copy) TUIMouseDraggedHandler dragHandler;

- (TUITextRenderer *)textRendererAtPoint:(CGPoint)point;
- (void)_updateLayerScaleFactor;

@end

extern CGFloat TUICurrentContextScaleFactor(void);
