//
//  UIViewController+Loading.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-3-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Loading)

@property(nonatomic, retain, readonly) UILabel *activityLabel;
@property(nonatomic, retain, readonly) UIActivityIndicatorView *activityView;

- (void)hideLoadingIndicator;// 隐藏加载提示条
- (void)showCenteredLoadingIndicator;// 在视图中心显示加载条
- (void)showLoadingIndicatorInNavigationBar;// 在NavigationBar显示加载条
- (void)showLoadingIndicatorWithStatus:(NSString *)status;// 在视图中心显示加载条和给定的文字内容
- (void)showLoadingIndicatorInsteadOfView:(UIView *)viewToReplace;

- (void)showNavigationBar;
- (void)hideNavigationBar;

@end