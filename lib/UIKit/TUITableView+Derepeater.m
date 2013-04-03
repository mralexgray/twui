/*

 */

#import "TUITableView.h"

@implementation TUITableView (Derepeater)

- (BOOL)derepeaterEnabled
{
	return _tableFlags.derepeaterEnabled;
}

- (void)setDerepeaterEnabled:(BOOL)s
{
	_tableFlags.derepeaterEnabled = s;
}

- (void)_updateDerepeaterViews
{
	CGFloat padding = 7;
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	NSInteger zIndex = 5000;
	CGRect visibleRect = [self visibleRect];
	NSString *lastIdentifier = nil;
	TUIView *previousView = nil;
	CGFloat groupHeight = 0.0;
	
	for(TUITableViewCell<ABDerepeaterTableViewCell> *cell in [self sortedVisibleCells]) {
		zIndex--;
		cell.layer.zPosition = zIndex;
		CGRect cellFrame = cell.frame;
		
		NSString *identifier = [cell derepeaterIdentifier];
		TUIView *derepeaterView = [cell derepeaterView];
		if([identifier isEqual:lastIdentifier]) {
			derepeaterView.hidden = YES;
			groupHeight += cellFrame.size.height;
		} else {
			// make sure previous cell isn't too far down
			if(previousView) {
				CGRect f = previousView.frame;
				CGFloat min = -groupHeight + padding;
				if(f.origin.y < min)
					f.origin.y = min;
				
				previousView.frame = f;
				previousView = nil;
			}
			
			groupHeight = 0.0;
			previousView = derepeaterView;
			
			derepeaterView.hidden = NO;
			CGRect f = derepeaterView.frame;
			f.origin.y = f.origin.y = cellFrame.size.height - f.size.height - padding;
			if(cellFrame.origin.y + cellFrame.size.height > visibleRect.origin.y + visibleRect.size.height)
				f.origin.y += (visibleRect.origin.y + visibleRect.size.height) - (cellFrame.origin.y + cellFrame.size.height);
			
			derepeaterView.frame = f;
			lastIdentifier = identifier;
		}
	}
	
	[CATransaction commit];
}

@end
