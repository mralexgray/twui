//
//  TUINavigationController.m
//  TwUI
//
//  Created by Max Goedjen on 11/12/12.
//
//

#import "TUINavigationController.h"
#import "TUIView.h"

@interface TUINavigationController ()

@property (nonatomic) NSMutableArray *stack;

@end

static CGFloat const TUINavigationControllerAnimationDuration = 0.25f;

@implementation TUINavigationController

- (id)initWithRootViewController:(TUIViewController *)viewController {
	self = [super init];
	if (self) {
		_stack = [@[] mutableCopy];
		[_stack addObject:viewController];
		viewController.navigationController = self;
		self.view.clipsToBounds = YES;
	}
	return self;
}

- (void)loadView {
	self.view = [[TUIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [NSColor lightGrayColor];
    self.view.viewDelegate = (id<TUIViewDelegate>)self;
	
	TUIViewController *visible = [self topViewController];
	
	[visible viewWillAppear:NO];
	if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
		[self.delegate navigationController:self willShowViewController:visible animated:NO];
	}
	
	[self.view addSubview:visible.view];
	visible.view.frame = self.view.bounds;
	visible.view.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	
	[visible viewDidAppear:YES];
	if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
		[self.delegate navigationController:self didShowViewController:visible animated:NO];
	}

}

#pragma mark - Properties

- (NSArray *)viewControllers {
	return [NSArray arrayWithArray:_stack];
}

- (TUIViewController *)topViewController {
	return [_stack lastObject];
}

#pragma mark - Methods
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
	[self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {	
	CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);

	TUIViewController *viewController = [viewControllers lastObject];
	BOOL containedAlready = ([_stack containsObject:viewController]);
	
	[CATransaction begin];
	//Push if it's not in the stack, pop back if it is
	[self.view addSubview:viewController.view];
	viewController.view.frame = (containedAlready ? TUINavigationOffscreenLeftFrame(self.view.bounds) : TUINavigationOffscreenRightFrame(self.view.bounds));
	[CATransaction flush];
	[CATransaction commit];

	TUIViewController *last = [self topViewController];

	for (TUIViewController *controller in _stack) {
		controller.navigationController = nil;
	}
	[_stack removeAllObjects];
	[_stack addObjectsFromArray:viewControllers];
	for (TUIViewController *controller in viewControllers) {
		controller.navigationController = self;
	}
	
	[TUIView animateWithDuration:duration animations:^{
		last.view.frame = (containedAlready ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds));
		viewController.view.frame = self.view.bounds;
	} completion:^(BOOL finished) {
		[last.view removeFromSuperview];
		
		[viewController viewDidAppear:animated];
		if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
			[self.delegate navigationController:self didShowViewController:viewController animated:animated];
		}
		
		[last viewDidDisappear:animated];
		
		if (completion) {
			completion(finished);
		}
		
	}];
}

- (void)pushViewController:(TUIViewController *)viewController animated:(BOOL)animated {
	[self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewController:(TUIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {

	TUIViewController *last = [self topViewController];
	[_stack addObject:viewController];
	viewController.navigationController = self;

	CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);
		
	[last viewWillDisappear:animated];
	
	
	[viewController viewWillAppear:animated];
	if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
		[self.delegate navigationController:self willShowViewController:viewController animated:animated];
	}
	
	[self.view addSubview:viewController.view];
	
	//Make sure the app draws the frame offscreen instead of just 'popping' it in
	[CATransaction begin];
	viewController.view.frame = TUINavigationOffscreenRightFrame(self.view.bounds);
	[CATransaction flush];
	[CATransaction commit];

	[TUIView animateWithDuration:duration animations:^{
		last.view.frame = TUINavigationOffscreenLeftFrame(self.view.bounds);
		viewController.view.frame = self.view.bounds;
        
        if (_needsBlurWhenSlide) {
//            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints: 0:1 : 1:1]];

            TUIApplyBlurForLayer(viewController.view.layer);
            TUIApplyBlurForLayer(last.view.layer);
        }

	} completion:^(BOOL finished) {
        last.view.layer.filters = nil;
		[last.view removeFromSuperview];
        
		viewController.view.layer.filters = nil;
		[viewController viewDidAppear:animated];
		if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
			[self.delegate navigationController:self didShowViewController:viewController animated:animated];
		}

		[last viewDidDisappear:animated];
		
		if (completion) {
			completion(finished);
		}
		
	}];
}

- (TUIViewController *)popViewControllerAnimated:(BOOL)animated {
	return [self popViewControllerAnimated:animated completion:nil];
}

- (TUIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if ([_stack count] <= 1) {
		NSLog(@"Not enough view controllers on stack to pop");
		return nil;
	}
	TUIViewController *popped = [_stack lastObject];
	[self popToViewController:_stack[([_stack count] - 2)] animated:animated completion:completion];
	return popped;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
	return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if ([[self topViewController] isEqual:_stack[0]] == YES) {
		return @[];
	}
	return [self popToViewController:_stack[0] animated:animated completion:completion];
}

