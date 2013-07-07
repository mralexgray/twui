
#import <TwUI/TUIKit.h>
@class ExampleTabBar;

@protocol ExampleTabBarDelegate <NSObject>
@required
- (void)tabBar:(ExampleTabBar *)tabBar didSelectTab:(NSInteger)index;
@end

/*
 An example of how to build a custom UI control, in this case a simple tab bar
 */

@interface ExampleTabBar : TUIView
{
	id<ExampleTabBarDelegate> __unsafe_unretained delegate;
	NSArray *tabViews;
}

- (id)initWithNumberOfTabs:(NSInteger)nTabs;

@property (nonatomic, unsafe_unretained) id<ExampleTabBarDelegate> delegate;
@property (nonatomic, readonly) NSArray *tabViews;

@end
