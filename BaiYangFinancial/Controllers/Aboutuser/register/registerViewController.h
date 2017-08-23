//
//  registerViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/6.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  设置密码 交易密码

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface registerViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>
//密码框
@property (weak, nonatomic) IBOutlet UITextField *passWorldTextField;
//确定密码
@property (weak, nonatomic) IBOutlet UITextField *againPassworldTextField;
//安全资金管理
@property (weak, nonatomic) IBOutlet UIView *fundsafetyView;

//完成按钮
@property (weak, nonatomic) IBOutlet UIButton *FinishButton;
//完成事件
- (IBAction)finishButtonAction:(id)sender;

//是否为找回密码 0 为注册 1为找回登陆密码 2为找回交易密码
@property (nonatomic, assign)NSInteger isFindPassworld;
@property (weak, nonatomic) IBOutlet UILabel *IntroductionsString;//字段说明

@property (nonatomic, copy)NSString *iphoneNumberString;
@property (nonatomic, copy)NSString *iPhoneCodeString;


@property (copy, nonatomic) NSString * initalClassName;//跳入初始页面


@end
