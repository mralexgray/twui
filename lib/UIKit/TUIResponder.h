
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface TUIResponder : NSResponder

/* Use from NSResponder
- (NSResponder *)nextResponder;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
 */

@property (strong, nonatomic, readonly) TUIResponder *initialFirstResponder;

- (NSMenu *)menuForEvent:(NSEvent *)event;
- (BOOL)acceptsFirstMouse:(NSEvent *)event;
- (BOOL)performKeyAction:(NSEvent *)event; // similar semantics to performKeyEquivalent, as in you can implement, but return NO if you don't want to responsibility based on the event, but it travels *up the responder chain*, rather that to everything

@end
