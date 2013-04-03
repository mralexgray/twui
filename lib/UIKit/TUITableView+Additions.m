/*

 */

#import "TUITableView+Additions.h"

@implementation TUITableView (Additions)

- (TUITableViewCell *)ab_reusableCellOfClass:(Class)cellClass identifier:(NSString *)identifier initializationBlock:(TUITableViewInitializationBlock)block
{
	TUITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
	if(!cell) {
		cell = [[cellClass alloc] initWithStyle:TUITableViewCellStyleDefault reuseIdentifier:identifier];
		if(block != nil) block(cell);
	}
	return cell;
}

- (void)willChange;
{
    _tableFlags.layoutSubviewsReentrancyGuard = 1;
}

- (void)didChange;
{
    _tableFlags.layoutSubviewsReentrancyGuard = 0;
}

@end
