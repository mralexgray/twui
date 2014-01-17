#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>
//#import "TUIKit.h"

@interface ExampleSectionHeaderView : TUITableViewSectionHeader {
  
  TUITextRenderer * _labelRenderer;
  
}

@property (readonly) TUITextRenderer  * labelRenderer;

@end

