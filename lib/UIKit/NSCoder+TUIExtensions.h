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

#import <Foundation/Foundation.h>
#import "TUIGeometry.h"

@interface NSCoder (TUIExtensions)

- (void)encodeCGPoint:(CGPoint)point forKey:(NSString *)key;
- (void)encodeCGRect:(CGRect)rect forKey:(NSString *)key;
- (void)encodeCGSize:(CGSize)size forKey:(NSString *)key;
- (void)encodeCGAffineTransform:(CGAffineTransform)transform forKey:(NSString *)key;
- (void)encodeTUIEdgeInsets:(TUIEdgeInsets)insets forKey:(NSString *)key;

- (CGPoint)decodeCGPointForKey:(NSString *)key;
- (CGRect)decodeCGRectForKey:(NSString *)key;
- (CGSize)decodeCGSizeForKey:(NSString *)key;
- (CGAffineTransform)decodeCGAffineTransformForKey:(NSString *)key;
- (TUIEdgeInsets)decodeTUIEdgeInsetsForKey:(NSString *)key;

@end
