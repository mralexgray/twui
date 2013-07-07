
#import "TUITextView.h"

@class TUIButton;

@interface TUITextField : TUITextView
{
	TUIButton *rightButton;
	
	@public
	struct {
		unsigned int delegateTextFieldShouldReturn:1;
		unsigned int delegateTextFieldShouldClear:1;
		unsigned int delegateTextFieldShouldTabToNext:1;
		unsigned int delegateTextFieldShouldTabToPrevious:1;
	} _textFieldFlags;
}

@property (nonatomic, strong) TUIButton *rightButton;

+ (void)setClearButtonImage:(NSImage *)clearButtonImage;
- (TUIButton *)clearButton;

@end

@protocol TUITextFieldDelegate <TUITextViewDelegate>

@optional

- (BOOL)textFieldShouldReturn:(TUITextField *)textField;
- (BOOL)textFieldShouldClear:(TUITextField *)textField;
- (BOOL)textFieldShouldTabToNext:(TUITextField *)textField;
- (BOOL)textFieldShouldTabToPrevious:(TUITextField *)textField;

@end
