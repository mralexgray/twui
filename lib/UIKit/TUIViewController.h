/*

 */

#import "TUIResponder.h"

@class TUINavigationItem;
@class TUINavigationController;
@class TUIView;

@interface TUIViewController : TUIResponder <NSCopying>
{
	TUIView           *_view;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property(nonatomic,strong) TUIView *view;

- (void)loadView;
- (void)viewDidLoad;
- (void)viewDidUnload;
- (BOOL)isViewLoaded;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

- (void)didReceiveMemoryWarning;

@property (nonatomic, unsafe_unretained) TUIViewController *parentViewController; // If this view controller is inside a navigation controller or tab bar controller, or has been presented modally by another view controller, return it.
@property (nonatomic, unsafe_unretained) TUINavigationController *navigationController;

@end
