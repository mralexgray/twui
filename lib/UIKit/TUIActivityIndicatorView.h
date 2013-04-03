/*

 */

#import "TUIView.h"

typedef enum TUIActivityIndicatorViewStyle : NSUInteger {
	
	// The standard white style of indicator.
	TUIActivityIndicatorViewStyleWhite,
	
	// The standard gray style of indicator.
	TUIActivityIndicatorViewStyleGray,
	
	// The standard black style of indicator.
	TUIActivityIndicatorViewStyleBlack
} TUIActivityIndicatorViewStyle;

@interface TUIActivityIndicatorView : TUIView

// The basic appearance of the activity indicator.
// The default value is TUIActivityIndicatorViewStyleGray.
@property (nonatomic, assign) TUIActivityIndicatorViewStyle activityIndicatorStyle;

// Controls whether the receiver is hidden when the animation is stopped.
// If the value of this property is YES (default), the indicator sets
// the indicator layer's hidden property to YES when is not animating.
// If the hidesWhenStopped property is NO, the indicator layer is not hidden
// when animation stops.
@property (nonatomic, assign) BOOL hidesWhenStopped;

// Returns YES if the indicator is currently animating, otherwise NO.
@property (nonatomic, readonly, getter = isAnimating) BOOL animating;

// Initializes the activity indicator with the style of the indicator.
// You can set and retrieve the style of a activity indicator through
// the activityIndicatorViewStyle property. See TUIActivityIndicatorViewStyle
// for descriptions of the style constants. 
- (id)initWithActivityIndicatorStyle:(TUIActivityIndicatorViewStyle)style;

// Initializes the activity indicator with both style and frame.
- (id)initWithFrame:(CGRect)frame activityIndicatorStyle:(TUIActivityIndicatorViewStyle)style;

// Starts the animation of the indicator. It is animated to indicate
// indeterminate progress. It is animated until stopAnimating is called.
- (void)startAnimating;

// Stops the animation of the indicator. When animation is stopped, the
// indicator is hidden if hidesWhenStopped is YES.
- (void)stopAnimating;

@end
