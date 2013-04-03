/*

 */

#import "TUITextRenderer.h"

@interface TUITextEditor : TUITextRenderer <NSTextInputClient>
{
	NSTextInputContext *inputContext;
	NSMutableAttributedString *backingStore;
	NSRange markedRange;
	NSDictionary *defaultAttributes;
	NSDictionary *markedAttributes;
	BOOL wasValidKeyEquivalentSelector;
}

- (NSTextInputContext *)inputContext;
- (NSMutableAttributedString *)backingStore;

// Insert the standard Cut, Copy, and Paste menu items.
- (void)patchMenuWithStandardEditingMenuItems:(NSMenu *)menu;

@property (nonatomic, copy) NSString *text;

// To enable secure text entry on an editor class, or view,
// simply set this boolean to YES. Once it is secured, the
// drawingAttributedString will display only bullets, instead
// of the actual string value. Just set this to NO to disable.
@property (nonatomic, assign, getter = isSecure) BOOL secure;

@property (nonatomic, strong) NSDictionary *defaultAttributes;
@property (nonatomic, strong) NSDictionary *markedAttributes;

@property (nonatomic, assign) NSRange selectedRange;

/*
 * If NO: ignore key down, copy, and paste events while preserving click and tap responses.
 *
 * @note Automatically assumes value of owning TUITextView's (if any) property of the same name.
 * 
 */
@property (nonatomic, assign, getter = isEditable) BOOL editable;

- (void)insertText:(id)aString; // at cursor
- (void)insertText:(id)aString replacementRange:(NSRange)replacementRange;
- (void)deleteCharactersInRange:(NSRange)range;

@end
