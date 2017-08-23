//
//  VerificationiPhoneNumberViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/6.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  手机登录注册

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef void(^backRefresh)(BOOL isRefresh);

@interface VerificationiPhoneNumberViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

//手机号码的TextFeild
@property (weak, nonatomic) IBOutlet UITextField *iPhoneNumberTextField;
//显示手机号码的Lable高度的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isShowiPhoneNumberLableHeight;
//显示手机号码的Lable
@property (weak, nonatomic) IBOutlet UILabel *showiPhoneNumberLable;
//获取手机验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
//下一步的点击方法/获取手机验证码按钮事件
- (IBAction)VerificationiPhoneButtonAction:(id)sender;
//贤钱宝用户协议
@property (weak, nonatomic) IBOutlet UIButton *WeidaiProtocolButton;
- (IBAction)WeidaiProtocolButtonAction:(id)sender;
//底部安全管理view
@property (weak, nonatomic) IBOutlet UIView *safetyView;
//获取验证码剩余的时间
@property (nonatomic,assign)int remainTime;
//记录跳转 便于判断
@property (nonatomic, assign)NSInteger pushviewNumber;

@property (nonatomic, copy)backRefresh isbackRefresh;//回去刷新

@property (nonatomic, retain)NSString *loginName;//登陆名

@end
