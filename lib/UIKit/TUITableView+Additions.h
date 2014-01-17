
#import "TUITableView.h"

typedef void (^TUITableViewInitializationBlock)(id cell);

@interface TUITableView (Additions)

- (TUITableViewCell *)ab_reusableCellOfClass:(Class)cellClass identifier:(NSString *)identifier initializationBlock:(TUITableViewInitializationBlock)block;

@end

#define reusableTableCellOfClassWithBlock(TABLE, CLASS, BLOCK) \
	(CLASS *)[(TABLE) ab_reusableCellOfClass:[CLASS class] identifier:@"ab." @#CLASS initializationBlock:BLOCK]

#define reusableTableCellOfClass(TABLE, CLASS) \
(CLASS *)[(TABLE) ab_reusableCellOfClass:[CLASS class] identifier:@"ab." @#CLASS initializationBlock:nil]
