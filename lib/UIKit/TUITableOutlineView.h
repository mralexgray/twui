//
//  TUITableOulineView.h
//  Example
//
//  Created by Ivan Ablamskyi on 13.02.13.
//
//

#import "TUITableView.h"

@class TUITableOutlineView;
@protocol TUITableOutlineViewDelegate <TUITableViewDelegate>

- (void)tableView:(TUITableOutlineView *)tableView willOpenSection:(NSInteger)section;
- (void)tableView:(TUITableOutlineView *)tableView didOpenSection:(NSInteger)section;

- (void)tableView:(TUITableOutlineView *)tableView willCloseSection:(NSInteger)section;
- (void)tableView:(TUITableOutlineView *)tableView didCloseSection:(NSInteger)section;

@end

@interface TUITableOutlineView : TUITableView
@property (strong, nonatomic) TUIView *openedSectionBackgroundView;

- (void)toggleSection:(NSInteger)section;

- (BOOL)sectionIsOpened:(NSInteger)section;
- (void)scrollToSection:(NSInteger)section;

@end
    