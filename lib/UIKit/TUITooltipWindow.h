
#import <Cocoa/Cocoa.h>

@interface TUITooltipWindow : NSWindow

+ (void)updateTooltip:(NSString *)s delay:(NSTimeInterval)delay; // may pass nil
+ (void)endTooltip; // no animation

@end