- (NSArray *)popToViewController:(TUIViewController *)viewController animated:(BOOL)animated {
	return [self popToViewController:viewController animated:animated completion:nil];
}

- (NSArray *)popToViewController:(TUIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if ([_stack containsObject:viewController] == NO) {
		NSLog(@"View controller %@ is not in stack", viewController);
		return @[];
	}
	
	TUIViewController *last = [_stack lastObject];
	
	NSMutableArray *popped = [@[] mutableCopy];
	while ([viewController isEqual:[_stack lastObject]] == NO) {
		[popped addObject:[_stack lastObject]];
		[(TUIViewController *)[_stack lastObject] setNavigationController:nil];
		[_stack removeLastObject];
	}
	
	
	[self.view addSubview:viewController.view];
	viewController.view.frame = TUINavigationOffscreenLeftFrame(self.view.bounds);
	
	CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);

	[last viewWillDisappear:animated];
	
	[viewController viewWillAppear:animated];
	if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
		[self.delegate navigationController:self willShowViewController:viewController animated:animated];
	}
	
	[TUIView animateWithDuration:duration animations:^{
		last.view.frame = TUINavigationOffscreenRightFrame(self.view.bounds);
		viewController.view.frame = self.view.bounds;

        if (_needsBlurWhenSlide) {
//            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints: 0:1 : 1:1]];
            TUIApplyBlurForLayer(viewController.view.layer);
            TUIApplyBlurForLayer(last.view.layer);
        }

	} completion:^(BOOL finished) {
		[last.view removeFromSuperview];
        last.view.layer.filters = nil;
        
		viewController.view.layer.filters = nil;
		[viewController viewDidAppear:animated];
		if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
			[self.delegate navigationController:self didShowViewController:viewController animated:animated];
		}

		[last viewDidDisappear:animated];
		
		if (completion) {
			completion(finished);
		}
		
	}];

	
	return popped;
}

