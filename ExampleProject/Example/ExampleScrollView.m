
#import "ExampleScrollView.h"

@implementation ExampleScrollView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self) return nil;
	self.backgroundColor = NSColor.redColor;
	
	_scrollView = [TUIScrollView.alloc initWithFrame:self.bounds];
	_scrollView.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	_scrollView.scrollIndicatorStyle = TUIScrollViewIndicatorStyleDefault;
	[self addSubview:_scrollView];
	
	TUIImageView *imageView = [[TUIImageView alloc] initWithImage:[NSImage imageNamed:@"large-image.jpeg"]];
	[_scrollView addSubview:imageView];
	_scrollView.contentSize = imageView.frame.size;
	return self;
}


@end
