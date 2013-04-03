/*

 */

//#import "TUIKit.h"
#import <AtoZ/AtoZ.h>
#import "ExampleTabBar.h"

@interface ExampleView : TUIView <ExampleTabBarDelegate>

@property (nonatomic, strong) ExampleTabBar *tabBar;
@property (nonatomic, strong) TUICarouselNavigationController *navigationController;

@end
