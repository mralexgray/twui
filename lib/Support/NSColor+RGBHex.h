//
//  NSColor+RGBHex.h
//  TwUI
//
//  Created by Adam Kirk on 6/1/13.
//
//

#import <Cocoa/Cocoa.h>

@interface NSColor (RGBHex)

+ (NSColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;
+ (NSColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(CGFloat)a;
+ (NSColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (NSColor *)colorWithHex:(NSInteger)hex;

@end
