/*

 */

#import "TUIView.h"
#import "TUIAttributedString.h"

/*
 Check out TUITextRenderer, you probably want to use that to get
 subpixel AA and a flatter view heirarchy.
 */

@interface TUILabel : TUIView
@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) NSAttributedString	*attributedString;
@property(nonatomic, getter=isSelectable) BOOL selectable;
@property(nonatomic, readonly) TUITextRenderer *renderer;
@property(nonatomic, strong) NSFont *font;
@property(nonatomic, strong) NSColor *textColor;
@property(nonatomic, assign) TUITextAlignment alignment;
@property(nonatomic, assign) TUILineBreakMode lineBreakMode; 
@end
