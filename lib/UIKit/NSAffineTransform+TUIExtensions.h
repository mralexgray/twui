/*

 */

#import <Foundation/Foundation.h>

@interface NSAffineTransform (TUIExtensions)

// Creates an NSAffineTransform object with the passed CGAffineTransform.
+ (NSAffineTransform *)tui_transformWithCGAffineTransform:(CGAffineTransform)transform;

// Creates an CGAffineTransform struct with the transform of the reciever.
- (CGAffineTransform)tui_CGAffineTransform;

@end
