
#import "TUIStretchableImage.h"

@implementation TUIStretchableImage

#pragma mark Properties

@synthesize capInsets = _capInsets;

#pragma mark Drawing

- (void)drawInRect:(NSRect)dstRect fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)alpha {
	[self drawInRect:dstRect fromRect:srcRect operation:op fraction:alpha respectFlipped:YES hints:nil];
}

- (void)drawInRect:(NSRect)dstRect fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)alpha respectFlipped:(BOOL)respectFlipped hints:(NSDictionary *)hints {
	CGImageRef image = [self CGImageForProposedRect:&dstRect context:[NSGraphicsContext currentContext] hints:hints];
	if (image == NULL) {
		NSLog(@"*** Could not get CGImage of %@", self);
		return;
	}

	CGSize size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	TUIEdgeInsets insets = self.capInsets;

    BOOL retina =   roundf(size.width)  == roundf(self.size.width   * 2) &&
                    roundf(size.height) == roundf(self.size.height  * 2);
    if (retina) {
        insets.top      *= 2.0;
        insets.left     *= 2.0;
        insets.bottom   *= 2.0;
        insets.right    *= 2.0;
    }

	// TODO: Cache the nine-part images for this common case of wanting to draw
	// the whole source image.
	if (CGRectIsEmpty(srcRect)) {
		// Match the image creation that occurs in the 'else' clause.
		CGImageRetain(image);
	} else {
		image = CGImageCreateWithImageInRect(image, srcRect);
		if (!image) return;

		// Reduce insets to account for taking only part of the original image.
		insets.left = fmax(0, insets.left - CGRectGetMinX(srcRect));
		insets.top = fmax(0, insets.top - CGRectGetMinY(srcRect));

		CGFloat srcRightInset = size.width - CGRectGetMaxX(srcRect);
		insets.right = fmax(0, insets.right - srcRightInset);

		CGFloat srcTopInset = size.height - CGRectGetMaxY(srcRect);
		insets.bottom = fmax(0, insets.bottom - srcTopInset);
	}

	NSImage *topLeft = nil, *topEdge = nil, *topRight = nil;
	NSImage *leftEdge = nil, *center = nil, *rightEdge = nil;
	NSImage *bottomLeft = nil, *bottomEdge = nil, *bottomRight = nil;

	// Length of sides that run vertically.
	CGFloat verticalEdgeLength = fmax(0, size.height - insets.bottom - insets.top);

	// Length of sides that run horizontally.
	CGFloat horizontalEdgeLength = fmax(0, size.width - insets.left - insets.right);

	NSImage *(^imageWithRect)(CGRect) = ^ id (CGRect rect){
		CGImageRef part = CGImageCreateWithImageInRect(image, rect);
		if (part == NULL) return nil;

        if (retina) {
            rect.size.width     /= 2.0;
            rect.size.height    /= 2.0;
        }

		NSImage *image = [[NSImage alloc] initWithCGImage:part size:rect.size];
		CGImageRelease(part);

		return image;
	};

	if (verticalEdgeLength > 0) {
		if (insets.left > 0) {
			CGRect partRect = CGRectMake(0, insets.top, insets.left, verticalEdgeLength);
			leftEdge = imageWithRect(partRect);
		}

		if (insets.right > 0) {
			CGRect partRect = CGRectMake(size.width - insets.right, insets.top, insets.right, verticalEdgeLength);
			rightEdge = imageWithRect(partRect);
		}
	}

	if (horizontalEdgeLength > 0) {
		if (insets.top > 0) {
			CGRect partRect = CGRectMake(insets.left, 0, horizontalEdgeLength, insets.top);
			topEdge = imageWithRect(partRect);
		}

		if (insets.bottom > 0) {
			CGRect partRect = CGRectMake(insets.left, size.height - insets.bottom, horizontalEdgeLength, insets.bottom);
			bottomEdge = imageWithRect(partRect);
		}
	}

	if (insets.left > 0 && insets.bottom > 0) {
		CGRect partRect = CGRectMake(0, size.height - insets.bottom, insets.left, insets.bottom);
		bottomLeft = imageWithRect(partRect);
	}

	if (insets.left > 0 && insets.top > 0) {
		CGRect partRect = CGRectMake(0, 0, insets.left, insets.top);
		topLeft = imageWithRect(partRect);
	}

	if (insets.right > 0 && insets.bottom > 0) {
		CGRect partRect = CGRectMake(size.width - insets.right, size.height - insets.bottom, insets.right, insets.bottom);
		bottomRight = imageWithRect(partRect);
	}

	if (insets.right > 0 && insets.top > 0) {
		CGRect partRect = CGRectMake(size.width - insets.right, 0, insets.right, insets.top);
		topRight = imageWithRect(partRect);
	}

	CGRect centerRect = TUIEdgeInsetsInsetRect(CGRectMake(0, 0, size.width, size.height), insets);
	if (centerRect.size.width > 0 && centerRect.size.height > 0) {
		center = imageWithRect(centerRect);
	}

	CGImageRelease(image);

	BOOL flipped = NO;
	if (respectFlipped) {
		flipped = [[NSGraphicsContext currentContext] isFlipped];
	}

	if (bottomLeft != nil || topRight != nil) {
		NSDrawNinePartImage(dstRect, topLeft, topEdge, topRight, leftEdge, center, rightEdge, bottomLeft, bottomEdge, bottomRight, op, alpha, flipped);
	} else if (leftEdge != nil) {
		// Horizontal three-part image.
		NSDrawThreePartImage(dstRect, leftEdge, center, rightEdge, NO, op, alpha, flipped);
	} else {
		// Vertical three-part image.
		NSDrawThreePartImage(dstRect, topEdge, center, bottomEdge, YES, op, alpha, flipped);
	}
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	TUIStretchableImage *image = [super copyWithZone:zone];
	image.capInsets = self.capInsets;
	return image;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self == nil) return nil;

	self.capInsets = TUIEdgeInsetsMake(
		[coder decodeFloatForKey:@"capInsetTop"],
		[coder decodeFloatForKey:@"capInsetLeft"],
		[coder decodeFloatForKey:@"capInsetBottom"],
		[coder decodeFloatForKey:@"capInsetRight"]
	);

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];

	[coder encodeFloat:self.capInsets.top forKey:@"capInsetTop"];
	[coder encodeFloat:self.capInsets.left forKey:@"capInsetLeft"];
	[coder encodeFloat:self.capInsets.bottom forKey:@"capInsetBottom"];
	[coder encodeFloat:self.capInsets.right forKey:@"capInsetRight"];
}

@end
