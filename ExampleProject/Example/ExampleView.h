/*

 */

//#import "TUIKit.h"
#import <AtoZ/AtoZ.h>
#import "ExampleTabBar.h"

@interface ExampleView : TUIView <TUITableViewDelegate, TUITableViewDataSource, ExampleTabBarDelegate>
{
	TUITableView *_tableView;
	ExampleTabBar *_tabBar;
	
	NSFont *exampleFont1;
	NSFont *exampleFont2;
}
@property (nonatomic, retain) TUIViewController *popoC;
@end
