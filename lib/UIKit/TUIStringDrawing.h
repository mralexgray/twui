
#import <Foundation/Foundation.h>
#import "TUIAttributedString.h"

@class NSFont;

@interface NSAttributedString (TUIStringDrawing)

- (CGSize)ab_size;
- (CGSize)ab_sizeConstrainedToSize:(CGSize)size;
- (CGSize)ab_sizeConstrainedToWidth:(CGFloat)width;

- (CGSize)ab_drawInRect:(CGRect)rect;
- (CGSize)ab_drawInRect:(CGRect)rect context:(CGContextRef)ctx;

@end

@interface NSString (TUIStringDrawing)

- (CGSize)ab_sizeWithFont:(NSFont *)font;
- (CGSize)ab_sizeWithFont:(NSFont *)font constrainedToSize:(CGSize)size;

#if TARGET_OS_MAC
// for ABRowView
//- (CGSize)drawInRect:(CGRect)rect withFont:(NSFont *)font lineBreakMode:(TUILineBreakMode)lineBreakMode alignment:(TUITextAlignment)alignment;
#endif

- (CGSize)ab_drawInRect:(CGRect)rect color:(NSColor *)color font:(NSFont *)font;
- (CGSize)ab_drawInRect:(CGRect)rect withFont:(NSFont *)font lineBreakMode:(TUILineBreakMode)lineBreakMode alignment:(TUITextAlignment)alignment;

@end
