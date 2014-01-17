
#import "TUIAttributedString.h"
#import "TUICGAdditions.h"
#import "TUIStringDrawing.h"
#import "TUITextRenderer.h"

@implementation NSAttributedString (TUIStringDrawing)

- (TUITextRenderer *)ab_sharedTextRenderer
{
	static TUITextRenderer *t = nil;
	if(!t)
		t = [[TUITextRenderer alloc] init];
	return t;
}

- (CGSize)ab_sizeConstrainedToWidth:(CGFloat)width
{
	return [self ab_sizeConstrainedToSize:CGSizeMake(width, 2000)]; // big enough
}

- (CGSize)ab_sizeConstrainedToSize:(CGSize)size
{
	TUITextRenderer *t = [self ab_sharedTextRenderer];
	t.attributedString = self;
	t.frame = CGRectMake(0, 0, size.width, size.height);
	return [t size];
}

- (CGSize)ab_size
{
	return [self ab_sizeConstrainedToSize:CGSizeMake(2000, 2000)]; // big enough
}

- (CGSize)ab_drawInRect:(CGRect)rect context:(CGContextRef)ctx
{
	TUITextRenderer *t = [self ab_sharedTextRenderer];
	t.attributedString = self;
	t.frame = rect;
	[t drawInContext:ctx];
	return [t size];
}

- (CGSize)ab_drawInRect:(CGRect)rect
{
	return [self ab_drawInRect:rect context:TUIGraphicsGetCurrentContext()];
}

@end

@implementation NSString (TUIStringDrawing)

#if TARGET_OS_MAC

- (CGSize)ab_sizeWithFont:(NSFont *)font
{
	TUIAttributedString *s = [TUIAttributedString stringWithString:self];
	s.font = font;
	return [s ab_size];
}

- (CGSize)ab_sizeWithFont:(NSFont *)font constrainedToSize:(CGSize)size
{
	TUIAttributedString *s = [TUIAttributedString stringWithString:self];
	s.font = font;
	return [s ab_sizeConstrainedToSize:size];
}


//- (CGSize)drawInRect:(CGRect)rect withFont:(NSFont *)font lineBreakMode:(TUILineBreakMode)lineBreakMode alignment:(TUITextAlignment)alignment
//{
//	return [self ab_drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
//}

#endif

- (CGSize)ab_drawInRect:(CGRect)rect color:(NSColor *)color font:(NSFont *)font
{
	TUIAttributedString *s = [TUIAttributedString stringWithString:self];
	s.color = color;
	s.font = font;
	return [s ab_drawInRect:rect];
}

- (CGSize)ab_drawInRect:(CGRect)rect withFont:(NSFont *)font lineBreakMode:(TUILineBreakMode)lineBreakMode alignment:(TUITextAlignment)alignment
{
	TUIAttributedString *s = [TUIAttributedString stringWithString:self];
	[s addAttribute:(NSString *)kCTForegroundColorFromContextAttributeName 
			  value:(id)[NSNumber numberWithBool:YES] 
			  range:NSMakeRange(0, [self length])];
	[s setAlignment:alignment lineBreakMode:lineBreakMode];
	s.font = font;
	return [s ab_drawInRect:rect];
}

@end
