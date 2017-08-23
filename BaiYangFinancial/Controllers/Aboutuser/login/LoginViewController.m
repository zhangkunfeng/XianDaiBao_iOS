//
//  LoginViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//
#import "AutoBidViewController.h"
#import "GestureViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "TalkingDataAppCpa.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import "ForgetPassWdViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"登录"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"登录"];
    [self.passWorldTextField resignFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self resetSideBack];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *NavigationControllerView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"登录" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:NavigationControllerView];
    [self.passWorldTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setcontrolViewStyle];
    
    _remainTime = GetCodeMaxTime;

    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == self.passWorldTextField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}
#pragma mark - 点击屏幕空白区域收起键盘
- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - 返回按钮点击方法
- (void)goBack {
    if (self.pushviewNumber == 10086) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SendToMyAssets object:nil];
    }
    if (self.pushviewNumber == 1234) {
        //没必要再请求 发送通知
        [self customPopViewController:0];
        return;
    }
    
    if (self.pushviewNumber == 888) {  //首页返回处理
        [self customPopViewController:0];
        return;
    }
    
    if (self.pushviewNumber == 0) {  //首页cell值异常
        [self customPopViewController:0];
        return;
    }
    
    [self customPopViewController:3];
}
#pragma mark - 设置界面控件的风格
- (void)setcontrolViewStyle {
    //添加左边图片
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 50, (iPhoneWidth-40)/6);//self.passWorldTextField.frame.size.height 1000
    
    UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LOGIN_PASSWORD]];
    CGFloat UserNameImageViewHeight;
    if (iPhone4 || iPhone5) UserNameImageViewHeight = view.frame.size.height;
    else UserNameImageViewHeight = 50;
    UserNameleftImageView.frame = CGRectMake(0,(view.frame.size.height-50)/2, 50, UserNameImageViewHeight);
    //    NSLog(@"%f",iPhoneWidth-40);  4.7 inch 335
    //    NSLog(@"%f",(iPhoneWidth-40)/6); 4.7 inch 55.83333
    [view addSubview:UserNameleftImageView];
    
    self.passWorldTextField.leftView = view;
    self.passWorldTextField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    textField.layer.borderWidth = 1.0f;
//    textField.layer.borderColor = AppMianColor.CGColor;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    textField.layer.borderWidth = 1.0f;
//    textField.layer.borderColor = LineBackGroundColor.CGColor;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
        
    }
    // Check for total length
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 20) {
        return NO;//限制长度
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self isBlankString:self.passWorldTextField.text]) {
        [self errorPrompt:3.0 promptStr:@"密码为空"];
    } else {
        [self getEncryptionString];
    }
    return YES;
}

#pragma mark - 这里是获取验证用户名和获取加密字
- (IBAction)gotoLoginButtonAction:(id)sender {
    if ([self isBlankString:self.passWorldTextField.text]) {
        [self errorPrompt:3.0 promptStr:@"密码为空"];
    } else {
        [self getEncryptionString];
    }
}

#pragma mark - 获取加密字      //登录界面进入了
- (void)getEncryptionString {
    [_passWorldTextField resignFirstResponder];
    NSDictionary *parameters = @{ @"mobile": _iPhoneNumberString,
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
    };
    //验证用户名和获取加密字
    [self showWithDataRequestStatus:@"登录中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/getcd", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
               [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                   [weakSelf getEncryptionString];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                //登陆接口,传递加密需要的密文      登录进入过
                [self userLoginPost:responseObject[@"cd"] salt:responseObject[@"salt"] sid:responseObject[@"sid_login"]];
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
        fail:^{
            [self showErrorViewinMain];
        }];
}

- (void)gotoGestureView {
    GestureViewController *gestureVc = [[GestureViewController alloc] init];
    gestureVc.type = GestureViewControllerTypeSetting;
    [self customPushViewController:gestureVc customNum:1];
}
#pragma mark - 我要去登陆啦
/**
 *  登陆接口
 *
 *  @param cd   用户用来登录的加密字
 *  @param salt 用户的密码加密字
 *  @param sid  用户会话ID
 */     //登录界面进入了

- (void)userLoginPost:(NSString *)cd salt:(NSString *)salt sid:(NSString *)sid {
    
//    NSString *passwordstr = [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:self.passWorldTextField.text], salt]], cd]];
    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString * clientIdStr = [self isBlankString:delegate.clientId]?@"":delegate.clientId;

    NSDictionary *parameters = @{ @"mobile"  : _iPhoneNumberString,
                                  @"clientId": clientIdStr,
                                  @"source"  : @"101",
                                  @"sid"     : sid,
                                  @"at"      : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"password": [NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]
    };
    
    NSLog(@"登录 pwd -> %@",[NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]);
    
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/login", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] integerValue] == 1) {
                [weakSelf dismissWithDataRequestStatus];
                if ([weakSelf isBlankString:responseObject[@"item"][@"mobile"]]) {
                    UIAlertView *exitAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"需要验证手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    exitAlert.tag = 10086;
                    [exitAlert show];
                } else {
                    //获取到得信息保存到本地    登录进入过->Login保存
                    [weakSelf SaveUserDefaultToLocal:[responseObject[@"item"] copy]];
                    // 3. 业务事件 2) 登录
                    [TalkingDataAppCpa onLogin:_iPhoneNumberString];//@"Your_userId"
                    //[weakSelf gotoGestureView];
                    if (weakSelf.pushviewNumber == 10010) {
                        //查看自动投标详情
                        AutoBidViewController *AutobidView = [[AutoBidViewController alloc] initWithNibName:@"AutoBidViewController" bundle:nil];
                        AutobidView.pushNumber = self.pushviewNumber;
                        AutobidView.backAssetsView = ^(NSDictionary *autoSettingDict) {

                        };
                        [self customPushViewController:AutobidView customNum:0];
                    } else {
                        //登录完成后跳去首页的帮助中心
                        [weakSelf customPopViewController:3];
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:@"登录完成后刷新"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LoginBackMainView object:nil];
                         [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscoveryView object:nil];//刷新发现
                        
                        //[[NSNotificationCenter defaultCenter] postNotificationName:RefreshFollowView object:nil];//刷新好友
                    }
                }
            } else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf userLoginPost:cd salt:salt sid:sid];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf userLoginPost:cd salt:salt sid:sid];
                } withFailureBlock:^{
                    
                }];
            } else {
                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
        fail:^{
            [self showErrorViewinMain];
        }];
}

