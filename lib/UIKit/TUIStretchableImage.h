/*

 */

#import <Cocoa/Cocoa.h>
#import "TUIGeometry.h"

/*
 * An image that supports resizing based on end caps.
 */
@interface TUIStretchableImage : NSImage <NSCoding, NSCopying>

/*
 * The end cap insets for the image.
 *
 * Any portion of the image not covered by end caps will be tiled when the image
 * is drawn.
 */
@property (nonatomic, assign) TUIEdgeInsets capInsets;

@end
