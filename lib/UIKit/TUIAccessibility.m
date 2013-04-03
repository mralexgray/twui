/*

 */

#import "TUIAccessibility.h"

TUIAccessibilityTraits TUIAccessibilityTraitNone = 1 << 0;
TUIAccessibilityTraits TUIAccessibilityTraitButton = 1 << 1;
TUIAccessibilityTraits TUIAccessibilityTraitLink = 1 << 2;
TUIAccessibilityTraits TUIAccessibilityTraitSearchField = 1 << 3;
TUIAccessibilityTraits TUIAccessibilityTraitImage = 1 << 4;
TUIAccessibilityTraits TUIAccessibilityTraitSelected = 1 << 5;
TUIAccessibilityTraits TUIAccessibilityTraitPlaysSound = 1 << 6;
TUIAccessibilityTraits TUIAccessibilityTraitStaticText = 1 << 7;
TUIAccessibilityTraits TUIAccessibilityTraitSummaryElement = 1 << 8;
TUIAccessibilityTraits TUIAccessibilityTraitNotEnabled = 1 << 9;
TUIAccessibilityTraits TUIAccessibilityTraitUpdatesFrequently = 1 << 10;

@implementation NSObject (TUIAccessibility)

- (BOOL)isAccessibilityElement
{
    return NO;
}

- (void)setIsAccessibilityElement:(BOOL)isElement
{
	
}

- (NSString *)accessibilityLabel
{
    return nil;
}

- (void)setAccessibilityLabel:(NSString *)label
{
	
}

- (NSString *)accessibilityHint
{
    return nil;
}

- (void)setAccessibilityHint:(NSString *)hint
{
	
}

- (NSString *)accessibilityValue
{
    return nil;
}

- (void)setAccessibilityValue:(NSString *)value
{
	
}

- (TUIAccessibilityTraits)accessibilityTraits
{
    return TUIAccessibilityTraitNone;
}

- (void)setAccessibilityTraits:(TUIAccessibilityTraits)traits
{

}

- (CGRect)accessibilityFrame
{
    return CGRectNull;
}

- (void)setAccessibilityFrame:(CGRect)frame
{
	
}


#pragma mark NSAccessibility

// This is the part where we transate TUIAccessibility values into something that NSAccessibility can understand. Hopefully.

- (NSArray *)accessibilityAttributeNames
{
    static NSArray *attributes = nil;
    if(attributes == nil) {
		attributes = [[NSArray alloc] initWithObjects:NSAccessibilityRoleAttribute, NSAccessibilityRoleDescriptionAttribute, NSAccessibilityFocusedAttribute, NSAccessibilityParentAttribute, NSAccessibilityWindowAttribute, NSAccessibilityTopLevelUIElementAttribute, NSAccessibilityPositionAttribute, NSAccessibilitySizeAttribute, nil];
    }
	
    return attributes;
}

- (id)accessibilityAttributeValue:(NSString *)attribute
{
    if([attribute isEqualToString:NSAccessibilityRoleAttribute]) {
		return @"radioButton";
    } else if([attribute isEqualToString:NSAccessibilityRoleDescriptionAttribute]) {
		return @"radio button"; //NSAccessibilityRoleDescription(role, nil);
    } else if([attribute isEqualToString:NSAccessibilityFocusedAttribute]) {
		// Just check if the app thinks we're focused.
		id focusedElement = [NSApp accessibilityAttributeValue:NSAccessibilityFocusedUIElementAttribute];
		return [NSNumber numberWithBool:[focusedElement isEqual:self]];
    } else if([attribute isEqualToString:NSAccessibilityParentAttribute]) {
		return nil; //NSAccessibilityUnignoredAncestor(parent);
    } else if([attribute isEqualToString:NSAccessibilityWindowAttribute]) {
		// We're in the same window as our parent.
		return nil; //[parent accessibilityAttributeValue:NSAccessibilityWindowAttribute];
    } else if([attribute isEqualToString:NSAccessibilityTopLevelUIElementAttribute]) {
		// We're in the same top level element as our parent.
		return nil; //[parent accessibilityAttributeValue:NSAccessibilityTopLevelUIElementAttribute];
    } else if([attribute isEqualToString:NSAccessibilityPositionAttribute]) {
		return nil; //[NSValue valueWithPoint:[parent fauxUIElementPosition:self]];
    } else if([attribute isEqualToString:NSAccessibilitySizeAttribute]) {
		return nil; //[NSValue valueWithSize:[parent fauxUIElementSize:self]];
    } else {
		return nil;
    }
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute
{
    if([attribute isEqualToString:NSAccessibilityFocusedAttribute]) {
		return NO; //[parent isFauxUIElementFocusable:self];
    } else {
		return NO;
    }
}

- (void)accessibilitySetValue:(id)value forAttribute:(NSString *)attribute
{
    if([attribute isEqualToString:NSAccessibilityFocusedAttribute]) {
		//		[parent fauxUIElement:self setFocus:value];
    }
}

- (NSArray *)accessibilityActionNames {
    return [NSArray array];
}

- (NSString *)accessibilityActionDescription:(NSString *)action {
    return nil;
}

- (void)accessibilityPerformAction:(NSString *)action {
	
}

- (BOOL)accessibilityIsIgnored {
    return ![self isAccessibilityElement];
}

- (id)accessibilityHitTest:(NSPoint)point
{
    return NSAccessibilityUnignoredAncestor(self);
}

- (id)accessibilityFocusedUIElement
{
    return NSAccessibilityUnignoredAncestor(self);
}

@end
