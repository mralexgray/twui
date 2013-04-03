/*

 */

#import "TUIView.h"
#import "TUIScrollView.h"

@interface TUIScroller : TUIView

@property (nonatomic, unsafe_unretained) TUIScrollView *scrollView;
@property (nonatomic, readonly) TUIView *knob;

@property (nonatomic, assign) TUIScrollViewIndicatorStyle scrollIndicatorStyle;

@property (nonatomic, readonly, getter = isFlashing) BOOL flashing;
@property (nonatomic, readonly, getter = isExpanded) BOOL expanded;

- (void)flash;

@end
