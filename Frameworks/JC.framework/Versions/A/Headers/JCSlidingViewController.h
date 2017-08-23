//
//  JCSlidingViewController.h
//  SlideView
//
//  Created by Joy Chiang on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    ECLeft,
    ECRight
} ECSide;

typedef enum {
    ECNone = 0,
    ECTapping = 1 << 0,
    ECPanning = 1 << 1
} ECResetStrategy;

@interface JCSlidingViewController : UIViewController

@property(nonatomic, retain) UIViewController *underLeftViewController;
@property(nonatomic, retain) UIViewController *underRightViewController;
@property(nonatomic, retain) UIViewController *topViewController;
@property(nonatomic, assign) CGFloat anchorLeftPeekAmount;
@property(nonatomic, assign) CGFloat anchorRightPeekAmount;
@property(nonatomic, assign) CGFloat anchorLeftRevealAmount;
@property(nonatomic, assign) CGFloat anchorRightRevealAmount;
@property(nonatomic, assign) BOOL shouldAllowUserInteractionsWhenAnchored;
@property(nonatomic, assign) ECResetStrategy resetStrategy;
@property(nonatomic, retain, readonly) UIPanGestureRecognizer *panGesture;

//- (UIPanGestureRecognizer *)panGesture;

- (void)anchorTopViewTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete;
- (void)anchorTopViewOffScreenTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

- (void)resetTopView;

@end

////////////////////////////////////////////////////////////////

@interface UIViewController(SlidingViewExtension)
- (JCSlidingViewController *)slidingViewController;
@end