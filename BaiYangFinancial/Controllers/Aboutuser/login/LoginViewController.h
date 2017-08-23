//
//  LoginViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface LoginViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate,UIAlertViewDelegate>
//登录密码框
@property (weak, nonatomic) IBOutlet UITextField *passWorldTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;//忘记密码按钮
//忘记密码事件
- (IBAction)forgetPassworld:(id)sender;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//登陆事件
- (IBAction)gotoLoginButtonAction:(id)sender;

//底部资金安全
@property (weak, nonatomic) IBOutlet UIView *fundsafetyView;

@property (nonatomic, copy)NSString *iPhoneNumberString;

//获取验证码剩余的时间
@property (nonatomic,assign)int remainTime;

@property (nonatomic, assign)NSInteger pushviewNumber;

@end
