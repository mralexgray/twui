
#import "TUIView.h"

/**
 * @brief An optional base for section header views
 * 
 * A view used as a section header may optionally extend this class,
 * in which case the view will recieve messages about header state.
 */
@interface TUITableViewSectionHeader : TUIView {
  
  BOOL  _isPinnedToViewport;
  
}

-(void)headerWillBecomePinned;
-(void)headerWillBecomeUnpinned;

@property (readwrite, assign, getter=isPinnedToViewport) BOOL pinnedToViewport;

@end
