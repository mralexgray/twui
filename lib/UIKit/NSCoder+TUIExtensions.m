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

#import "NSCoder+TUIExtensions.h"

@implementation NSCoder (TUIExtensions)

- (void)encodeCGPoint:(CGPoint)point forKey:(NSString *)key {
    [self encodePoint:NSPointFromCGPoint(point) forKey:key];
}

- (CGPoint)decodeCGPointForKey:(NSString *)key {
    return NSPointToCGPoint([self decodePointForKey:key]);
}

- (void)encodeCGRect:(CGRect)rect forKey:(NSString *)key {
	[self encodeRect:NSRectFromCGRect(rect) forKey:key];
}

- (CGRect)decodeCGRectForKey:(NSString *)key {
	return NSRectToCGRect([self decodeRectForKey:key]);
}

- (void)encodeCGSize:(CGSize)size forKey:(NSString *)key {
	[self encodeSize:NSSizeFromCGSize(size) forKey:key];
}

- (CGSize)decodeCGSizeForKey:(NSString *)key {
	return NSSizeFromCGSize([self decodeSizeForKey:key]);
}

- (void)encodeCGAffineTransform:(CGAffineTransform)transform forKey:(NSString *)key {
	NSData *data = [NSData dataWithBytes:&transform length:sizeof(CGAffineTransform)];
	[self encodeObject:data forKey:key];
}

- (CGAffineTransform)decodeCGAffineTransformForKey:(NSString *)key {
	CGAffineTransform result = CGAffineTransformIdentity;
	
	NSData *data = [self decodeObjectForKey:key];
	[data getBytes:&result length:sizeof(CGAffineTransform)];
	
	return result;
}

- (void)encodeTUIEdgeInsets:(TUIEdgeInsets)insets forKey:(NSString *)key {
	NSData *data = [NSData dataWithBytes:&insets length:sizeof(TUIEdgeInsets)];
	[self encodeObject:data forKey:key];
}

- (TUIEdgeInsets)decodeTUIEdgeInsetsForKey:(NSString *)key {
	TUIEdgeInsets result = TUIEdgeInsetsZero;
	
	NSData *data = [self decodeObjectForKey:key];
	[data getBytes:&result length:sizeof(TUIEdgeInsets)];
	
	return result;
}

@end
