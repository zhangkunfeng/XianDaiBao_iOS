//
//  WDToastUtil.h
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/4/20.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WDToastShowTime 1.5

@interface WDToastUtil : NSObject

+ (void)toast:(NSString *)message; // show in key window

+ (void)toast:(NSString *)message inWindow:(UIWindow *)window;
+ (void)toast:(NSString *)message inView:(UIView *)view;

+ (void)toastMsg:(NSString *)message image:(UIImage *)image inWindow:(UIWindow *)window;
+ (void)toastMsg:(NSString *)message image:(UIImage *)image inView:(UIView *)view;

+ (void)toastSuccessMsg:(NSString *)message inView:(UIView *)view;
+ (void)toastErrorMsg:(NSString *)message inView:(UIView *)view;

@end
