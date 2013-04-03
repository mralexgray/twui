/*

 */

#import <Foundation/Foundation.h>

typedef enum ABActiveTextRangeFlavor : NSUInteger {
	ABActiveTextRangeFlavorUnknown,
	ABActiveTextRangeFlavorURL,
	ABActiveTextRangeFlavorEmail,
	ABActiveTextRangeFlavorTwitterUsername,
	ABActiveTextRangeFlavorTwitterList,
	ABActiveTextRangeFlavorTwitterHashtag,
	ABActiveTextRangeFlavorTwitterStockSymbol,
} ABActiveTextRangeFlavor;

@protocol ABActiveTextRange <NSObject, NSCopying> // NSValue(NSRange) implicitly conforms
@property (nonatomic, readonly) NSRange rangeValue;
@property (nonatomic, readonly) ABActiveTextRangeFlavor rangeFlavor;
@property (nonatomic, readonly) NSString *displayString;
@end

@interface ABFlavoredRange : NSObject <ABActiveTextRange>
{
	NSString *displayString;
	NSRange rangeValue;
	ABActiveTextRangeFlavor rangeFlavor;
}

@property (nonatomic, assign) NSRange rangeValue;
@property (nonatomic, assign) ABActiveTextRangeFlavor rangeFlavor;

- (void)setDisplayString:(NSString *)s; // copy

@end
