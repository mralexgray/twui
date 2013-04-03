/*

 */

#import "TUIResponder.h"

@implementation TUIResponder

- (BOOL)becomeFirstResponder
{
	return YES;
}

- (BOOL)resignFirstResponder
{
	return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
	return YES; // Controls default to NO
}

- (NSMenu *)menuForEvent:(NSEvent *)event
{
	return nil;
}

- (BOOL)performKeyAction:(NSEvent *)event
{
	return NO;
}

- (TUIResponder *)initialFirstResponder
{
	return self;
}

@end
