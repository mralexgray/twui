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
        self.backgroundColor = [NSColor colorWithCalibratedWhite:0.23 alpha:1.0];
		
		
		
		TUIButton *button1 = [TUIButton buttonWithType:TUIButtonTypeStandard];
		button1.tintColor = [NSColor colorWithCalibratedRed:0.17 green:0.69 blue:0.84 alpha:1.0];
		button1.frame = CGRectMake(10, 10, 256, 128);
		button1.titleLabel.font = [NSFont systemFontOfSize:24.0f];
		button1.titleLabel.alignment = TUITextAlignmentCenter;
		button1.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
		button1.titleLabel.renderer.shadowBlur = 1.0f;
		button1.titleLabel.renderer.shadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.5];
		button1.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
		button1.reversesTitleShadowWhenHighlighted = YES;
		[button1 setTitle:@"Button 1" forState:TUIControlStateNormal];
		[button1 setTitleColor:[NSColor whiteColor] forState:TUIControlStateNormal];
		[self addSubview:button1];
    }
    return self;
}

@end
