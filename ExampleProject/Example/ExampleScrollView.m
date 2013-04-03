/*

 */

#import "ExampleScrollView.h"

@implementation ExampleScrollView

- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame])) {
		self.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
		
		_scrollView = [[TUIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.autoresizingMask = TUIViewAutoresizingFlexibleSize;
		_scrollView.scrollIndicatorStyle = TUIScrollViewIndicatorStyleDefault;
		[self addSubview:_scrollView];
		
		TUIImageView *imageView = [[TUIImageView alloc] initWithImage:[NSImage imageNamed:@"large-image.jpeg"]];
		[_scrollView addSubview:imageView];
		[_scrollView setContentSize:imageView.frame.size];
		
	}
	return self;
}


@end