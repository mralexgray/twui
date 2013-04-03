/*

 */

#import "ExampleAppDelegate.h"
#import "ExampleView.h"
#import "ExampleScrollView.h"

@implementation ExampleAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	CGRect b = CGRectMake(0, 0, 500, 450);
	
	/** Table View */
	tableViewWindow = [[NSWindow alloc] initWithContentRect:b styleMask:NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
	[tableViewWindow setReleasedWhenClosed:FALSE];
	[tableViewWindow setMinSize:NSMakeSize(300, 250)];
	[tableViewWindow center];
	
	/* TUINSView is the bridge between the standard AppKit NSView-based heirarchy and the TUIView-based heirarchy */
	TUINSView *tuiTableViewContainer = [[TUINSView alloc] initWithFrame:b];
	[tableViewWindow setContentView:tuiTableViewContainer];
	
	ExampleView *tableExample = [[ExampleView alloc] initWithFrame:b];
	tuiTableViewContainer.rootView = tableExample;
	
	/** Scroll View */
	scrollViewWindow = [[NSWindow alloc] initWithContentRect:b styleMask:NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES];
	[scrollViewWindow setReleasedWhenClosed:FALSE];
	[scrollViewWindow setMinSize:NSMakeSize(300, 250)];
	[scrollViewWindow setFrameTopLeftPoint:[tableViewWindow cascadeTopLeftFromPoint:CGPointMake(tableViewWindow.frame.origin.x, tableViewWindow.frame.origin.y + tableViewWindow.frame.size.height)]];
	
	/* TUINSView is the bridge between the standard AppKit NSView-based heirarchy and the TUIView-based heirarchy */
	TUINSView *tuiScrollViewContainer = [[TUINSView alloc] initWithFrame:b];
	[scrollViewWindow setContentView:tuiScrollViewContainer];
	
	ExampleScrollView *scrollExample = [[ExampleScrollView alloc] initWithFrame:b];
	tuiScrollViewContainer.rootView = scrollExample;
	
	[self showTableViewExampleWindow:nil];
    
}

/**
 * @brief Show the table view example
 */
-(IBAction)showTableViewExampleWindow:(id)sender {
	[tableViewWindow makeKeyAndOrderFront:sender];
}

/**
 * @brief Show the scroll view example
 */
-(IBAction)showScrollViewExampleWindow:(id)sender {
	[scrollViewWindow makeKeyAndOrderFront:sender];
}


-(IBAction)showAltView:(id)sender {

	[tableViewWindow.contentView removeAllSubviews];
	/* TUINSView is the bridge between the standard AppKit NSView-based heirarchy and the TUIView-based heirarchy */
	TUINSView *tuiTableViewContainer = [[TUINSView alloc] initWithFrame:tableViewWindow.frame];
	[tableViewWindow setContentView:tuiTableViewContainer];

	ExampleView *tableExample = [[ExampleView alloc] initWithFrame:tableViewWindow.frame];
	tuiTableViewContainer.rootView = tableExample;
}
@end
