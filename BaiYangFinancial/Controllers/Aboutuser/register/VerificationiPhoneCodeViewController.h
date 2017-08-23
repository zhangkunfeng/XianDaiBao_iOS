//
//  VerificationiPhoneCodeViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/6.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  短信验证码

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef void (^backNumber)(int TimeNumber);

@interface VerificationiPhoneCodeViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@property (weak, nonatomic) IBOutlet UILabel *twoNum;
@property (weak, nonatomic) IBOutlet UIImageView *threeImage;
@property (weak, nonatomic) IBOutlet UILabel *threeNum;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
//重新获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *GetCodeButton;
//下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *GotoNextButton;
//界面所有按钮点击事件
- (IBAction)allVerificationViewButtonAction:(id)sender;
//回调函数
//@property (nonatomic,copy)backNumber BackTimeNumber;
//重新获取验证码时间
@property (nonatomic,assign)__block int timeout;
//安全资金管理界面
@property (weak, nonatomic) IBOutlet UIView *fundsafetyView;
//是否为找回密码 0 为注册 1为找回登陆密码 2为找回交易密码
@property (nonatomic, assign)NSInteger isFindPassworld;
//手机号码的lable
@property (weak, nonatomic) IBOutlet UILabel *iPhoneNumberLable;
//前面传过来的手机号码
@property (nonatomic, copy)NSString *iphoneNumberString;
- (IBAction)codeErrorButtonAction:(id)sender;

@property (nonatomic, assign)BOOL isBindingiPhone;//是否绑定手机
@property (nonatomic, retain)NSString *loginName;//登陆名字
@end
