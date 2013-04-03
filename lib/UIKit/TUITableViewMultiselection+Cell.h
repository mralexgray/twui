/*

 */

#import "TUITableView.h"

/**
 * @brief Exposes some internal table view methods to cells (primarily for drag-to-reorder support)
 */
@interface TUITableView (MultiCell)

-(void)__mouseDownInMultipleCells:(TUITableViewCell *)cell offset:(CGPoint)offset event:(NSEvent *)event;
-(void)__mouseUpInMultipleCells:(TUITableViewCell *)cell offset:(CGPoint)offset event:(NSEvent *)event;
-(void)__mouseDraggedMultipleCells:(TUITableViewCell *)cell offset:(CGPoint)offset event:(NSEvent *)event;

-(BOOL)__isDraggingMultipleCells;
-(void)__beginDraggingMultipleCells:(TUITableViewCell *)cell offset:(CGPoint)offset location:(CGPoint)location;
-(void)__updateDraggingMultipleCells:(TUITableViewCell *)cell offset:(CGPoint)offset location:(CGPoint)location;
-(void)__endDraggingMultipleCells:(TUITableViewCell *)cell offset:(CGPoint)offset location:(CGPoint)location;

@end

