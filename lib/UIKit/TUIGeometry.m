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

#import "TUIGeometry.h"

const TUIEdgeInsets TUIEdgeInsetsZero = { .top = 0.0f, .left = 0.0f, .bottom = 0.0f, .right = 0.0f };

NSString* NSStringFromCGAffineTransform(CGAffineTransform transform) {
    return [NSString stringWithFormat:@"[%lg, %lg, %lg, %lg, %lg, %lg]",
			transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty];
}

NSString* NSStringFromTUIEdgeInsets(TUIEdgeInsets insets) {
    return [NSString stringWithFormat:@"{%lg, %lg, %lg, %lg}",
			insets.top, insets.left, insets.bottom, insets.right];
}

CGAffineTransform CGAffineTransformFromNSString(NSString *string) {
	CGAffineTransform result = CGAffineTransformIdentity;
	
	if(string != nil) {
		double a, b, c, d, tx, ty;
        sscanf(string.UTF8String, "[%lg, %lg, %lg, %lg, %lg, %lg]", &a, &b, &c, &d, &tx, &ty);
		result = CGAffineTransformMake(a, b, c, d, tx, ty);
	}
	
	return result;
}

TUIEdgeInsets TUIEdgeInsetsFromNSString(NSString *string) {
	TUIEdgeInsets result = TUIEdgeInsetsZero;
	
	if(string != nil) {
		double top, left, bottom, right;
        sscanf(string.UTF8String, "[%lg, %lg, %lg, %lg]", &top, &left, &bottom, &right);
		result = TUIEdgeInsetsMake(top, left, bottom, right);
	}
	
	return result;
}