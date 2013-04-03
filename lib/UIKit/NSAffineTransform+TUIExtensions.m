/*

 */

#import "NSAffineTransform+TUIExtensions.h"

@implementation NSAffineTransform (TUIExtensions)

+ (NSAffineTransform *)tui_transformWithCGAffineTransform:(CGAffineTransform)transform {
	NSAffineTransform *affineTransform = [NSAffineTransform transform];
	affineTransform.transformStruct = (NSAffineTransformStruct) {
		.m11 = transform.a,
		.m12 = transform.b,
		.m21 = transform.c,
		.m22 = transform.d,
		.tX = transform.tx,
		.tY = transform.ty
	};
	
	return affineTransform;
}

- (CGAffineTransform)tui_CGAffineTransform {
	NSAffineTransformStruct transform = self.transformStruct;
	
	return (CGAffineTransform) {
		.a = transform.m11,
		.b = transform.m12,
		.c = transform.m21,
		.d = transform.m22,
		.tx = transform.tX,
		.ty = transform.tY
	};
}

@end


