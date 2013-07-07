#import <Cocoa/Cocoa.h>
#import <TwUI/TUIKit.h>

@interface ExampleSectionHeaderView : TUITableViewSectionHeader {
  
  TUITextRenderer * _labelRenderer;
  
}

@property (readonly) TUITextRenderer  * labelRenderer;

@end

