//
//  MTAnimationAdapter.h
//  Firehose
//
//  Created by Adam Kirk on 5/30/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <TUIView.h>

#define UIView TUIView

/**
 Animation options
 */
typedef NS_ENUM(NSUInteger, MTAnimationOptions) {
    MTAnimationOptionLayoutSubviews            = 1 << 0, // TODO: Not implemented yet
    MTAnimationOptionAllowUserInteraction      = 1 << 1,
    MTAnimationOptionBeginFromCurrentState     = 1 << 2,
    MTAnimationOptionRepeat                    = 1 << 3,
    MTAnimationOptionAutoreverse               = 1 << 4,
    MTAnimationOptionOverrideInheritedDuration = 1 << 5, // TODO: Not implemented yet
    MTAnimationOptionOverrideInheritedCurve    = 1 << 6, // TODO: Not implemented yet
    MTAnimationOptionAllowAnimatedContent      = 1 << 7, // TODO: Not implemented yet
    MTAnimationOptionShowHideTransitionViews   = 1 << 8, // TODO: Not implemented yet
};

#define UIViewAnimationOptions                         MTAnimationOptions
#define UIViewAnimationOptionLayoutSubviews            MTAnimationOptionLayoutSubviews
#define UIViewAnimationOptionAllowUserInteraction      MTAnimationOptionAllowUserInteraction
#define UIViewAnimationOptionBeginFromCurrentState     MTAnimationOptionBeginFromCurrentState
#define UIViewAnimationOptionRepeat                    MTAnimationOptionRepeat
#define UIViewAnimationOptionAutoreverse               MTAnimationOptionAutoreverse
#define UIViewAnimationOptionOverrideInheritedDuration MTAnimationOptionOverrideInheritedDuration
#define UIViewAnimationOptionOverrideInheritedCurve    MTAnimationOptionOverrideInheritedCurve
#define UIViewAnimationOptionAllowAnimatedContent      MTAnimationOptionAllowAnimatedContent
#define UIViewAnimationOptionShowHideTransitionViews   MTAnimationOptionShowHideTransitionViews

#define CGRectValue         rectValue
#define CGPointValue        pointValue
#define valueWithCGRect     valueWithRect
#define valueWithCGPoint    valueWithPoint
