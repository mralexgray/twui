
#import "ExampleTableViewCell.h"

@implementation ExampleTableViewCell

- (id)initWithStyle:(TUITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	// Set up the alternating row "look". Very slick, clean look. Just by
	// setting up a few colors (and optionally a few styles, and if we
	// need more, overridable methods) we can achieve whatever look we want.
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.950 green:0.219 blue:0.251 alpha:1.000];
	self.highlightColor = [NSColor colorWithCalibratedRed:0.800 green:1.000 blue:0.000 alpha:1.000];
	self.selectionColor = [NSColor colorWithCalibratedRed:0.000 green:0.200 blue:0.400 alpha:1.000];
	self.alternateBackgroundColor = [NSColor magentaColor];
	self.alternateHighlightColor = [NSColor colorWithCalibratedWhite:0.82 alpha:1.0f];
	self.alternateSelectionColor = [NSColor colorWithCalibratedWhite:0.72 alpha:1.0f];
	
	// Instead of using a TUILabel or TUITextField, let's take a little
	// course in the art of using a TUITextRenderer. It acts as a simple
	// text -> layer rendering mechanism class with tie-ins to TUIView,
	// but can achieve far more if used right (like TUITextView).
	_textRenderer = [[TUITextRenderer alloc] init];
	_textRenderer.verticalAlignment = TUITextVerticalAlignmentMiddle;
	_textRenderer.shouldRefuseFirstResponder = YES;
	_textRenderer.shadowBlur = 1.0f;
	_textRenderer.shadowColor = [NSColor whiteColor];
	_textRenderer.shadowOffset = CGSizeMake(0, 1);
	
	// Add the text renderer to the view so events get routed to it
	// properly. Text selection, dictionary popup, etc should just work.
	// You can add more than one.
	// The text renderer encapsulates an attributed string and a frame.
	// The attributed string in this case is set by setAttributedString:
	// which is configured by the table view delegate.  The frame needs to
	// be set before it can be drawn, we do that in drawRect: below.
	self.textRenderers = @[_textRenderer];
	
	// Add in a standard Cocoa text field. We have to enclose this within
	// a TUIViewNSViewContainer, and we MUST adjust only the frame of that
	// container, and not the text field's itself.
	NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 180, 91, 22)];
	[textField.cell setUsesSingleLineMode:YES];
	[textField.cell setScrollable:YES];
	[textField setDrawsBackground:NO];

	self.textFieldContainer = [[TUIViewNSViewContainer alloc] initWithNSView:textField];
	self.textFieldContainer.backgroundColor = [NSColor blueColor];
	[self addSubview:self.textFieldContainer];
	return self;
}

// Create a simple attributed string setter/getter to the text renderer.
- (NSAttributedString *)attributedString {
	return _textRenderer.attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
	_textRenderer.attributedString = attributedString;
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
	
	// Set the text renderer's frame. Take indentation into account.
	CGFloat indentation = 10.0f;
	CGRect textRect = self.bounds;
	textRect.origin.x += indentation;
	textRect.size.width -= (self.textFieldContainer.frame.size.width + 16) + (indentation * 2);
	_textRenderer.frame = textRect;
}

// Note that we only override the drawRect: to add in a call to
// let the text renderer draw as well. For TUITableView, customization
// is preferrably left to the overridable drawing methods - not this.
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[_textRenderer draw];
}

@end
