//
//  NSColor+RGBHex.m
//  TwUI
//
//  Created by Adam Kirk on 6/1/13.
//
//

#import "NSColor+RGBHex.h"

@implementation NSColor (RGBHex)


#pragma mark - RGB

+ (NSColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b
{
    return [self colorWithR:r G:g B:b A:1.0f];
}

+ (NSColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(CGFloat)a
{
    return [NSColor colorWithCalibratedRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}



#pragma mark - HEX

+ (NSColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    NSInteger red   = (hex & 0xFF0000) >> 16;
    NSInteger green = (hex & 0xFF00)   >> 8;
    NSInteger blue  = (hex & 0xFF);
    return [self colorWithR:red G:green B:blue A:alpha];
}

+ (NSColor *)colorWithHex:(NSInteger)hex
{
    return [self colorWithHex:hex alpha:1.0f];
}

@end