#pragma mark - 保存
- (void)SaveUserDefaultToLocal:(NSDictionary *)userDict {//登录进入
    saveObjectToUserDefaults(userDict[@"mobile"], MOBILE);
    saveObjectToUserDefaults(userDict[@"sid"], SID);
    saveObjectToUserDefaults([NSString stringWithFormat:@"%zd",[userDict[@"uid"] integerValue]], UID);
    saveObjectToUserDefaults(userDict[@"userName"], USERNAME);
}

#pragma mark - 忘记密码
- (IBAction)forgetPassworld:(id)sender {
    if (![self isLegalNum:_iPhoneNumberString]) {
        //不是用手机号码登录的
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"找回密码需用手机号登录，如未绑定手机号请联系客服" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
        [alert show];
    } else {
        //self.forgetButton.enabled = NO;
        [self testForgetPassWord];
    }
}

- (void)forgetPassworldAction {
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"mobile": _iPhoneNumberString
    };
    [self showWithDataRequestStatus:@"验证短信获取中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getSmsCode", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([[responseObject objectForKey:@"r"] intValue] == 1) {
                [self dismissWithDataRequestStatus];
                ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
                VerificationCode.iphoneNumberString = _iPhoneNumberString;
                VerificationCode.timeout = _remainTime;
                VerificationCode.isFindPassworld = 1;
                VerificationCode.initalClassName = NSStringFromClass([self class]);
                [self customPushViewController:VerificationCode customNum:0];
            } else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf forgetPassworldAction];
        } withFailureBlock:^{
            
        }];
            } else {
                [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
//                //测试用
//                [self testForgetPassWord];
            }
        }
    }
        fail:^{
            [self showErrorViewinMain];
        }];
    self.forgetButton.enabled = YES;
}

- (void)testForgetPassWord
{
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = _iPhoneNumberString;
    //VerificationCode.timeout = _remainTime;
    VerificationCode.isFindPassworld = 1;
    VerificationCode.initalClassName = NSStringFromClass([self class]);
    [self customPushViewController:VerificationCode customNum:0];
}

//#warning 测试重置密码(忘记密码)功能
//- (void)testForgetPassWord
//{
//    VerificationiPhoneCodeViewController *VerificationCode = [[VerificationiPhoneCodeViewController alloc] initWithNibName:@"VerificationiPhoneCodeViewController" bundle:nil];
//    VerificationCode.iphoneNumberString = _iPhoneNumberString;
//    VerificationCode.timeout = _remainTime;
//    VerificationCode.isFindPassworld = 1;
//    [self customPushViewController:VerificationCode customNum:0];
//}
- (void)savaUserinfoDict:(NSDictionary *)userInfoDict {
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                       [self isBlankString:userInfoDict[@"account"]] ? @"" : userInfoDict[@"account"], @"bankNumber", //银行卡号
                                                       userInfoDict[@"bankId"], @"bankId",
                                                       [self isBlankString:userInfoDict[@"bank"]] ? @"" : userInfoDict[@"bank"], @"bankName",         //所属银行
                                                       [self isBlankString:userInfoDict[@"idNumber"]] ? @"" : userInfoDict[@"idNumber"], @"IDcard",   //身份证件号码
                                                       [self isBlankString:userInfoDict[@"userName"]] ? @"" : userInfoDict[@"userName"], @"userName", //用户名字
                                                       userInfoDict[@"pay"], @"isHavePayPassworld",                                                   //是否有支付密码
                                                       userInfoDict[@"status"], @"bankStatus",                                                        //银行卡的判断状态  1有卡 2无卡 3替换
                                                       userInfoDict[@"realStatus"], @"realStatus",                                                    //身份证认证状态   0 是通过
                                                       [self isBlankString:userInfoDict[@"branch"]] ? @"" : userInfoDict[@"branch"], @"branch", nil]; //支行信息
    [self userDefaultsKeyForDictionary:userInfo defaultsKey:USERINFODICT];
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.passWorldTextField resignFirstResponder];
    if (buttonIndex != 0) {
        if (alertView.tag == 10086) {
            
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                VerificationiPhoneNumberViewController *VerificationiPhoneNumberView = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
                VerificationiPhoneNumberView.pushviewNumber = 2;
                VerificationiPhoneNumberView.loginName = _iPhoneNumberString;
                [self customPushViewController:VerificationiPhoneNumberView customNum:0];
            });
           
        } else {
            // 客服中心点击方法
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", @"4009925222"];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }
}
@end
