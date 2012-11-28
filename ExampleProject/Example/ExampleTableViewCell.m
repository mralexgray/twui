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

#import "ExampleTableViewCell.h"

@implementation ExampleTableViewCell

- (id)initWithStyle:(TUITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.separatorStyle = TUITableViewCellSeparatorStyleEtched;
		
		// Set up the alternating cell color scheme.
		self.backgroundColor = [NSColor colorWithCalibratedWhite:0.97 alpha:1.0f];
		self.highlightColor = [NSColor colorWithCalibratedWhite:0.87 alpha:1.0f];
		self.selectionColor = [NSColor colorWithCalibratedWhite:0.77 alpha:1.0f];
		self.alternateBackgroundColor = [NSColor colorWithCalibratedWhite:0.92 alpha:1.0f];
		self.alternateHighlightColor = [NSColor colorWithCalibratedWhite:0.82 alpha:1.0f];
		self.alternateSelectionColor = [NSColor colorWithCalibratedWhite:0.72 alpha:1.0f];
		
		// Draw a gradient when the cell is highlighted.
		// Take into account that the cell might be highlighted if alternate.
		self.drawHighlightedBackground = ^(TUIView *view, CGRect rect) {
			TUITableViewCell *cell = (id)view;
			NSColor *alternateColor = cell.alternateHighlightColor ?: cell.alternateBackgroundColor;
			BOOL alternated = (alternateColor && (cell.indexPath.row % 2));
			
			[[[NSGradient alloc] initWithStartingColor:alternated ? alternateColor : cell.highlightColor
										   endingColor:cell.backgroundColor] drawInRect:rect angle:270.0f];
		};
		
		_actionButton = [TUIButton buttonWithType:TUIButtonTypeClear];
		self.actionButton.frame = CGRectMake(5.0f, 0.0f, 48.0f, 22.0f);
		self.actionButton.titleLabel.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
		self.actionButton.reversesTitleShadowWhenHighlighted = YES;
		
		self.actionButton.titleLabel.alignment = TUITextAlignmentCenter;
		self.actionButton.titleLabel.renderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
		self.actionButton.titleLabel.renderer.shadowBlur = 1.0f;
		self.actionButton.titleLabel.renderer.shadowColor = [[NSColor whiteColor] colorWithAlphaComponent:0.5];
		self.actionButton.titleLabel.renderer.shadowOffset = CGSizeMake(0, -1);
		
		[self.actionButton setTitle:@"TwUI" forState:TUIControlStateNormal];
		[self.actionButton setTitleColor:[NSColor blackColor] forState:TUIControlStateNormal];
		
		[self addSubview:self.actionButton];
		
		// Instead of using a TUILabel or TUITextField, let's take a little
		// course in the art of using a TUITextRenderer. It acts as a simple
		// text -> layer rendering mechanism class with tie-ins to TUIView,
		// but can achieve far more if used right (like TUITextView).
		_textRenderer = [[TUITextRenderer alloc] init];
		self.textRenderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
		self.textRenderer.shouldRefuseFirstResponder = YES;
		self.textRenderer.shadowBlur = 1.0f;
		self.textRenderer.shadowColor = [NSColor whiteColor];
		self.textRenderer.shadowOffset = CGSizeMake(0, 1);
		
		// Add the text renderer to the view so events get routed to it
		// properly. Text selection, dictionary popup, etc should just work.
		// You can add more than one.
		// The text renderer encapsulates an attributed string and a frame.
		// The attributed string in this case is set by setAttributedString:
		// which is configured by the table view delegate.  The frame needs to
		// be set before it can be drawn, we do that in drawRect: below.
		self.textRenderers = @[self.textRenderer];
		
		// Add in a standard Cocoa text field. We have to enclose this within
		// a TUIViewNSViewContainer, and we MUST adjust only the frame of that
		// container, and not the text field's itself.
		NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 180, 91, 22)];
		[textField.cell setUsesSingleLineMode:YES];
		[textField.cell setScrollable:YES];
		
		self.textFieldContainer = [[TUIViewNSViewContainer alloc] initWithNSView:textField];
		self.textFieldContainer.backgroundColor = [NSColor blueColor];
		[self addSubview:self.textFieldContainer];
	}
	
	return self;
}

// Create a simple attributed string setter/getter to the text renderer.
- (NSAttributedString *)attributedString {
	return self.textRenderer.attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
	self.textRenderer.attributedString = attributedString;
	[self setNeedsDisplay];
}

// When we subclass any view and override the layout or drawing methods,
// it's a must to insert a super call before doing your own thing.
- (void)layoutSubviews {
	[super layoutSubviews];
	
	// Set the text field container's frame (NOT THE TEXT FIELD).
	CGSize textFieldSize = self.textFieldContainer.bounds.size;
	CGFloat textFieldLeft = CGRectGetWidth(self.bounds) - textFieldSize.width - 16;
	self.textFieldContainer.frame = CGRectMake(textFieldLeft, 14, textFieldSize.width, textFieldSize.height);
	
	CGRect buttonRect = self.actionButton.frame;
	buttonRect.origin.y = (self.bounds.size.height / 2) - (buttonRect.size.height / 2);
	self.actionButton.frame = buttonRect;
	
	// Set the text renderer's frame.
	CGRect textRect = self.bounds;
	textRect.origin.x += 10.0f + buttonRect.size.width;
	textRect.size.width -= (self.textFieldContainer.frame.size.width + 16) + 20.0f;
	self.textRenderer.frame = textRect;
}

// Note that we only override the drawRect: to add in a call to
// let the text renderer draw as well. For TUITableView, customization
// is preferrably left to the overridable drawing methods - not this.
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[self.textRenderer draw];
}

@end
