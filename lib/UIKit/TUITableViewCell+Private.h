#import "TUITableViewCell.h"
#import "TUITableView.h"

@interface TUITableViewCell ()

@property (nonatomic, assign) CGRect  updateEndFrame;
@property (nonatomic, assign) CGFloat updateEndAlpha;
@property (nonatomic, assign) BOOL    updateDeleted;

- (void)setFloating:(BOOL)f animated:(BOOL)animated display:(BOOL)display;

@end