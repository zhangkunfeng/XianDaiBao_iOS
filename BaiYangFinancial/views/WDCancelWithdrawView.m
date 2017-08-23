//
//  WDCancelWithdrawView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/5/3.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "Masonry.h"
#import "WDCancelWithdrawView.h"

#define CANCELWITHDRAWFONT [UIFont fontWithName:@"Heiti SC" size:15.f]

@interface WDCancelWithdrawView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) sureButtonTappedBlock block;

@end

@implementation WDCancelWithdrawView
+ (instancetype)shareCanceWithdrawView {
    static WDCancelWithdrawView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WDCancelWithdrawView alloc] init];
    });
    return _instance;
}

- (void)showCancelWithdrawViewWithsureButtonTapped:(sureButtonTappedBlock)block {
    self.block = block;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    self.maskView = [[UIView alloc] initWithFrame:window.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [window addSubview:self.maskView];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = RGB(242, 242, 242);
    contentView.layer.cornerRadius = 5.f;

    [window addSubview:contentView];
    self.containerView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(130);
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
    }];

    UILabel *contentLable = ({
        UILabel *_contentLable = [[UILabel alloc] init];
        [_contentLable setText:@"是否确认取消本次提现?"];
        [_contentLable setTextColor:[UIColor grayColor]];
        [_contentLable setFont:CANCELWITHDRAWFONT];
        _contentLable;
    });
    [contentView addSubview:contentLable];
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.centerX.mas_equalTo(0);
    }];

    UIButton *cancelButton = ({
        UIButton *_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton.layer setBorderWidth:.5f];
        [_cancelButton.layer setCornerRadius:3.f];
        [_cancelButton.titleLabel setFont:CANCELWITHDRAWFONT];
        [_cancelButton.layer setBorderColor:LineBackGroundColor.CGColor];
        [_cancelButton setTag:100];
        [_cancelButton addTarget:self action:@selector(sureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton;
    });
    [contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(-15);
    }];

    UIButton *sureButton = ({
        UIButton *_sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:AppBtnColor];
        [_sureButton.layer setCornerRadius:3.f];
        [_sureButton.titleLabel setFont:CANCELWITHDRAWFONT];
        [_sureButton setTag:101];
        [_sureButton addTarget:self action:@selector(sureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton;
    });
    [contentView addSubview:sureButton];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(cancelButton.mas_trailing).offset(15);
        make.centerY.equalTo(cancelButton);
        make.trailing.mas_equalTo(-15);
        make.width.height.equalTo(cancelButton);
    }];

    [window addSubview:self];

    self.containerView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    self.alpha = 0;

    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 1;
        self.containerView.alpha = 1;
        self.alpha = 1;
    }];
}

- (void)dimiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        self.alpha = 0;
        self.maskView.alpha = 0;
        self.containerView.alpha = 0;
    }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.maskView removeFromSuperview];
            [self.containerView removeFromSuperview];
        }];
}

- (void)sureButtonTapped:(UIButton *)button {
    if (button.tag == 101) {
        if (self.block) {
            self.block();
        }
    }
    [self dimiss];
}

@end
