/*

 */

#import "ExampleTableViewCell.h"

@implementation ExampleTableViewCell
@synthesize file = _file;

- (id)initWithStyle:(TUITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		textRenderer = [[TUITextRenderer alloc] init];
		
		/*
		 Add the text renderer to the view so events get routed to it properly.
		 Text selection, dictionary popup, etc should just work.
		 You can add more than one.
		 
		 The text renderer encapsulates an attributed string and a frame.
		 The attributed string in this case is set by setAttributedString:
		 which is configured by the table view delegate.  The frame needs to be 
		 set before it can be drawn, we do that in drawRect: below.
		 */
		self.textRenderers = [NSArray arrayWithObjects:textRenderer, nil];
//		self.file = [AZFile instance];
		NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 180, 91, 22)];
		[textField.cell setUsesSingleLineMode:YES];
		[textField.cell setScrollable:YES];

<<<<<<< HEAD:ExampleProject/ConcordeExample/ExampleTableViewCell.m
//		self.textFieldContainer = [[TUIViewNSViewContainer alloc] initWithNSView:textField];
//		self.textFieldContainer.backgroundColor = [TUIColor colorWithNSColor:RANDOMCOLOR]; //blueColor];
//		[self addSubview:self.textFieldContainer];
=======
		self.textFieldContainer = [[TUIViewNSViewContainer alloc] initWithNSView:textField];
		self.textFieldContainer.backgroundColor = [NSColor blueColor];
		[self addSubview:self.textFieldContainer];
>>>>>>> upstream/master:ExampleProject/Example/ExampleTableViewCell.m
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize textFieldSize = self.textFieldContainer.bounds.size;
	CGFloat textFieldLeft = CGRectGetWidth(self.bounds) - textFieldSize.width - 16;

	self.textFieldContainer.frame = CGRectMake(textFieldLeft, 14, textFieldSize.width, textFieldSize.height);
}

- (NSAttributedString *)attributedString
{
	return textRenderer.attributedString;
}

-(void) setFile:(AZFile *)file {
	_file = file;
//	NSLog(@"afile: %@", _file.propertiesPlease);
//	NSLog(@"afilecolor: %@", [[_file.colors objectAtNormalizedIndex:0]propertiesPlease]);

	TUIAttributedString *s = [TUIAttributedString stringWithString:file.name];//[NSString stringWithFormat:@"example cell %d", (int)indexPath.row]];
	s.color = [TUIColor colorWithNSColor:file.color.contrastingForegroundColor];
	s.font = [TUIFont fontWithName:@"Ubuntu Mono Bold" size:18];//exampleFont1;
//	[s setFont:exampleFont2 inRange:NSMakeRange(8, 4)]; // make the word "cell" bold
	self.attributedString = s;
	[self setNeedsDisplay];
//	self.attributedString = file.name;
}
- (void)setAttributedString:(NSAttributedString *)attributedString
{
	textRenderer.attributedString = attributedString;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGRect b = self.bounds;
//	[TUINSView absetIsOpaque:NO];
//	CGContextRef ctx = TUIGraphicsGetCurrentContext();
//	[NSGraphicsContext saveGraphicsState];
		NSColor *fff = self.file.color;
			if(self.selected) {
		// selected background
//		CGContextSetRGBFillColor(ctx, .87, .87, .87, 1);
//		CGContextFillRect(ctx, b);
	} else {
		// light gray background
//		NSLog(@"COLOR: %@",[_file propertiesPlease]);
//		CGColorRef colore = [[TUIColor colorWithCGColor:[[self.file.colors objectAtNormalizedIndex:0]CGColor]]CGColor];
//		CGContextSetRGBFillColor(ctx, .97, .97, .97, 1);

//		[NSGraphicsContext saveGraphicsState];
//		TUICreateOpaqueGraphicsContext(self.bounds.size);

		NSBezierPath *ppp = [NSBezierPath bezierPathWithRect:self.bounds];
//		[ppp fillGradientFrom:self.file.color to:self.file.color.darker angle:270];
		[ppp fillGradientFrom:fff	 to:fff.darker.darker angle:270];
//		CGColorRef g = [(NSColor*)[[self.file.colors objectAtNormalizedIndex:0]valueForKey:@"color"] CGColor];
//		NSColor*j = [[self.file.colors objectAtNormalizedIndex:0]valueForKey:@"color"];
//		[NSGraphicsContext restoreGraphicsState];
//		CGColorRef rambo = CGColorRetain([self.file.color CGColor]);

//		CGContextSetFillColorWithColor(ctx, rambo);// [self.file.color CGColor]);// , g.greenComponent, g.blueComponent, 1);
//		CGContextSetFillColorWithColor
//		CGColorRef bb =	CGColorCreateGenericRGB(j.redComponent, j.greenComponent, j.blueComponent, 1);
//		CGContextSetRGBFillColor(ctx, 1,0,0,1);// <#CGFloat green#>, <#CGFloat blue#>, <#CGFloat alpha#>) FillColorWithColor(ctx,cgRED);
//		CGContextFillRect(ctx, b);
		//		 [(NSColor*)[[self.file.colors objectAtNormalizedIndex:0 ]valueForKey:@"color" ] CGColor]);// [[[NSColor fengshui]randomElement]CGColor]);
//		CGContextFillRect(ctx, b);
//		[NSGraphicsContext restoreGraphicsState];
		// emboss
//		CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.9); // light at the top
//		CGContextFillRect(ctx, CGRectMake(0, b.size.height-1, b.size.width, 1));
//		CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.08); // dark at the bottom
//		CGContextFillRect(ctx, CGRectMake(0, 0, b.size.width, 1));
	}

	[[self.file.image coloredWithColor:WHITE ] drawCenteredinRect:NSMakeRect(b.size.width - b.size.height - 8,4,b.size.height-8,b.size.height-8)operation:NSCompositeSourceOver fraction:1];// drawAtPoint:NSZeroPoint fromRect:b operation:NSCompositeSourceOver fraction:1];
	// text
//	CGRect textRect = CGRectOffset(b, 15, -15);
	textRenderer.frame = b;//textRect; // set the frame so it knows where to draw itself
	[textRenderer draw];
	
}

@end
