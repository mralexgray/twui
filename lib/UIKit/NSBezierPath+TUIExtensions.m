/*
 Copyright 2011 Twitter, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this work except in compliance with the License.
 You may obtain a copy of the License in the LICENSE file, or at:
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "NSBezierPath+TUIExtensions.h"
#import "TUIAttributedString.h"

// Sourced from Apple Documentation.
static void CGPathCallback(void *info, const CGPathElement *element) {
	NSBezierPath *path = (__bridge NSBezierPath *)(info);
	CGPoint *points = element->points;
	
	switch (element->type) {
		case kCGPathElementMoveToPoint: {
			[path moveToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		}
		
		case kCGPathElementAddLineToPoint: {
			[path lineToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		}
			
		case kCGPathElementAddQuadCurveToPoint: {
			NSPoint currentPoint = [path currentPoint];
			NSPoint interpolatedPoint = NSMakePoint((currentPoint.x + 2*points[0].x) / 3,
													(currentPoint.y + 2*points[0].y) / 3);
			[path curveToPoint:NSMakePoint(points[1].x, points[1].y)
				 controlPoint1:interpolatedPoint controlPoint2:interpolatedPoint];
			break;
		}
		
		case kCGPathElementAddCurveToPoint: {
			[path curveToPoint:NSMakePoint(points[2].x, points[2].y)
				 controlPoint1:NSMakePoint(points[0].x, points[0].y)
				 controlPoint2:NSMakePoint(points[1].x, points[1].y)];
			break;
		}
			
		case kCGPathElementCloseSubpath: {
			[path closePath];
			break;
		}
	}
}

@implementation NSBezierPath (TUIExtensions)

// Sourced from Apple Documentation.
+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef {
	NSBezierPath *path = [NSBezierPath bezierPath];
	CGPathApply(pathRef, (__bridge void *)(path), CGPathCallback);
	
	return path;
}

// Sourced from Google Cocoa Additions.
- (CGPathRef)CGPath {
	CGMutablePathRef thePath = CGPathCreateMutable();
	if(!thePath)
		return nil;
	
	NSUInteger elementCount = self.elementCount;
	NSPoint controlPoints[3];
	
	for(NSUInteger i = 0; i < elementCount; i++) {
		switch ([self elementAtIndex:i associatedPoints:controlPoints]) {
			case NSMoveToBezierPathElement:
				CGPathMoveToPoint(thePath, &CGAffineTransformIdentity,
								  controlPoints[0].x, controlPoints[0].y);
				break;
			case NSLineToBezierPathElement:
				CGPathAddLineToPoint(thePath, &CGAffineTransformIdentity,
									 controlPoints[0].x, controlPoints[0].y);
				break;
			case NSCurveToBezierPathElement:
				CGPathAddCurveToPoint(thePath, &CGAffineTransformIdentity,
									  controlPoints[0].x, controlPoints[0].y,
									  controlPoints[1].x, controlPoints[1].y,
									  controlPoints[2].x, controlPoints[2].y);
				break;
			case NSClosePathBezierPathElement:
				CGPathCloseSubpath(thePath);
				break;
			default:
				NSLog(@"Unknown element at [NSBezierPath CGPath]");
				break;
		};
	}
	
	return thePath;
}

- (void)fillWithInnerShadow:(NSShadow *)shadow {
	NSSize offset = shadow.shadowOffset;
	NSSize originalOffset = offset;
	CGFloat radius = shadow.shadowBlurRadius;
	NSRect bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + radius), -(ABS(offset.height) + radius));
	offset.height += bounds.size.height;
	shadow.shadowOffset = offset;
	
	NSAffineTransform *transform = [NSAffineTransform transform];
	if ([[NSGraphicsContext currentContext] isFlipped])
		[transform translateXBy:0 yBy:bounds.size.height];
	else
		[transform translateXBy:0 yBy:-bounds.size.height];
	
	NSBezierPath *drawingPath = [NSBezierPath bezierPathWithRect:bounds];
	[drawingPath setWindingRule:NSEvenOddWindingRule];
	[drawingPath appendBezierPath:self];
	[drawingPath transformUsingAffineTransform:transform];
	
	[NSGraphicsContext saveGraphicsState]; {
		[self addClip];
		[shadow set];
		
		[[NSColor blackColor] set];
		[drawingPath fill];
	} [NSGraphicsContext restoreGraphicsState];
	
	shadow.shadowOffset = originalOffset;
}

- (void)drawBlurWithColor:(NSColor *)color radius:(CGFloat)radius {
	NSRect bounds = NSInsetRect(self.bounds, -radius, -radius);
	NSShadow *shadow = [NSShadow shadowWithRadius:radius offset:NSMakeSize(0, bounds.size.height) color:color];
	
	NSBezierPath *path = [self copy];
	NSAffineTransform *transform = [NSAffineTransform transform];
	if([[NSGraphicsContext currentContext] isFlipped])
		[transform translateXBy:0 yBy:bounds.size.height];
	else
		[transform translateXBy:0 yBy:-bounds.size.height];
	[path transformUsingAffineTransform:transform];
	
	[NSGraphicsContext saveGraphicsState]; {
		[shadow set];
		[[NSColor blackColor] set];
		
		NSRectClip(bounds);
		[path fill];
	} [NSGraphicsContext restoreGraphicsState];
}

// Sourced from Matt Gemmell. Link provided below:
// http://mattgemmell.com/source/
- (void)strokeInside {
    [self strokeInsideWithinRect:NSZeroRect];
}

- (void)strokeInsideWithinRect:(NSRect)clipRect {
    CGFloat lineWidth = self.lineWidth;
    
    [[NSGraphicsContext currentContext] saveGraphicsState]; {
		self.lineWidth = lineWidth * 2.0f;
		
		[self setClip];
		if(clipRect.size.width > 0.0 && clipRect.size.height > 0.0)
			[NSBezierPath clipRect:clipRect];
		
		[self stroke];

	} [[NSGraphicsContext currentContext] restoreGraphicsState];
	
	self.lineWidth = lineWidth;
}

@end
