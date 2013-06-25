#import "TUITableViewCell.h"
#import "TUITableView.h"

@interface TUITableViewCell ()

@property (nonatomic, assign) CGRect  updateEndFrame;
@property (nonatomic, assign) CGFloat updateEndAlpha;
@property (nonatomic, assign) BOOL    animationProp; // cell is just used for animation and is destroyed after

- (void)setFloating:(BOOL)f animated:(BOOL)animated display:(BOOL)display;

@end