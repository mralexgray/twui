/*

 */

//#import "TUIKit.h"

@class ExampleTabBar;

@protocol ExampleTabBarDelegate <NSObject>

@required
- (void)tabBar:(ExampleTabBar *)tabBar didSelectTab:(NSInteger)index;

@end

// An example of how to build a custom UI control, in this case a simple tab bar.
@interface ExampleTabBar : TUIView

- (id)initWithNumberOfTabs:(NSUInteger)count;

@property (nonatomic, unsafe_unretained) id<ExampleTabBarDelegate> delegate;
@property (nonatomic, readonly) NSArray *tabViews;

- (BOOL)isHighlightingTab:(TUIView *)tab;

@end
