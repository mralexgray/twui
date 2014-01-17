
#import <Cocoa/Cocoa.h>

@interface NSShadow (TUIExtensions)

// Returns a shadow with the given shadow radius, offset, and color properties.
+ (NSShadow *)tui_shadowWithRadius:(CGFloat)radius offset:(CGSize)offset color:(NSColor *)color;

@end
