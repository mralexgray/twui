/*

 */

#import "TUITextRenderer.h"

@interface TUITextRenderer (Event)

- (CFIndex)stringIndexForPoint:(CGPoint)p;
- (CFIndex)stringIndexForEvent:(NSEvent *)event;
- (void)resetSelection;
- (CGRect)rectForCurrentSelection;

- (void)copy:(id)sender;

@property (nonatomic, assign) id<TUITextRendererDelegate> delegate;

@end

@protocol TUITextRendererDelegate <NSObject>

@optional
- (NSArray *)activeRangesForTextRenderer:(TUITextRenderer *)t;

- (void)textRendererWillBecomeFirstResponder:(TUITextRenderer *)textRenderer;
- (void)textRendererDidBecomeFirstResponder:(TUITextRenderer *)textRenderer;
- (void)textRendererWillResignFirstResponder:(TUITextRenderer *)textRenderer;
- (void)textRendererDidResignFirstResponder:(TUITextRenderer *)textRenderer;

@end
