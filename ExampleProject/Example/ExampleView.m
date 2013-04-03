/*

 */

#import "ExampleView.h"
#import "ExampleTableViewController.h"
#import "ExampleAppDelegate.h"

#define TAB_HEIGHT 60

@implementation ExampleView

- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame])) {
		self.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
		
		CGRect b = self.bounds;
		b.origin.y += TAB_HEIGHT;
		b.size.height -= TAB_HEIGHT;
		
		ExampleTableViewController *tableViewController = [[ExampleTableViewController alloc] initWithNibName:nil bundle:nil];
        ExampleTableViewController *tableViewController1 = [[ExampleTableViewController alloc] initWithNibName:nil bundle:nil];
		_navigationController = [[TUICarouselNavigationController alloc] initWithViewControllers:@[tableViewController, tableViewController1]];
        _navigationController.delegate = self;
		[self addSubview:_navigationController.view];
        
//		[_navigationController.view addLayoutConstraint:[TUILayoutConstraint constraintWithAttribute:TUILayoutConstraintAttributeWidth relativeTo:@"superview" attribute:TUILayoutConstraintAttributeWidth]];
//		[_navigationController.view addLayoutConstraint:[TUILayoutConstraint constraintWithAttribute:TUILayoutConstraintAttributeHeight relativeTo:@"superview" attribute:TUILayoutConstraintAttributeHeight offset:-TAB_HEIGHT]];
//		[_navigationController.view addLayoutConstraint:[TUILayoutConstraint constraintWithAttribute:TUILayoutConstraintAttributeMinX relativeTo:@"superview" attribute:TUILayoutConstraintAttributeMinX]];
//		[_navigationController.view addLayoutConstraint:[TUILayoutConstraint constraintWithAttribute:TUILayoutConstraintAttributeMinY relativeTo:@"superview" attribute:TUILayoutConstraintAttributeMinY offset:TAB_HEIGHT]];
        _navigationController.couldUseSlideEvent = YES;
        
        _navigationController.view.layout = ^(TUIView *v) {
            TUIView *superview = v.superview;
            CGRect rect = superview.bounds;
            rect.origin.y = TAB_HEIGHT;
            rect.size.height -= TAB_HEIGHT;
            
            return rect;
        };
		
/*		 Note by default scroll views (and therefore table views) don't have clipsToBounds enabled.  Set only if needed.  In this case
		 we don't, so it could potentially save us some rendering costs.		 */
		_tabBar = [ExampleTabBar.alloc initWithNumberOfTabs:5];
		_tabBar.delegate = self;
		// It'd be easier to just use .autoresizingmask, but for demonstration we'll use ^layout.
		_tabBar.layout = ^(TUIView *v) { // 'v' in this case will point to the same object as 'tabs'
			TUIView *superview = v.superview; // note we're using the passed-in 'v' argument, rather than referencing 'tabs' in the block, this avoids a retain cycle without jumping through hoops
			CGRect rect = superview.bounds; // take the superview bounds
			rect.size.height = 60;// TAB_HEIGHT; // only take up the bottom 60px
			WARN($(@"%@",AZString(rect)));
			return rect;
		};
		[self addSubview:_tabBar];
		
		for(TUIView *tabView in _tabBar.tabViews) {		// setup individual tabs

			tabView.backgroundColor = [NSColor clearColor]; // will also set opaque=NO
			
			// let's just teach the tabs how to draw themselves right here - no need to subclass anything
			tabView.drawRect = ^(TUIView *v, CGRect rect) {
				CGRect b = v.bounds;
				ExampleTabBar *bar = (ExampleTabBar *)v.superview;
				CGContextRef ctx = TUIGraphicsGetCurrentContext();

				NSIMG *image = [[NSIMG imageNamed:$(@"%ld.pdf",v.tag)]scaledToMax:AZMinDim(rect.size) * .7];//NSIMG.randomMonoIcon;//[NSIMG imageNamed:@"1.pdf"];
				CGRect imageRect = ABIntegralRectWithSizeCenteredInRect([image size], b);

				if([bar isHighlightingTab:v]) {
					
					// first draw a slight white emboss below
					CGContextSaveGState(ctx);
					
					CGImageRef cgImage = [image CGImageForProposedRect:&imageRect context:nil hints:nil];
					CGContextClipToMask(ctx, CGRectOffset(imageRect, 0, -1), cgImage);

					CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.5);
					CGContextFillRect(ctx, b);
					CGContextRestoreGState(ctx);

					// replace image with a dynamically generated fancy inset image
					// 1. use the image as a mask to draw a blue gradient
					// 2. generate an inner shadow image based on the mask, then overlay that on top
					image = [NSIMG tui_imageWithSize:imageRect.size drawing:^(CGContextRef ctx) {
						CGRect r;
						r.origin = CGPointZero;
						r.size = imageRect.size;
						
						CGContextClipToMask(ctx, r, image.tui_CGImage);
						CGContextDrawLinearGradientBetweenPoints(ctx, CGPointMake(0, r.size.height), (CGFloat[]){0,0,1,1}, CGPointZero, (CGFloat[]){0,0.6,1,1});
						NSIMG *innerShadow = [image tui_innerShadowWithOffset:CGSizeMake(0, -1) radius:3.0 color:[NSColor blackColor] backgroundColor:[NSColor cyanColor]];
						CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
						CGContextDrawImage(ctx, r, innerShadow.tui_CGImage);
					}];
				}

				[image drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0]; // draw 'image' (might be the regular one, or the dynamically generated one)

				// draw the index
				TUIAttributedString *s = [TUIAttributedString stringWithString:[NSString stringWithFormat:@"%ld", v.tag]];
				[s ab_drawInRect:CGRectOffset(imageRect, imageRect.size.width, -15)];
			};
		}
	}
	return self;
}


- (void)tabBar:(ExampleTabBar *)tabBar didSelectTab:(NSInteger)index
{
	NSLog(@"selected tab %ld", index);
	[AZSHAREDAPP.delegate performSelector:@selector(showAltView:)];
//	if(index == [[tabBar tabViews] count] - 1){
//	  NSLog(@"popping nav controller...");
//	  [self.navigationController slideToViewController:self.navigationController.nextViewController animated:YES];
//	}
}


@end
