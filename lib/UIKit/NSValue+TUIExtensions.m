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

#import "NSValue+TUIExtensions.h"

@implementation NSValue (TUIExtensions)

+ (NSValue *)valueWithCGAffineTransform:(CGAffineTransform)transform {
	return [NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)];
}

- (CGAffineTransform)CGAffineTransformValue {
	if(strcmp([self objCType], @encode(CGAffineTransform)) == 0) {
		CGAffineTransform transform;
		[self getValue:&transform];
		return transform;
	}
	
	return CGAffineTransformIdentity;
}

+ (NSValue *)valueWithTUIEdgeInsets:(TUIEdgeInsets)insets {
	return [NSValue valueWithBytes:&insets objCType:@encode(TUIEdgeInsets)];
}

- (TUIEdgeInsets)TUIEdgeInsetsValue {
	if(strcmp([self objCType], @encode(TUIEdgeInsets)) == 0) {
		TUIEdgeInsets insets;
		[self getValue:&insets];
		return insets;
	}
	
	return TUIEdgeInsetsZero;
}

@end
