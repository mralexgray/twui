/*

 */

#import "TUIImageView.h"

@implementation TUIImageView
@synthesize image = _image;

- (void)setImage:(NSImage *)i
{
	_image = i;
	[self setNeedsDisplay];
}

- (id)initWithImage:(NSImage *)image
{
	CGRect frame = CGRectZero;
	if (image) frame = CGRectMake(0, 0, image.size.width, image.size.height);

	self = [super initWithFrame:frame];
	if (self == nil) return nil;

	self.userInteractionEnabled = NO;
	_image = image;

	return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	if (_image == nil)
		return;
    
    [_image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (CGSize)sizeThatFits:(CGSize)size {
	return _image.size;
}

@end
