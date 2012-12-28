/*
 Copyright 2011 Twitter, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this work except in compliance with the License.
 You may obtain a copy of the License in the LICENSE file, or at:
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "ExampleScrollView.h"

@implementation ExampleScrollView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
		[self addButtons];
	}
	return self;
}

- (void)addButtons {
	TUIButton *button;
	CGFloat padding = 5.0f;
	
	NSUInteger buttonCount = 0;
	NSUInteger buttonsPerRow = 5;
	
	CGFloat designatedWidth = fabs((self.bounds.size.width / (CGFloat)buttonsPerRow) - (padding * 2));
	CGFloat designatedHeight = 22.0f;
	
	#define buttonRow ((int)(buttonCount / buttonsPerRow))
	#define buttonColumn ((int)(buttonCount % buttonsPerRow))
	
#pragma mark -
	
	button = [TUIButton buttonWithType:TUIButtonTypeStandard];
	button.frame = CGRectMake(((buttonColumn + 1) * padding) + (buttonColumn * designatedWidth),
							  ((buttonRow + 1) * padding) + (buttonRow * designatedHeight),
							  designatedWidth, designatedHeight);
	button.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	
	button.titleLabel.alignment = TUITextAlignmentCenter;
	button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	button.titleLabel.renderer.shadowBlur = 1.0f;
	button.titleLabel.renderer.shadowColor = [NSColor highlightColor];
	button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
	button.imagePosition = TUIControlImagePositionLeft;
	
	[button setTitle:@"Select" forState:TUIControlStateNormal];
	[button setTitle:@"Deselect" forState:TUIControlStateSelected];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0] forState:TUIControlStateNormal];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] forState:TUIControlStateHighlighted];
	[button setImage:[NSImage imageNamed:NSImageNameActionTemplate] forState:TUIControlStateNormal];
	
	button.preferredMenuEdge = CGRectMinYEdge;
	button.menuType = TUIButtonMenuTypePopUp;
	button.synchronizeMenuTitle = NO;
	
	button.menu = [NSMenu new];
	[button.menu addItemWithTitle:@"Demo 1" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 2" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 3" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 4" action:nil keyEquivalent:@""];
	[button.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
		item.enabled = YES;
	}];
	
	[self addSubview:button];
	buttonCount++;
	
	button = [TUIButton buttonWithType:TUIButtonTypeRectangular];
	button.frame = CGRectMake(((buttonColumn + 1) * padding) + (buttonColumn * designatedWidth),
							  ((buttonRow + 1) * padding) + (buttonRow * designatedHeight),
							  designatedWidth, designatedHeight);
	button.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	
	button.titleLabel.alignment = TUITextAlignmentCenter;
	button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	button.titleLabel.renderer.shadowBlur = 1.0f;
	button.titleLabel.renderer.shadowColor = [NSColor highlightColor];
	button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
	button.imagePosition = TUIControlImagePositionLeft;
	
	[button setTitle:@"Select" forState:TUIControlStateNormal];
	[button setTitle:@"Deselect" forState:TUIControlStateSelected];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0] forState:TUIControlStateNormal];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] forState:TUIControlStateHighlighted];
	[button setImage:[NSImage imageNamed:NSImageNameActionTemplate] forState:TUIControlStateNormal];
	
	button.preferredMenuEdge = CGRectMinYEdge;
	button.menuType = TUIButtonMenuTypePopUp;
	button.synchronizeMenuTitle = NO;
	
	button.menu = [NSMenu new];
	[button.menu addItemWithTitle:@"Demo 1" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 2" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 3" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 4" action:nil keyEquivalent:@""];
	[button.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
		item.enabled = YES;
	}];
	
	[self addSubview:button];
	buttonCount++;
	
	button = [TUIButton buttonWithType:TUIButtonTypeCircular];
	button.frame = CGRectMake(((buttonColumn + 1) * padding) + (buttonColumn * designatedWidth),
							  ((buttonRow + 1) * padding) + (buttonRow * designatedHeight),
							  designatedWidth, designatedHeight);
	button.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	
	button.titleLabel.alignment = TUITextAlignmentCenter;
	button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	button.titleLabel.renderer.shadowBlur = 1.0f;
	button.titleLabel.renderer.shadowColor = [NSColor highlightColor];
	button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
	button.imagePosition = TUIControlImagePositionLeft;
	
	[button setTitle:@"Select" forState:TUIControlStateNormal];
	[button setTitle:@"Deselect" forState:TUIControlStateSelected];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0] forState:TUIControlStateNormal];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] forState:TUIControlStateHighlighted];
	[button setImage:[NSImage imageNamed:NSImageNameActionTemplate] forState:TUIControlStateNormal];
	
	button.preferredMenuEdge = CGRectMinYEdge;
	button.menuType = TUIButtonMenuTypePopUp;
	button.synchronizeMenuTitle = NO;
	
	button.menu = [NSMenu new];
	[button.menu addItemWithTitle:@"Demo 1" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 2" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 3" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 4" action:nil keyEquivalent:@""];
	[button.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
		item.enabled = YES;
	}];
	
	[self addSubview:button];
	buttonCount++;
	
	button = [TUIButton buttonWithType:TUIButtonTypeTextured];
	button.frame = CGRectMake(((buttonColumn + 1) * padding) + (buttonColumn * designatedWidth),
							  ((buttonRow + 1) * padding) + (buttonRow * designatedHeight),
							  designatedWidth, designatedHeight);
	button.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	
	button.titleLabel.alignment = TUITextAlignmentCenter;
	button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	button.titleLabel.renderer.shadowBlur = 1.0f;
	button.titleLabel.renderer.shadowColor = [NSColor highlightColor];
	button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
	button.imagePosition = TUIControlImagePositionLeft;
	
	[button setTitle:@"Select" forState:TUIControlStateNormal];
	[button setTitle:@"Deselect" forState:TUIControlStateSelected];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0] forState:TUIControlStateNormal];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] forState:TUIControlStateHighlighted];
	[button setImage:[NSImage imageNamed:NSImageNameActionTemplate] forState:TUIControlStateNormal];
	
	button.preferredMenuEdge = CGRectMinYEdge;
	button.menuType = TUIButtonMenuTypePopUp;
	button.synchronizeMenuTitle = NO;
	
	button.menu = [NSMenu new];
	[button.menu addItemWithTitle:@"Demo 1" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 2" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 3" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 4" action:nil keyEquivalent:@""];
	[button.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
		item.enabled = YES;
	}];
	
	[self addSubview:button];
	buttonCount++;
	
	button = [TUIButton buttonWithType:TUIButtonTypeMinimal];
	button.frame = CGRectMake(((buttonColumn + 1) * padding) + (buttonColumn * designatedWidth),
							  ((buttonRow + 1) * padding) + (buttonRow * designatedHeight),
							  designatedWidth, designatedHeight);
	button.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	
	button.titleLabel.alignment = TUITextAlignmentCenter;
	button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	button.titleLabel.renderer.shadowBlur = 1.0f;
	button.titleLabel.renderer.shadowColor = [NSColor highlightColor];
	button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
	button.imagePosition = TUIControlImagePositionLeft;
	
	[button setTitle:@"Select" forState:TUIControlStateNormal];
	[button setTitle:@"Deselect" forState:TUIControlStateSelected];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0] forState:TUIControlStateNormal];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] forState:TUIControlStateHighlighted];
	[button setImage:[NSImage imageNamed:NSImageNameActionTemplate] forState:TUIControlStateNormal];
	
	button.preferredMenuEdge = CGRectMinYEdge;
	button.menuType = TUIButtonMenuTypePopUp;
	button.synchronizeMenuTitle = NO;
	
	button.menu = [NSMenu new];
	[button.menu addItemWithTitle:@"Demo 1" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 2" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 3" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 4" action:nil keyEquivalent:@""];
	[button.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
		item.enabled = YES;
	}];
	
	[self addSubview:button];
	buttonCount++;
	
	button = [TUIButton buttonWithType:TUIButtonTypeInline];
	button.frame = CGRectMake(((buttonColumn + 1) * padding) + (buttonColumn * designatedWidth),
							  ((buttonRow + 1) * padding) + (buttonRow * designatedHeight),
							  designatedWidth, designatedHeight);
	button.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	
	button.titleLabel.alignment = TUITextAlignmentCenter;
	button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	button.titleLabel.renderer.shadowBlur = 1.0f;
	button.titleLabel.renderer.shadowColor = [NSColor highlightColor];
	button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
	button.imagePosition = TUIControlImagePositionLeft;
	
	[button setTitle:@"Select" forState:TUIControlStateNormal];
	[button setTitle:@"Deselect" forState:TUIControlStateSelected];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0] forState:TUIControlStateNormal];
	[button setTitleColor:[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] forState:TUIControlStateHighlighted];
	[button setImage:[NSImage imageNamed:NSImageNameActionTemplate] forState:TUIControlStateNormal];
	
	button.preferredMenuEdge = CGRectMinYEdge;
	button.menuType = TUIButtonMenuTypePopUp;
	button.synchronizeMenuTitle = NO;
	
	button.menu = [NSMenu new];
	[button.menu addItemWithTitle:@"Demo 1" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 2" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 3" action:nil keyEquivalent:@""];
	[button.menu addItemWithTitle:@"Demo 4" action:nil keyEquivalent:@""];
	[button.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
		item.enabled = YES;
	}];
	
	[self addSubview:button];
	buttonCount++;
#pragma mark -
	
}

@end
