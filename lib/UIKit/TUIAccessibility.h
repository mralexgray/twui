
typedef uint64_t TUIAccessibilityTraits;

extern TUIAccessibilityTraits TUIAccessibilityTraitNone;
extern TUIAccessibilityTraits TUIAccessibilityTraitButton;
extern TUIAccessibilityTraits TUIAccessibilityTraitLink;
extern TUIAccessibilityTraits TUIAccessibilityTraitSearchField;
extern TUIAccessibilityTraits TUIAccessibilityTraitImage;
extern TUIAccessibilityTraits TUIAccessibilityTraitSelected;
extern TUIAccessibilityTraits TUIAccessibilityTraitPlaysSound;
extern TUIAccessibilityTraits TUIAccessibilityTraitStaticText;
extern TUIAccessibilityTraits TUIAccessibilityTraitSummaryElement;
extern TUIAccessibilityTraits TUIAccessibilityTraitNotEnabled;
extern TUIAccessibilityTraits TUIAccessibilityTraitUpdatesFrequently;


@interface NSObject (TUIAccessibility)

@property (nonatomic, assign) BOOL isAccessibilityElement;
@property (nonatomic, copy) NSString *accessibilityLabel;
@property (nonatomic, copy) NSString *accessibilityHint;
@property (nonatomic, copy) NSString *accessibilityValue;
@property (nonatomic, assign) TUIAccessibilityTraits accessibilityTraits;
@property (nonatomic, assign) CGRect accessibilityFrame;

@end
