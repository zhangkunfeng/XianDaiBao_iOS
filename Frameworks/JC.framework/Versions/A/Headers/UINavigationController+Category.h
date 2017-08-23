//
//  UINavigationController+Category.h
//  TYReader
//
//  Created by Joy Chiang on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (Category)

- (UIViewController *)popViewControllerAnimationTransition:(UIViewAnimationTransition)transition;
- (void)pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)transition;

- (void)pushViewController:(UIViewController *)controller;

- (void)fadePopViewController;
- (void)pushFadeViewController:(UIViewController *)viewController;

@end