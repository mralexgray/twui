//
//  ExampleTableViewController.h
//  Example
//
//  Created by Max Goedjen on 11/13/12.
//
//

//#import "TUIKit.h"
//#import "TUITableOulineView.h"
#import <AtoZ/AtoZ.h>
@interface ExampleTableViewController : TUIViewController <TUITableViewDelegate, TUITableViewDataSource>

@property (nonatomic, strong) TUITableOulineView *tableView;

@end
