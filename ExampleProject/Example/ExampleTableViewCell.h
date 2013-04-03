/*

 */

//#import "TUIKit.h"


@interface ExampleTableViewCell : TUITableViewCell

@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, strong) TUIButton *button;
@property (nonatomic, strong) TUISlider *slider;
@property (nonatomic, strong) TUIView *textFieldContainer;
@property (nonatomic, strong, readonly) TUITextRenderer *textRenderer;
@property (nonatomic, assign) TUIView *backgroundView;

@end
