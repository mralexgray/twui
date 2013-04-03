/*

 */

#import <Foundation/Foundation.h>
#import "NSShadow+TUIExtensions.h"

extern NSString * const TUIAttributedStringBackgroundColorAttributeName;
extern NSString * const TUIAttributedStringBackgroundFillStyleName;
extern NSString * const TUIAttributedStringPreDrawBlockName;

typedef void (^TUIAttributedStringPreDrawBlock)(NSAttributedString *attributedString, NSRange substringRange, CGRect rects[], CFIndex rectCount);

typedef enum TUILineBreakMode : NSUInteger {
	TUILineBreakModeWordWrap,
	TUILineBreakModeCharacterWrap,
	TUILineBreakModeClip,
	TUILineBreakModeHeadTruncation,
	TUILineBreakModeTailTruncation,
	TUILineBreakModeMiddleTruncation,
} TUILineBreakMode;

typedef enum TUIBaselineAdjustment : NSUInteger {
	TUIBaselineAdjustmentAlignBaselines,
	TUIBaselineAdjustmentAlignCenters,
	TUIBaselineAdjustmentNone,
} TUIBaselineAdjustment;

typedef enum TUITextAlignment : NSUInteger {
	TUITextAlignmentLeft,
	TUITextAlignmentCenter,
	TUITextAlignmentRight,
	TUITextAlignmentJustified,
} TUITextAlignment;

typedef enum TUIBackgroundFillStyle : NSUInteger {
	TUIBackgroundFillStyleInline,
	TUIBackgroundFillStyleBlock,
} TUIBackgroundFillStyle;

@interface TUIAttributedString : NSMutableAttributedString

+ (TUIAttributedString *)stringWithString:(NSString *)string;

@end

@interface NSMutableAttributedString (TUIAdditions)

// write-only properties, reading will return nil
@property (nonatomic, retain) NSFont *font;
@property (nonatomic, retain) NSColor *color;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, assign) TUIBackgroundFillStyle backgroundFillStyle;
@property (nonatomic, retain) NSShadow *shadow;
@property (nonatomic, assign) TUITextAlignment alignment; // setting this will set lineBreakMode to word wrap, use setAlignment:lineBreakMode: for more control
@property (nonatomic, assign) CGFloat kerning;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, copy) NSString *text;

- (void)setAlignment:(TUITextAlignment)alignment lineBreakMode:(TUILineBreakMode)lineBreakMode;

- (NSRange)_stringRange;
- (void)setFont:(NSFont *)font inRange:(NSRange)range;
- (void)setColor:(NSColor *)color inRange:(NSRange)range;
- (void)setBackgroundColor:(NSColor *)color inRange:(NSRange)range;
- (void)setBackgroundFillStyle:(TUIBackgroundFillStyle)fillStyle inRange:(NSRange)range;
- (void)setPreDrawBlock:(TUIAttributedStringPreDrawBlock)block inRange:(NSRange)range; // the pre-draw block is called before the text or text background has been drawn
- (void)setShadow:(NSShadow *)shadow inRange:(NSRange)range;
- (void)setKerning:(CGFloat)f inRange:(NSRange)range;
- (void)setLineHeight:(CGFloat)f inRange:(NSRange)range;

@end

extern NSParagraphStyle *ABNSParagraphStyleForTextAlignment(TUITextAlignment alignment);
