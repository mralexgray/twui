/*

 */

#import <Cocoa/Cocoa.h>
//#import "TUIKit.h"

@interface ExampleAppDelegate : NSObject <NSApplicationDelegate>
{
  NSWindow    * tableViewWindow;
  NSWindow    * scrollViewWindow;
}

-(IBAction)showTableViewExampleWindow:(id)sender;
-(IBAction)showScrollViewExampleWindow:(id)sender;
-(IBAction)showAltView:(id)sender;
@end
