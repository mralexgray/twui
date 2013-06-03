//
//  ExampleTableViewController.h
//  Example
//
//  Created by Max Goedjen on 11/13/12.
//
//
#import "TUIKit.h"
#import "TUITableOutlineView.h"
@interface ExampleTableViewController : TUIViewController <TUITableViewDelegate, TUITableViewDataSource>
@property (nonatomic, strong) TUITableOutlineView *tableView;
@end
