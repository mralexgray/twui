
#import "TUINSView.h"
#import "TUICGAdditions.h"
#import "TUINSView+Hyperfocus.h"

@implementation TUINSView (Hyperfocus)

- (void)endHyperFocus:(BOOL)cancel
{
	if(_hyperFocusView) {
		_hyperCompletion(cancel);
		_hyperCompletion = nil;
		
		TUIView *remove = _hyperFadeView;
		[TUIView animateWithDuration:0.3 animations:^{
			remove.alpha = 0.0;
		} completion:^(BOOL finished) {
			[remove removeFromSuperview];
		}];
		
		_hyperFadeView = nil;
		_hyperFocusView = nil;
	}
}

- (void)hyperFocus:(TUIView *)focusView completion:(void(^)(BOOL))completion
{
	[self endHyperFocus:YES];
	
	CGRect focusRect = [focusView frameInNSView];
	CGFloat startRadius = 1.0;
	CGFloat endRadius = MAX(self.rootView.bounds.size.width, self.rootView.bounds.size.height);
	CGPoint center = CGPointMake(focusRect.origin.x + focusRect.size.width * 0.5, focusRect.origin.y + focusRect.size.height * 0.5);
	
	TUIView *fade = [[TUIView alloc] initWithFrame:self.rootView.bounds];
	fade.userInteractionEnabled = NO;
	fade.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	fade.opaque = NO;
	fade.drawRect = ^(TUIView *v, CGRect r) {
		CGContextRef ctx = TUIGraphicsGetCurrentContext();
		
		CGFloat locations[] = {0.0, 0.25, 1.0};
		CGFloat components[] = {
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.15,
			0.0, 0.0, 0.0, 0.55,
		};
		
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 3);
		
//		CGContextSaveGState(ctx);
//		CGContextClipToRoundRect(ctx, self.rootView.bounds, 9);
		CGContextDrawRadialGradient(ctx, gradient, center, startRadius, center, endRadius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
//		CGContextRestoreGState(ctx);
		
		CGGradientRelease(gradient);
		CGColorSpaceRelease(space);
	};
	
	[CATransaction begin];
	fade.alpha = 0.0;
	[self.rootView addSubview:fade];
	[CATransaction flush];
	[CATransaction commit];
	
	
	[TUIView animateWithDuration:0.2 animations:^{
		fade.alpha = 1.0;
	}];
	
	_hyperFocusView = focusView;
	_hyperFadeView = fade;
	_hyperCompletion = [completion copy];
}

@end
