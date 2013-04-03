/*

 */

#import <Foundation/Foundation.h>

@class TUINSView;

@interface TUINSView (Hyperfocus)

- (void)hyperFocus:(TUIView *)focusView completion:(void(^)(BOOL cancelled))completion;
- (void)endHyperFocus:(BOOL)cancel;

@end
