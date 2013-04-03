/*

 */

/*
 Some bit-rot here, Twitter for Mac feature that used this is currently on ice
 */

@class TUITableView;

@interface TUITableView (Derepeater)

@property (nonatomic, assign) BOOL derepeaterEnabled; // default is NO

@end

@protocol ABDerepeaterTableViewCell

@required

- (TUIView *)derepeaterView;
- (id)derepeaterIdentifier; // returned object should implement isEqual:

@end
