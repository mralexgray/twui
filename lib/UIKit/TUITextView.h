/*

 */

#import "TUIControl.h"
#import "TUIGeometry.h"
#import "TUIAttributedString.h"

@class TUITextEditor;
@class NSFont;

@protocol TUITextViewDelegate;

@interface TUITextView : TUIControl {
	id<TUITextViewDelegate> __unsafe_unretained delegate;
	TUIViewDrawRect drawFrame;
	
	NSString *placeholder;
	TUITextRenderer *placeholderRenderer;
	
	NSFont *font;
	NSColor *textColor;
	TUITextAlignment textAlignment;
	BOOL editable;
	
	BOOL spellCheckingEnabled;
	NSInteger lastCheckToken;
	NSArray *lastCheckResults;
	NSTextCheckingResult *selectedTextCheckingResult;
	BOOL autocorrectionEnabled;
	NSMutableDictionary *autocorrectedResults;

	TUIEdgeInsets contentInset;

	TUITextEditor *renderer;
	TUIView *cursor;
	
	CGRect _lastTextRect;
	
	struct {
		unsigned int delegateTextViewDidChange:1;
		unsigned int delegateDoCommandBySelector:1;
		unsigned int delegateWillBecomeFirstResponder:1;
		unsigned int delegateDidBecomeFirstResponder:1;
		unsigned int delegateWillResignFirstResponder:1;
		unsigned int delegateDidResignFirstResponder:1;
	} _textViewFlags;
}

- (Class)textEditorClass;

@property (nonatomic, unsafe_unretained) id<TUITextViewDelegate> delegate;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) NSFont *font;
@property (nonatomic, strong) NSColor *textColor;
@property (nonatomic, strong) NSColor *cursorColor;
@property (nonatomic, assign) CGFloat cursorWidth;
@property (nonatomic, assign) TUITextAlignment textAlignment;
@property (nonatomic, assign) TUIEdgeInsets contentInset;

@property (nonatomic, assign) NSRange selectedRange;
@property (nonatomic, assign, getter=isEditable) BOOL editable;
@property (nonatomic, assign, getter=isSpellCheckingEnabled) BOOL spellCheckingEnabled;
@property (nonatomic, assign, getter=isAutocorrectionEnabled) BOOL autocorrectionEnabled;

@property (nonatomic, copy) TUIViewDrawRect drawFrame;

- (BOOL)hasText;

- (BOOL)doCommandBySelector:(SEL)selector;

@end


@protocol TUITextViewDelegate <NSObject>

@optional

- (void)textViewDidChange:(TUITextView *)textView;
- (BOOL)textView:(TUITextView *)textView doCommandBySelector:(SEL)commandSelector; // return YES if the implementation consumes the selector, NO if it should be passed up to super

- (void)textViewWillBecomeFirstResponder:(TUITextView *)textView;
- (void)textViewDidBecomeFirstResponder:(TUITextView *)textView;
- (void)textViewWillResignFirstResponder:(TUITextView *)textView;
- (void)textViewDidResignFirstResponder:(TUITextView *)textView;

@end


extern TUIViewDrawRect TUITextViewSearchFrame(void);
extern TUIViewDrawRect TUITextViewSearchFrameOverDark(void);
extern TUIViewDrawRect TUITextViewStandardFrame(void);
