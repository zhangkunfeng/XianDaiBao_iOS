//
//  AlertSignSuccessInView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/8/29.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "AlertSignSuccessInView.h"
#import "Masonry.h"
@implementation AlertSignSuccessInView
{
    UIButton * detailBtn;
}
//- (id)initWithAlertSignSuccessInViewOtherString:(NSString *)string theDelegate:(id<AlertSignSuccessInViewDelegate>)theDelegate
//{
//    
//    self = [[[NSBundle mainBundle] loadNibNamed:@"AlertSignSuccessInView" owner:self options:nil] lastObject];//xib
//    self = [super init];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.frame = CGRectMake(0, 0,iPhoneWidth * 0.497 , iPhoneHeight * 0.2346);
//        self.delegate = theDelegate;
//        //  [self addSettingView];
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
//    self.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneHeight);
    CGRect viewFram = self.frame;
    viewFram.size.height = iPhoneHeight;
    viewFram.size.width = iPhoneWidth;
    self.frame = viewFram;
    [self addSettingView];
    
    return self;
}

- (void)addSettingView
{
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = iPhoneWidth * 0.05;//15
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(iPhoneWidth * 0.497);
        make.height.mas_equalTo(155);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    UIButton * cancelBtn = [[UIButton alloc] init];
//    cancelBtn.backgroundColor = [UIColor greenColor];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"关闭图标"] forState:UIControlStateNormal];
    [contentView addSubview:cancelBtn];
    
    [cancelBtn addTarget:self action:@selector(closeSignInView:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.trailing.mas_equalTo(-9);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    
    
    UIImageView * signInSuccessIV = [[UIImageView alloc] init];
    signInSuccessIV.image = [UIImage imageNamed:@"卡通人物"];
    [contentView addSubview:signInSuccessIV];
    
    [signInSuccessIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(73);
    }];
    
    detailBtn = [[UIButton alloc] init];
//    detailBtn.backgroundColor = RGB(219, 44, 50);
    detailBtn.backgroundColor = AppBtnColor;
    detailBtn.layer.masksToBounds = YES;
    detailBtn.layer.cornerRadius = 5;
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    detailBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [detailBtn setTitle:@"恭喜您获得1积分" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];;
    [contentView addSubview:detailBtn];
    
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signInSuccessIV.mas_bottom).offset(14);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(iPhoneWidth * 0.364);
        make.height.mas_equalTo(28);
    }];
    
}

//点击获得积分也能退出
- (void)detailBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(closeSignInSuccessView)]) {
        [self.delegate closeSignInSuccessView];
    }
}

- (void)closeSignInView:(UIButton *)btn
{
    
    if ([self.delegate respondsToSelector:@selector(closeSignInSuccessView)]) {
        [self.delegate closeSignInSuccessView];
    }
    
    /* 此种方式也应可以
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.alpha = 0.0;
                         [self setTransform:(CGAffineTransformMakeScale(1.5, 1.5))];
                     }
                     completion:^(BOOL finished) {
//  [[[UIApplication sharedApplication].keyWindow viewWithTag:1500] removeFromSuperview];
                         [self removeFromSuperview];
                     }];
     */
}
- (void)setCurrentSignInIntegral:(NSString *)currentSignInIntegral
{
    [detailBtn setTitle:[NSString stringWithFormat:@"恭喜您获得%@金豆",currentSignInIntegral] forState:UIControlStateNormal];
}
@end
