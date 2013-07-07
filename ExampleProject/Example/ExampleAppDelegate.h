
#import <Cocoa/Cocoa.h>
#import <TwUI/TUIKit.h>

@interface ExampleAppDelegate : NSObject <NSApplicationDelegate>
{
  NSWindow    * tableViewWindow;
  NSWindow    * scrollViewWindow;
}

-(IBAction)showTableViewExampleWindow:(id)sender;
-(IBAction)showScrollViewExampleWindow:(id)sender;

@end
