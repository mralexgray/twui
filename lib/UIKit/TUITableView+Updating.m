//
//  TUITableView+Updating.m
//  TwUI
//
//  Created by Adam Kirk on 6/22/13.
//
//

#import "TUITableView+Updating.h"
#import "TUITableViewCell+Private.h"
#import "UIView+MTAnimation.h"
#import <objc/runtime.h>


static const char cellsToBeAnimatedKey;
static const char updatingKey;


@interface TUITableView ()
@property (nonatomic, strong) NSMutableArray *cellsToBeAnimated;
@property (nonatomic, assign) BOOL           updating;
@end


@implementation TUITableView (Updating)

- (void)__beginUpdates
{
    self.updating = YES;
    [self enumerateIndexPathsUsingBlock:^(NSIndexPath *indexPath, BOOL *stop) {
        TUITableViewCell *cell  = [self cellForRowAtIndexPath:indexPath];
        cell.updateEndFrame     = cell.frame;
        cell.updateEndAlpha     = cell.alpha;
    }];
}

- (void)__endUpdates
{
    self.updating = NO;
    [TUIView mt_animateViews:self.cellsToBeAnimated duration:0.25 timingFunction:kMTEaseOutSine animations:^{
        for (TUITableViewCell *cell in self.cellsToBeAnimated) {
            cell.frame = cell.updateEndFrame;
            cell.alpha = cell.updateEndAlpha;
        }
    } completion:^{
        for (TUITableViewCell *cell in self.cellsToBeAnimated) {
            if (cell.animationProp) {
                [cell removeFromSuperview];
            }
        }
        [self.cellsToBeAnimated removeAllObjects];
        [self reloadData];
    }];
}

- (void)__insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation
{
    NSArray *sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];

    for (NSIndexPath *currentPath in sortedIndexPaths) {

        CGFloat newCellHeight = [_delegate tableView:self heightForRowAtIndexPath:currentPath];

        [self enumerateIndexPathsUsingBlock:^(NSIndexPath *indexPath, BOOL *stop) {

            // if this index path is in the place of or below where we want to insert, move the cell down
            NSComparisonResult result = [indexPath compare:currentPath];
            if (result != NSOrderedAscending || result == NSOrderedSame) {
                TUITableViewCell *currentCell = [self cellForRowAtIndexPath:indexPath];
                if (currentCell) {
                    CGRect r                    = self.updating ? currentCell.updateEndFrame : currentCell.frame;
                    r.origin.y                  -= newCellHeight;
                    currentCell.updateEndFrame  = r;
                    currentCell.updateEndAlpha  = 1;
                    [self.cellsToBeAnimated addObject:currentCell];
                }
            }
        }];

        TUITableViewCell *newCell   = [_dataSource tableView:self cellForRowAtIndexPath:currentPath];
        newCell.frame               = [self insertStartFrameForIndexPath:currentPath rowAnimation:animation];
        newCell.alpha               = animation == TUITableViewRowAnimationFade ? 0 : 1;
        newCell.updateEndFrame      = [self insertEndFrameForIndexPath:currentPath];
        newCell.updateEndAlpha      = 1;
        newCell.animationProp       = YES;
        [self addSubview:newCell];

        [self.cellsToBeAnimated addObject:newCell];
    }
}

- (void)__deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation
{
    NSArray *sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];

    for (NSIndexPath *currentPath in sortedIndexPaths) {

        TUITableViewCell *cell      = [self cellForRowAtIndexPath:currentPath];
        CGFloat deletingRowHeight   = cell.frame.size.height;

        [self enumerateIndexPathsUsingBlock:^(NSIndexPath *indexPath, BOOL *stop) {

            // if this index path is in the place of or below where we want to remove, move it up
            NSComparisonResult result = [indexPath compare:currentPath];
            if (result != NSOrderedAscending || result == NSOrderedSame) {
                TUITableViewCell *currentCell = [self cellForRowAtIndexPath:indexPath];
                if (currentCell) {
                    CGRect r            = self.updating ? currentCell.updateEndFrame : currentCell.frame;
                    r.origin.y         += deletingRowHeight;
                    currentCell.updateEndFrame = r;
                    currentCell.updateEndAlpha = 1;
                    [self.cellsToBeAnimated addObject:currentCell];
                }
            }
        }];

        NSIndexPath *lastIndexPath = [[[_visibleItems allKeys] sortedArrayUsingSelector:@selector(compare:)] lastObject];
        if (lastIndexPath) {
            CGFloat heightToCompensateFor = deletingRowHeight;
            NSInteger count = 0;
            while (true) {
                NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row + ++count
                                                                inSection:lastIndexPath.section];

                if (nextIndexPath.row       >= [self numberOfRowsInSection:nextIndexPath.section]) break;
                if (nextIndexPath.section   >= [self numberOfSections]) break;

                TUITableViewCell *compensationCell  = [_delegate tableView:self cellForRowAtIndexPath:nextIndexPath];
                if (!compensationCell) break;

                CGRect frame                        = [self rectForRowAtIndexPath:nextIndexPath];
                compensationCell.frame              = frame;
                compensationCell.alpha              = 1;
                frame.origin.y                      += deletingRowHeight;
                compensationCell.updateEndFrame     = frame;
                compensationCell.updateEndAlpha     = 1;
                compensationCell.animationProp      = YES;
                [self addSubview:compensationCell];
                [self.cellsToBeAnimated addObject:compensationCell];
                heightToCompensateFor               -= compensationCell.frame.size.height;
                if (heightToCompensateFor <= 0) break;
            }
        }

        cell.updateEndFrame = [self deleteEndFrameForIndexPath:currentPath rowAnimation:animation];
        cell.updateEndAlpha = animation == TUITableViewRowAnimationFade ? 0 : 1;

        [self.cellsToBeAnimated addObject:cell];
    }
}




#pragma mark - Private

- (CGRect)insertStartFrameForIndexPath:(NSIndexPath *)indexPath rowAnimation:(TUITableViewRowAnimation)animation
{
    CGRect r = [self insertEndFrameForIndexPath:indexPath];

    if (animation == TUITableViewRowAnimationLeft) {
        r.origin.x -= r.size.width;
    }
    else if (animation == TUITableViewRowAnimationRight) {
        r.origin.x += r.size.width;
    }

    return r;
}

- (CGRect)insertEndFrameForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height      = [_delegate tableView:self heightForRowAtIndexPath:indexPath];
    CGRect r            = [self rectForRowAtIndexPath:indexPath];
    r.origin.y          = r.origin.y + (r.size.height - height);
    r.size.height       = height;
    return r;
}

- (CGRect)deleteEndFrameForIndexPath:(NSIndexPath *)indexPath rowAnimation:(TUITableViewRowAnimation)animation
{
    CGRect r = [self rectForRowAtIndexPath:indexPath];

    if (animation == TUITableViewRowAnimationRight) {
        r.origin.x += r.size.width;
    }
    else if (animation == TUITableViewRowAnimationLeft) {
        r.origin.x -= r.size.width;
    }

    return r;
}

- (NSMutableArray *)cellsToBeAnimated
{
    NSMutableArray *cells = objc_getAssociatedObject(self, &cellsToBeAnimatedKey);
    if (!cells) {
        cells = [NSMutableArray new];
        objc_setAssociatedObject(self, &cellsToBeAnimatedKey, cells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cells;
}

- (void)setUpdating:(BOOL)updating
{
    objc_setAssociatedObject(self, &updatingKey, @(updating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)updating
{
    NSNumber *n = objc_getAssociatedObject(self, &updatingKey);
    return n ? [n boolValue] : NO;
}



@end
