//
//  JCTabBarController.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCUtility.h"
#import "JCTabBar.h"
#import "CPTabBarController.h"

typedef enum {
    PushPopAnimationLeftRight = 0,
    PushPopAnimationUpDown
} PushPopAnimationDirection;

@interface JCTabBarController : CPTabBarController <UINavigationControllerDelegate, JCTabBarDelegate>

@property(nonatomic, retain, readonly) JCTabBar *JCTabBar;
@property(nonatomic, assign) PushPopAnimationDirection animationDirection;// viewController转换时tabBar隐藏或显示动画方向，默认为系统的左右移动

- (void)addTabBarItemWithViewController:(UIViewController *)viewController;// 添加tabBarItem，自定义JCTabBarItem时需重写该方法

@end

//////////////////////////////////////////////////////////////////////////////////////

@interface UIViewController (JCTabBarControllerItem)

@property(nonatomic, retain) JCTabBarItem *JCTabBarItem;
@property(nonatomic, readonly, retain) JCTabBarController *JCTabBarController;

@end