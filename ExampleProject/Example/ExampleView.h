
#import <TwUI/TUIKit.h>
#import "ExampleTabBar.h"

@interface ExampleView : TUIView <ExampleTabBarDelegate>

@property (nonatomic, strong) ExampleTabBar *tabBar;
@property (nonatomic, strong) TUINavigationController *navigationController;

@end