#pragma mark - Events
- (void)view:(TUIView *)v scrollWheel:(NSEvent *)theEvent;
{
    CGFloat treshold = 10;
    if (!_couldUseSlideEvent || ![v eventInside:theEvent] ||
        [theEvent type] != NSScrollWheel || ![NSEvent isSwipeTrackingFromScrollEventsEnabled] ||
        [theEvent phase] == NSEventPhaseNone ||
        ABS([theEvent scrollingDeltaY]) >= ABS([theEvent scrollingDeltaX]) ||
        ABS([theEvent scrollingDeltaX]) < treshold) {
        
        // Not posible to start tracking
        return;
    }
    
    BOOL isPushing = [theEvent scrollingDeltaX] < 0;
    BOOL animated = YES;

    TUIViewController *last = [_stack lastObject];
    TUIViewController *viewController = nil;
    
    if (isPushing && [self.delegate respondsToSelector:@selector(viewControllerForSlideInNavigationController:)] &&
        (viewController = [self.delegate viewControllerForSlideInNavigationController:self])) {
        [_stack addObject:viewController];
        viewController.navigationController = self;
    } else if (!isPushing && _stack.count > 1) {
        viewController = _stack[[_stack indexOfObject:last] - 1];
    }
    
    if (!viewController) {
//        NSLog(@"There are no viewcontroller to slide");
        return;
    }
    
    // Prepare to animations
    CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);
    __block BOOL animationCancelled = NO;
    
    [theEvent trackSwipeEventWithOptions:NSEventSwipeTrackingLockDirection | NSEventSwipeTrackingClampGestureAmount
                dampenAmountThresholdMin:-1 max:1
                            usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
                                if (animationCancelled) {
                                    *stop = YES;
                                    void (^compleationBlock)(BOOL) = ^(BOOL finished) {
                                        
                                        if ([self.delegate respondsToSelector:@selector(navigationController:cancelShowViewController:animated:)]) {
                                            [self.delegate navigationController:self cancelShowViewController:viewController animated:animated];
                                        }
                                        
                                        [viewController.view removeFromSuperview];
                                        if (isPushing) {
                                            [_stack removeObject:viewController];
                                            viewController.navigationController = nil;
                                        }
                                        
                                        [viewController viewDidDisappear:animated];
                                        [last viewDidAppear:animated];
                                        
                                    };
                                    
                                        CGRect lastRect = self.view.bounds;
                                        CGRect nextRect = isPushing ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds);
                                        if (!CGRectEqualToRect(last.view.frame, lastRect) && !CGRectEqualToRect(viewController.view.frame, nextRect)) {
                                            [TUIView animateWithDuration:duration animations:^{
                                            last.view.frame = lastRect;
                                            viewController.view.frame = nextRect;
                                            } completion:compleationBlock];
                                        } else
                                            compleationBlock(YES);
                                    return;
                                }
                                
                                if (phase == NSEventPhaseBegan) {
                                    // Setup animation overlay layers
                                    // All swipes should be looks like basic animaiton than we have used like status bar setup
                                    if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
                                        [self.delegate navigationController:self willShowViewController:viewController animated:animated];
                                    }
                                    
                                    [last viewWillDisappear:animated];
                                    [viewController viewWillAppear:animated];

                                    [self.view addSubview:viewController.view];
                                    
                                    //Make sure the app draws the frame offscreen instead of just 'popping' it in
                                    [CATransaction begin];
                                    viewController.view.frame = isPushing ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds);
                                    [CATransaction flush];
                                    [CATransaction commit];
                                }
                                
                                // Update animation overlay to match gestureAmount
                                if (phase == NSEventPhaseEnded) {
                                    // The user has completed the gesture successfully.
                                    // This handler will continue to get called with updated gestureAmount
                                    // to animate to completion, but just in case we need
                                    // to cancel the animation (due to user swiping again) setup the
                                    // controller / view to point to the new content / index / whatever
                                    
                                    return;
                                    
                                } else if (phase == NSEventPhaseCancelled) {
                                    // The user has completed the gesture un-successfully.
                                    // This handler will continue to get called with updated gestureAmount
                                    // But we don't need to change the underlying controller / view settings.
                                    animationCancelled = YES;
                                }
                                
                                if (isComplete) {
                                    // Animation has completed and gestureAmount is either -1, 0, or 1.
                                    // This handler block will be released upon return from this iteration.
                                    // Note: we already updated our view to use the new (or same) content
                                    // above. So no need to do that here. Just...
                                    // Tear down animation overlay here

                                    [viewController viewDidAppear:animated];
                                    if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
                                        [self.delegate navigationController:self didShowViewController:viewController animated:animated];
                                    }
                                    
                                    [last.view removeFromSuperview];
                                    [last viewDidDisappear:animated];
                                    if (!isPushing) {
                                        last.navigationController = nil;
                                        [_stack removeObject:last];
                                    }
                                    
                                    
                                    
                                } else {
                                    gestureAmount = ([theEvent isDirectionInvertedFromDevice] ? 1 : -1) * gestureAmount;
                                    
                                    CGRect lastRect = self.view.bounds;
                                    CGRect nextRect = self.view.bounds;
                                    lastRect.origin.x = gestureAmount * CGRectGetWidth(self.view.bounds);
                                    
                                    if (isPushing) {
                                        nextRect.origin.x = (1 - ABS(gestureAmount)) * CGRectGetWidth(self.view.bounds);
                                    } else {
                                        nextRect.origin.x = (-1 + ABS(gestureAmount)) * CGRectGetWidth(self.view.bounds);
                                    }
                                    
                                    nextRect = CGRectIntegral(nextRect);
                                    lastRect = CGRectIntegral(lastRect);
                                    
                                    if (!CGRectEqualToRect(viewController.view.frame, nextRect) && !CGRectEqualToRect(lastRect, last.view.frame)) {
                                        [CATransaction begin];
                                        [CATransaction setDisableActions:YES];
                                        viewController.view.frame = nextRect;
                                        last.view.frame = lastRect;
                                        [CATransaction flush];
                                        [CATransaction commit];
                                    }
                                    
                                }
                            }];
}


#pragma mark - Private

static inline CGRect TUINavigationOffscreenLeftFrame(CGRect bounds) {
	CGRect offscreenLeft = bounds;
	offscreenLeft.origin.x -= bounds.size.width;
	return offscreenLeft;
}

static inline CGRect TUINavigationOffscreenRightFrame(CGRect bounds) {
	CGRect offscreenRight = bounds;
	offscreenRight.origin.x += bounds.size.width;
	return offscreenRight;
}

NS_INLINE void TUIApplyBlurForLayer(CALayer *layer)
{
    CIFilter *motionBlur = [CIFilter filterWithName:@"CIMotionBlur" keysAndValues:kCIInputRadiusKey, @(0.0), nil];
    [motionBlur setName:@"motionBlur"];
    
    CABasicAnimation *motionBlurAnimation = [CABasicAnimation animation];
    motionBlurAnimation.keyPath = @"filters.motionBlur.inputRadius";
    motionBlurAnimation.fromValue = @(7.0);
    motionBlurAnimation.toValue = @(0.0);
    motionBlurAnimation.fillMode = kCAFillModeForwards;
    motionBlurAnimation.removedOnCompletion = YES;
    
    layer.filters = @[motionBlur];
    [layer addAnimation:motionBlurAnimation forKey:@"motionBlurAnimation"];

}

@end
