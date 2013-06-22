//
//  TUITableView+Updating.m
//  TwUI
//
//  Created by Adam Kirk on 6/22/13.
//
//

#import "TUITableView+Updating.h"
#import "TUITableViewCell+Private.h"
#import <objc/runtime.h>


@implementation TUITableView (Updating)

- (void)__beginUpdates
{

}

- (void)__endUpdates
{

}

- (void)__insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation
{
    // begin animations
//    if(animate){
        [TUIView beginAnimations:NSStringFromSelector(_cmd) context:NULL];
//    }

    NSIndexPath *fromIndexPath  = [self _topVisibleIndexPath];
    NSIndexPath *toIndexPath    = [self _bottomVisibleIndexPath];

    for (NSIndexPath *currentPath in indexPaths) {

        TUITableViewCell *cell = [self cellForRowAtIndexPath:currentPath];

        // update section headers
        for(NSInteger i = fromIndexPath.section; i <= toIndexPath.section; i++){
            TUIView *headerView;
            if (currentPath.section < i && i <= cell.indexPath.section){
                // the current index path is above this section and this section is at or
                // below the origin index path; shift our header down to make room
                if((headerView = [self headerViewForSection:i]) != nil){
                    CGRect frame = [self rectForHeaderOfSection:i];
                    headerView.frame = CGRectMake(frame.origin.x, frame.origin.y - cell.frame.size.height, frame.size.width, frame.size.height);
                }
            }else if(currentPath.section >= i && i > cell.indexPath.section){
                // the current index path is at or below this section and this section is
                // below the origin index path; shift our header up to make room
                if((headerView = [self headerViewForSection:i]) != nil){
                    CGRect frame = [self rectForHeaderOfSection:i];
                    headerView.frame = CGRectMake(frame.origin.x, frame.origin.y + cell.frame.size.height, frame.size.width, frame.size.height);
                }
            }else{
                // restore the header to it's normal position
                if((headerView = [self headerViewForSection:i]) != nil){
                    headerView.frame = [self rectForHeaderOfSection:i];
                }
            }
        }

        // update rows
        [self enumerateIndexPathsFromIndexPath:fromIndexPath toIndexPath:toIndexPath withOptions:0 usingBlock:^(NSIndexPath *indexPath, BOOL *stop) {
            TUITableViewCell *displacedCell;
            if((displacedCell = [self cellForRowAtIndexPath:indexPath]) != nil && ![displacedCell isEqual:cell]){
                CGRect frame = [self rectForRowAtIndexPath:indexPath];
                CGRect target;

                if([indexPath compare:currentPath] != NSOrderedAscending){
                    // the visited index path is above the origin and below the current index path;
                    // shift the cell down by the height of the dragged cell
                    target = CGRectMake(frame.origin.x, frame.origin.y - cell.frame.size.height, frame.size.width, frame.size.height);
                }else{
                    // the visited cell is outside the affected range and should be returned to its
                    // normal frame
                    target = frame;
                }
                
                // only animate if we actually need to
                if(!CGRectEqualToRect(target, displacedCell.frame)){
                    displacedCell.frame = target;
                }
                
            }
        }];
    }

    // commit animations
//    if(animate){
        [TUIView commitAnimations];
//    }

}

- (void)__deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation
{

}




#pragma mark - Private

- (NSIndexPath *)_topVisibleIndexPath
{
	NSIndexPath *topVisibleIndex = nil;
	NSArray *v = [[_visibleItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
	if([v count])
		topVisibleIndex = [v objectAtIndex:0];
	return topVisibleIndex;
}

- (NSIndexPath *)_bottomVisibleIndexPath
{
	NSArray *v = [[_visibleItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return [v lastObject];
}



@end
