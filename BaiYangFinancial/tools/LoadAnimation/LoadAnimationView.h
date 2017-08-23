//
//  LoadAnimationView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/13.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  加载视图

#import <UIKit/UIKit.h>

@interface LoadAnimationView : UIView
@property (assign, readonly, nonatomic) BOOL isAnimate;
@property (strong, nonatomic) UILabel *loadLable;
@property (strong, nonatomic) CALayer *contentLayer;
@property (nonatomic, copy) NSString *loadtext;

- (id) initWithView:(UIView *)view;

- (void) show;

- (void) dismiss;

- (void)setLoadText:(NSString *)text;

- (void) initTitle;
- (void) initCommon;
- (void) initWifiManHub;

@end
