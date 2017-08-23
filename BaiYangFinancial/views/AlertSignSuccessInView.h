//
//  AlertSignSuccessInView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/8/29.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertSignSuccessInViewDelegate <NSObject>

- (void)closeSignInSuccessView;

@end


@interface AlertSignSuccessInView : UIView

@property(nonatomic, weak) id<AlertSignSuccessInViewDelegate>delegate;
//@property(nonatomic,copy) NSString * currentSignInIntegral;//签到获得积分

- (void)setCurrentSignInIntegral:(NSString *)currentSignInIntegral;

@end
