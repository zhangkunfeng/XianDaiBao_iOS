//
//  WDAlertView.m
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/22.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "Masonry.h"
#import "WDAlertView.h"

@interface WDAlertView ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *confimButton;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation WDAlertView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        ;

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewButtonAction:)];
        [self addGestureRecognizer:recognizer];

        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(iPhoneWidth * 0.15, (iPhoneHeight-202)/2, iPhoneWidth*0.7, 202)];
        containView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:containView.bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                             cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        containView.layer.mask = maskLayer;
        containView.opaque = NO;
        [self addSubview:containView];

        
  
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containView.frame.size.width, 40)];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.f];//默认17与上同等
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"申请加入理财师";
        titleLabel.backgroundColor = AppMianColor;
        UIBezierPath *maskPath_t = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer_t = [[CAShapeLayer alloc] init];
        maskLayer_t.path = maskPath_t.CGPath;
       titleLabel.layer.mask = maskLayer_t;
         [containView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
//        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, containView.frame.size.width - 30, 1)];
//        line1.backgroundColor = [UIColor lightGrayColor];
//        line1.alpha = 0.5;
//        [containView addSubview:line1];

        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, containView.frame.size.width, 96)];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        contentLabel.text = @"我愿意加入理财师行列!";
        [containView addSubview:contentLabel];
        self.contentLabel = contentLabel;

//        UIButton *contentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 136, containView.frame.size.width - 30, 30)];
//        [contentButton setBackgroundColor:[UIColor clearColor]];
//        [contentButton setTitle:@"" forState:UIControlStateNormal];
//        [contentButton addTarget:self action:@selector(contentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [containView addSubview:contentButton];
//
//        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10, containView.frame.size.width - 30, 1)];
//        line2.backgroundColor = [UIColor lightGrayColor];
//        line2.alpha = 0.5;
//        [containView addSubview:line2];

        UIButton *confimButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 136, containView.frame.size.width - 40, 40)];
        [confimButton setBackgroundColor:AppBtnColor];
        [confimButton setTitle:@"确定申请" forState:UIControlStateNormal];
        [confimButton addTarget:self action:@selector(confimButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        confimButton.layer.masksToBounds = YES;
        confimButton.layer.cornerRadius = 8;
        [containView addSubview:confimButton];
//        [confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(line2.mas_bottom).offset(20);
//            make.leading.equalTo(line1.mas_leading);
//            make.trailing.equalTo(line1.mas_trailing);
//            make.height.mas_equalTo(40);
//        }];
        self.confimButton = confimButton;
    }
    return self;
}

#pragma mark - Action
- (void)topViewButtonAction:(UITapGestureRecognizer *)gesture {
    [self removeFromSuperview];
}

#pragma mark - WDAlertViewDelegate
- (void)contentButtonClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(alertView:contentButton:)]) {
        [_delegate alertView:self contentButton:sender];
    }
}

- (void)confimButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(alertView:confimButton:)]) {
        [_delegate alertView:self confimButton:sender];
    }
}

#pragma mark - getters && setters
- (void)setContent:(NSString *)content {
    self.contentLabel.text = content;
}

- (NSString *)content {
    return self.contentLabel.text;
}

- (void)setConfimButtonTitle:(NSString *)confimButtonTitle {
    [self.confimButton setTitle:confimButtonTitle forState:UIControlStateNormal];
}

- (NSString *)confimButtonTitle {
    return self.confimButton.titleLabel.text;
}

- (void)setButtonTag:(NSInteger)buttonTag {
    self.confimButton.tag = buttonTag;
}

- (NSInteger)buttonTag {
    return self.confimButton.tag;
}

@end
