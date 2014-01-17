
#import <Cocoa/Cocoa.h>
#import "TUIGeometry.h"

@class TUIStretchableImage;

@interface NSImage (TUIExtensions)

+ (NSImage *)tui_imageWithCGImage:(CGImageRef)cgImage;
+ (NSImage *)tui_imageWithSize:(CGSize)size drawing:(void (^)(CGContextRef))draw; // thread safe

/*
 * Returns a CGImageRef corresponding to the receiver.
 *
 * This should only be used with bitmaps. For vector images, use
 * -CGImageForProposedRect:context:hints instead.
 */
@property (nonatomic, readonly) CGImageRef tui_CGImage;

/*
 * Similar to -CGImageForProposedRect:context:hints:, but accepts a CGContextRef
 * instead.
 */
- (CGImageRef)tui_CGImageForProposedRect:(CGRect *)rectPtr CGContext:(CGContextRef)context;

/*
 * Draws the whole image originating at the given point.
 */
- (void)tui_drawAtPoint:(CGPoint)point;

/*
 * Draws the whole image into the given rectangle.
 */
- (void)tui_drawInRect:(CGRect)rect;

/*
 * Creates and returns a new image, based on the receiver, that has the
 * specified end cap insets.
 */
- (TUIStretchableImage *)tui_resizableImageWithCapInsets:(TUIEdgeInsets)insets;

- (NSImage *)tui_crop:(CGRect)cropRect;
- (NSImage *)tui_upsideDownCrop:(CGRect)cropRect;
- (NSImage *)tui_scale:(CGSize)size;
- (NSImage *)tui_thumbnail:(CGSize)size;
- (NSImage *)tui_pad:(CGFloat)padding; // can be negative (to crop to center)
- (NSImage *)tui_roundImage:(CGFloat)radius;
- (NSImage *)tui_invertedMask;
- (NSImage *)tui_embossMaskWithOffset:(CGSize)offset; // subtract reciever from itself offset by 'offset', use as a mask to draw emboss
- (NSImage *)tui_innerShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(NSColor *)color backgroundColor:(NSColor *)backgroundColor; // 'backgroundColor' is used as the color the shadow is drawn with, it is mostly masked out, but a halo will remain, leading to artifacts unless it is close enough to the background color

@end
