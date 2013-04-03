/*

 */

#import <ApplicationServices/ApplicationServices.h>

typedef enum AB_CTLineRectAggregationType : NSUInteger {
	AB_CTLineRectAggregationTypeInline,
	AB_CTLineRectAggregationTypeBlock,
} AB_CTLineRectAggregationType;

extern CGSize AB_CTLineGetSize(CTLineRef line);
extern CGSize AB_CTFrameGetSize(CTFrameRef frame);
extern CGFloat AB_CTFrameGetHeight(CTFrameRef frame);
extern CFIndex AB_CTFrameGetStringIndexForPosition(CTFrameRef frame, CGPoint p);

extern void AB_CTFrameGetIndexForPositionInLine(NSString *string, CTFrameRef frame, CFIndex lineIndex, float xPosition, CFIndex *index);
extern void AB_CTFrameGetLinePositionOfIndex(NSString *string, CTFrameRef frame, CFIndex index, CFIndex *lineIndex, float *xPosition);
extern void AB_CTFrameGetRectsForRange(CTFrameRef frame, CFRange range, CGRect rects[], CFIndex *rectCount);
extern void AB_CTFrameGetRectsForRangeWithAggregationType(CTFrameRef frame, CFRange range, AB_CTLineRectAggregationType aggregationType, CGRect rects[], CFIndex *rectCount);
extern void AB_CTLinesGetRectsForRangeWithAggregationType(NSArray *lines, CGPoint *lineOrigins, CGRect bounds, CFRange range, AB_CTLineRectAggregationType aggregationType, CGRect rects[], CFIndex *rectCount);
