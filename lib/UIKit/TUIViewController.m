
#import "TUIViewController.h"
#import "TUIView.h"

@implementation TUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self init];
}


- (id)copyWithZone:(NSZone *)zone
{
	TUIViewController *v = [[[self class] alloc] init];
	// subclasses should override, call super, and copy over necessary properties
	return v;
}

- (TUIView *)view
{
	if(!_view) {
		[self loadView];
		[self viewDidLoad];
		[_view setNextResponder:self];
	}
	return _view;
}

- (void)setView:(TUIView *)v
{
	_view = v;

	if (!_view) {
		[self viewDidUnload];
	}
}

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
	return NO;
}

- (void)loadView
{
	// subclasses must implement
}

- (void)viewDidLoad
{
	
}

- (void)viewDidUnload
{
	
}

- (BOOL)isViewLoaded
{
	return _view != nil;
}

- (void)viewWillAppear:(BOOL)animated { }
- (void)viewDidAppear:(BOOL)animated { }
- (void)viewWillDisappear:(BOOL)animated { }
- (void)viewDidDisappear:(BOOL)animated { }

- (void)didReceiveMemoryWarning // Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
{
	if(_view && !_view.superview) {
		self.view = nil;
	}
}

- (TUIResponder *)initialFirstResponder
{
	return _view.initialFirstResponder;
}

@end
