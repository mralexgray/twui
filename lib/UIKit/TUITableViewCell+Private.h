#import "TUITableViewCell.h"
#import "TUITableView.h"

@interface TUITableViewCell ()

@property (nonatomic, assign) CGRect  updateEndFrame;
@property (nonatomic, assign) CGFloat updateEndAlpha;

- (void)setFloating:(BOOL)f animated:(BOOL)animated display:(BOOL)display;

@end