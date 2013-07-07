
#import <TwUI/TUIKit.h>
@interface ExampleTableViewCell : TUITableViewCell

@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic, strong) TUIView *textFieldContainer;
@property (nonatomic, strong, readonly) TUITextRenderer *textRenderer;

@end
