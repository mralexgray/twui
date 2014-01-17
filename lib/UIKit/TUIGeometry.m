
#import "TUIGeometry.h"

const TUIEdgeInsets TUIEdgeInsetsZero = { .top = 0.0f, .left = 0.0f, .bottom = 0.0f, .right = 0.0f };

NSString* NSStringFromTUIEdgeInsets(TUIEdgeInsets insets) {
	return [NSString stringWithFormat:@"{%lg, %lg, %lg, %lg}", insets.top, insets.left, insets.bottom, insets.right];
}

TUIEdgeInsets TUIEdgeInsetsFromNSString(NSString *string) {
	TUIEdgeInsets result = TUIEdgeInsetsZero;
	
	if(string != nil) {
		double top, left, bottom, right;
		sscanf(string.UTF8String, "{%lg, %lg, %lg, %lg}", &top, &left, &bottom, &right);
		result = TUIEdgeInsetsMake(top, left, bottom, right);
	}
	
	return result;
}

CGRect TUIRectUnion(CGRect r1, CGRect r2) {
    CGRect r            = CGRectUnion(r1, r2);
    if (r.origin.y      == INFINITY) r.origin.y     = 0;
    if (r.origin.x      == INFINITY) r.origin.x     = 0;
    if (r.size.width    == INFINITY) r.size.width   = 0;
    if (r.size.height   == INFINITY) r.size.height  = 0;
    return r;
}


@implementation NSValue (TUIExtensions)

+ (NSValue *)tui_valueWithTUIEdgeInsets:(TUIEdgeInsets)insets {
	return [NSValue valueWithBytes:&insets objCType:@encode(TUIEdgeInsets)];
}

- (TUIEdgeInsets)tui_TUIEdgeInsetsValue {
	TUIEdgeInsets insets = TUIEdgeInsetsZero;
	[self getValue:&insets];
	return insets;
}

@end
