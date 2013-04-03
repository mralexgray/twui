/*

 */

#import "ABActiveRange.h"

@implementation ABFlavoredRange

@synthesize rangeValue;

+ (id)valueWithRange:(NSRange)r
{
	ABFlavoredRange *f = [[ABFlavoredRange alloc] init];
	f.rangeValue = r;
	return f;
}


- (id)copyWithZone:(NSZone *)zone
{
	return self; // these are immutable after creation
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<ABFlavoredRange %lu %@ (%@)>", (unsigned long)rangeFlavor, NSStringFromRange(rangeValue), displayString];
}

- (ABActiveTextRangeFlavor)rangeFlavor
{
	return rangeFlavor;
}

- (void)setRangeFlavor:(ABActiveTextRangeFlavor)f
{
	rangeFlavor = f;
}

- (NSString *)displayString
{
	return displayString;
}

- (void)setDisplayString:(NSString *)s
{
	displayString = [s copy];
}

@end
