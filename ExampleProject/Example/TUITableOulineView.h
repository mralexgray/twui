//
//  TUITableOulineView.h
//  Example
//
//  Created by Ivan Ablamskyi on 13.02.13.
//
//

#import <TUIKit.h>

@interface TUITableOulineView : TUITableView

- (void)toggleSection:(NSInteger)section;

- (BOOL)sectionIsOpened:(NSInteger)section;
- (void)scrollToSection:(NSInteger)section;

@end
