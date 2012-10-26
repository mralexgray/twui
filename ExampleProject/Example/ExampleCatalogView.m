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

#import "ExampleCatalogView.h"

@implementation ExampleCatalogView

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        self.backgroundColor = [NSColor colorWithCalibratedWhite:0.95 alpha:1.0];
		
		for(int i = TUIButtonTypeCustom; i <= TUIButtonTypeInline; i++) {
			
			CGRect buttonRect = self.bounds;
			buttonRect.size.width /= 2;
			buttonRect.size.height /= (TUIButtonTypeInline / 2) + !(TUIButtonTypeInline % 2);
			buttonRect.origin.x = (i % 2) ? buttonRect.size.width : 0.0f;
			buttonRect.origin.y = (i / 2) * buttonRect.size.height;
			
			TUIButton *button = [TUIButton buttonWithType:i];
			
			button.titleLabel.font = [NSFont systemFontOfSize:24.0f];
			button.frame = CGRectIntegral(CGRectInset(buttonRect, 10.0f, 10.0f));
			if(i == TUIButtonTypeEmbossed)
				button.tintColor = [NSColor colorWithCalibratedRed:0.17 green:0.69 blue:0.84 alpha:1.0];
			button.reversesTitleShadowWhenHighlighted = YES;
			
			button.titleLabel.alignment = TUITextAlignmentCenter;
			button.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
			button.titleLabel.renderer.shadowBlur = 1.0f;
			button.titleLabel.renderer.shadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.5];
			button.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
			
			[button setTitle:@"Normal" forState:TUIControlStateNormal];
			[button setTitle:@"Hover" forState:TUIControlStateHover];
			[button setTitle:@"Highlighted" forState:TUIControlStateHighlighted];
			[button setTitle:@"Selected" forState:TUIControlStateSelected];
			[button setTitleColor:[NSColor whiteColor] forState:TUIControlStateNormal];
			
			[button addActionForControlEvents:TUIControlEventMouseUpInside block:^{
				self.backgroundColor = (i % 2) ? [NSColor colorWithCalibratedWhite:0.15 alpha:1.0] :
												 [NSColor colorWithCalibratedWhite:0.95 alpha:1.0];
			}];
			[self addSubview:button];
		}
    }
    return self;
}

@end
