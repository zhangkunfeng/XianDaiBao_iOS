//
//  UIAnimation+UIView.h
//  Chumkee
//
//  Created by Joy Chiang on 11-11-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIAnimationManager.h"

@interface UIView (UIAnimationAdditions)

- (void)setAlpha:(float)alpha duration:(float)duration;
- (void)setFrame:(CGRect)frame duration:(float)duration;
- (void)removeWithOptions:(UIViewAnimationOptions)options duration:(float)duration;
- (void)addSubview:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(float)duration;

///---------------------------------------------------------------------------
/// @name 滑动的效果离开屏幕
///---------------------------------------------------------------------------
- (void)slideInFrom:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate;
- (void)slideInFrom:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate 
      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
- (void)slideInFrom:(UIAnimationDirection)direction inView:(UIView *)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate 
      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)slideOutTo:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate;
- (void)slideOutTo:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
- (void)slideOutTo:(UIAnimationDirection)direction inView:(UIView *)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

///---------------------------------------------------------------------------
/// @name backOut backIn
///---------------------------------------------------------------------------
- (void)backOutTo:(UIAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate;
- (void)backOutTo:(UIAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
    startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
- (void)backOutTo:(UIAnimationDirection)direction inView:(UIView *)enclosingView withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)backInFrom:(UIAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate;
- (void)backInFrom:(UIAnimationDirection)direction withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate 
     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;
- (void)backInFrom:(UIAnimationDirection)direction inView:(UIView *)enclosingView withFade:(BOOL)fade duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

///---------------------------------------------------------------------------
/// @name 淡入淡出的动画效果
///---------------------------------------------------------------------------
- (void)fadeIn:(NSTimeInterval)duration delegate:(id)delegate;
- (void)fadeIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)fadeOut:(NSTimeInterval)duration delegate:(id)delegate;
- (void)fadeOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)fadeBackgroundColorIn:(NSTimeInterval)duration delegate:(id)delegate;
- (void)fadeBackgroundColorIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)fadeBackgroundColorOut:(NSTimeInterval)duration delegate:(id)delegate;
- (void)fadeBackgroundColorOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;


///---------------------------------------------------------------------------
/// @name 带有放大缩小的动画效果
///---------------------------------------------------------------------------
- (void)popIn:(NSTimeInterval)duration delegate:(id)delegate;
- (void)popIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)popOut:(NSTimeInterval)duration delegate:(id)delegate;
- (void)popOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)fallIn:(NSTimeInterval)duration delegate:(id)delegate;
- (void)fallIn:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)fallOut:(NSTimeInterval)duration delegate:(id)delegate;
- (void)fallOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (void)flyOut:(NSTimeInterval)duration delegate:(id)delegate;
- (void)flyOut:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

@end