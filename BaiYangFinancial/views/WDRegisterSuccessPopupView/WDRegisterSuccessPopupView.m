//
//  WDRegisterSuccessPopupView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/4/18.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "Masonry.h"
#import "WDRegisterSuccessPopupView.h"
#import "UIImageView+AFNetworking.h"
@implementation WDRegisterSuccessPopupView


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneHeight);

    UIImageView *contentView = [[UIImageView alloc] init];
    contentView.image = [UIImage imageNamed:@"successBackground"];
    contentView.userInteractionEnabled = YES;
    [self addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(25);
//        make.trailing.mas_equalTo(-25);
//        make.centerY.mas_equalTo(0);
//        make.height.mas_equalTo(344);
//        make.centerX.equalTo(self.mas_centerX);
        
        make.height.equalTo(@(355));
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.mas_leading).with.offset(35);
        make.trailing.equalTo(self.mas_trailing).with.offset(-35);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
//    [self downloadImageViewPictiure:imageView];
    imageView.image=[UIImage imageNamed:@"success"];
    [contentView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(41));
        make.height.equalTo(@(41));
        make.centerX.equalTo(contentView);
        make.top.mas_equalTo(36);
    }];
    
    
    UILabel *successLabel=[[UILabel alloc]init];
    successLabel.text=@"恭喜您,注册成功!";
    successLabel.font = [UIFont systemFontOfSize:18.0f];
    successLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [contentView addSubview:successLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(15);
    }];
    

    UILabel *lable = [[UILabel alloc] init];
//    lable.text = @"恭喜您成功获得 288 元红包";
    lable.font = [UIFont fontWithName:@"Heiti SC" size:15.f];
    lable.textColor = [UIColor colorWithHexString:@"666666"];

    
    // 获取红包金额
    [self hongbaoLabelDownloadData:lable];
    [contentView addSubview:lable];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(12);
        make.centerX.mas_equalTo(0);
    }];    
    
    UILabel * blackYuanDian = [[UILabel alloc] init];
    blackYuanDian.backgroundColor= [UIColor colorWithHexString:@"FFC305"];
    blackYuanDian.layer.masksToBounds = YES;
    blackYuanDian.layer.cornerRadius = 3;
    [contentView addSubview:blackYuanDian];
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = [NSString stringWithFormat:@"您已经获得%@元新手红包！现在不用更待何时，立即实名即刻赚钱",_enveloperMoneyStr];//获取不到值
    lable1.numberOfLines = 0;
    lable1.textColor = [UIColor colorWithHexString:@"999999"];
    lable1.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
    [contentView addSubview:lable1];
    self.detailLabel = lable1;

    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView.mas_leading).offset(25);
        make.trailing.equalTo(contentView.mas_trailing).offset(-15);
        make.top.equalTo(lable.mas_bottom).offset(12);
        make.centerX.equalTo(contentView);
    }];
    
    [blackYuanDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(6));
        make.height.equalTo(@(6));
        make.top.equalTo(lable1.mas_top).offset(5);
        make.trailing.equalTo(lable1.mas_leading).offset(-5);
    }];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundColor:AppBtnColor];
    btn1.tag = 100;
    btn1.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.f];
    [btn1 setTitle:@"去实名认证" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 4.0;
    [btn1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn1];
   
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"先看看再说" forState:UIControlStateNormal];
    btn2.layer.borderWidth = .5f;
    btn2.layer.borderColor = AppBtnColor.CGColor;
    btn2.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.f];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    btn2.layer.cornerRadius = 4.0f;
    btn2.tag = 200;
    [btn2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn2];

    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-35);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(32);
    }];

    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn2.mas_top).offset(-15);
        make.centerX.equalTo(contentView).mas_equalTo(0);
        make.width.equalTo(btn2.mas_width);
        make.height.equalTo(btn2.mas_height);
    }];
    
    return self;
}

/* type:   与开机启动图 参数一致
 *      11  登录界面的图
 *      12  注册完成后弹窗的图
 */
//下载图片
- (void)downloadImageViewPictiure:(UIImageView *)imageView
{
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/queryList?at=%@&type=12", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = (NSArray *) data;
                if (dataArray.count > 0) {
                    NSDictionary * dict = dataArray.firstObject;
                    if ([self isLegalObject:dict[@"path"]]) {
                        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"path"]]] placeholderImage:[UIImage imageNamed:@"registerSuccess_imageView"]];
                    }
                }else{
                    imageView.image = [UIImage imageNamed:@"registerSuccess_imageView"];
                }
            }
        }else{
            imageView.image = [UIImage imageNamed:@"registerSuccess_imageView"];
        }
    }fail:^{
        imageView.image = [UIImage imageNamed:@"registerSuccess_imageView"];
    }];
}

// 获取红包金额
- (void)hongbaoLabelDownloadData:(UILabel *)label
{
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/getRedPacketAmount?at=%@", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if ([self isLegalObject:responseObject[@"item"]]) {
                NSDictionary * dict = responseObject[@"item"];
                if ([self isLegalObject:dict[@"AMOUNT"]]) {
                    _enveloperMoneyStr = [NSString stringWithFormat:@"%@",dict[@"AMOUNT"]];//红包金额
                    self.detailLabel.text = [NSString stringWithFormat:@"您已经获得%@元新手红包！现在不用更待何时，立即实名即刻赚钱",_enveloperMoneyStr];
                    
                    label.text  = [NSString stringWithFormat:@"恭喜您成功获得 %@ 元新手红包",dict[@"AMOUNT"]];
                    NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:label.text];
                    [strAtt_Temp addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FB9300"] range:NSMakeRange(8, 3)];
                    [label setAttributedText:strAtt_Temp];
                }
            }else{
                label.text = @"恭喜您成功获得 *** 元新手红包";
            }
        }else{
            label.text = @"恭喜您成功获得 *** 元新手红包";
        }
    }fail:^{
        label.text = @"恭喜您成功获得 *** 元新手红包";
    }];
}

- (void)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
    case 100: {
        [self.delegate bindingBankCard];
    } break;
    case 200: {
        [self.delegate lookReddenvelope];
    } break;
    }
    [self removeFromSuperview];
}
- (BOOL)isLegalObject:(NSObject *)object {
    if (object == nil) {
        return NO;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
@end
