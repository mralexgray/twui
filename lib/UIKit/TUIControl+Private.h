//
//  TUIControl+Private.h
//  TwUI
//
//  Created by Josh Abernathy on 7/19/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "TUIControl.h"

@interface TUIControl () {
	struct {
		unsigned tracking:1;
		unsigned acceptsFirstMouse:1;
		unsigned disabled:1;
		unsigned selected:1;
		unsigned highlighted:1;
		unsigned hover:1;
	} _controlFlags;
}

@property (nonatomic, readwrite, getter = isTracking) BOOL tracking;
@property (nonatomic, strong) NSMutableArray *targetActions;

- (void)_stateWillChange;
- (void)_stateDidChange;

@end