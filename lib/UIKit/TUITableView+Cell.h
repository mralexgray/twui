
#import "TUITableView.h"

/**
 * @brief Exposes some internal table view methods to cells (primarily for drag-to-reorder support)
 */
@interface TUITableView (Cell)

-(void)__mouseDownInCell:(TUITableViewCell *)cell offset:(CGPoint)offset event:(NSEvent *)event;
-(void)__mouseUpInCell:(TUITableViewCell *)cell offset:(CGPoint)offset event:(NSEvent *)event;
-(void)__mouseDraggedCell:(TUITableViewCell *)cell offset:(CGPoint)offset event:(NSEvent *)event;

-(BOOL)__isDraggingCell;
-(void)__beginDraggingCell:(TUITableViewCell *)cell offset:(CGPoint)offset location:(CGPoint)location;
-(void)__updateDraggingCell:(TUITableViewCell *)cell offset:(CGPoint)offset location:(CGPoint)location;
-(void)__endDraggingCell:(TUITableViewCell *)cell offset:(CGPoint)offset location:(CGPoint)location;

@end

