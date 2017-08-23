//
//  VerificationiPhoneCodeViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/6.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "VerificationiPhoneCodeViewController.h"
#import "registerViewController.h"
#import "GestureViewController.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#import "TalkingDataAppCpa.h"
//#import "GestureViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
//#import "registerViewController.h"

#import "WDRegisterSuccessPopupView.h"
#import "BindingBankCardViewController.h"
#import "RedenvelopeViewController.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 50  //每一个输入框的高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width

@interface VerificationiPhoneCodeViewController ()<WDRegisterSuccessPopupViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *yesOrNoBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWorldTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPassWorldTextField;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@property (nonatomic, strong) NSString *payPassStr;



@end

@implementation VerificationiPhoneCodeViewController

//滑动返回的时候调用block
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
//        self.BackTimeNumber(_timeout);
        return YES;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"验证手机"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"验证手机"];
}
- (IBAction)ZhuCeAction:(id)sender {
    [self jumpToWebview:ZhuCeUrl webViewTitle:@"注册协议"];
    
}
- (IBAction)FengXianAction:(id)sender {
    
    [self jumpToWebview:FengXianUrl webViewTitle:@"风险提示"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self resetSideBack];
//    self.passWorldTextField.delegate = self;
    CustomMadeNavigationControllerView *VerificationCode = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"验证手机" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:VerificationCode];
    [self.CodeTF addTarget:self action:@selector(textFieldDidChangeZ:) forControlEvents:UIControlEventEditingChanged];
    [self.passWorldTextField addTarget:self action:@selector(textFieldDidChangeZ:) forControlEvents:UIControlEventEditingChanged];
//    [self.payPassWorldTextField addTarget:self action:@selector(textFieldDidChangeZ:) forControlEvents:UIControlEventEditingChanged];    //时间倒计时
//    [self getCodeButtonTime];
    
    [self setTextFeildAndButtonStyle];
    [self.passwordView addSubview:self.textField];
    [self initPwdTextField];

}
- (void)textFieldDidChangeZ:(UITextField *)textField
{
    if (textField == self.CodeTF) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
        
    if (textField == self.passWorldTextField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
    if (textField == self.textField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}



#pragma mark - 点击屏幕空白区域收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setTextFeildAndButtonStyle{
    
    UIView *nuulLabl2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, (iPhoneWidth-40)/6 )];
    UIImageView *UserNameleftImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LOGIN_PASSWORD]];
    CGFloat UserNameImageViewHeight1;
    if (iPhone4 || iPhone5) UserNameImageViewHeight1 = nuulLabl2.frame.size.height;
    else UserNameImageViewHeight1 = 50;
    UserNameleftImageView1.frame = CGRectMake(0,(nuulLabl2.frame.size.height-50)/2, 50, UserNameImageViewHeight1);
    [nuulLabl2 addSubview:UserNameleftImageView1];
    self.CodeTF.leftView = nuulLabl2;
    self.CodeTF.leftViewMode = UITextFieldViewModeAlways;

    if (iPhoneWidth == 320) {
        self.GetCodeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    self.GetCodeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    self.CodeTF.layer.borderWidth = 1.0f;
    //self.CodeTF.layer.borderColor = LineBackGroundColor.CGColor;
    
    self.iPhoneNumberLable.text = [NSString stringWithFormat:@"+86 %@",self.iphoneNumberString];
    
//    [self addSafetyViewToSubview:self.fundsafetyView];
    
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
//    self.CodeTF.leftView = view;
//    self.CodeTF.leftViewMode = UITextFieldViewModeAlways;
    self.passWorldTextField.leftView = view;
    self.passWorldTextField.leftViewMode = UITextFieldViewModeAlways;
    

}

#pragma mark - 返回按钮
- (void)goBack{
    if (!_isFindPassworld) {
//        self.BackTimeNumber(_timeout);
    }
    [self customPopViewController:0];
}

#pragma mark - 界面所有按钮的点击方法
- (IBAction)allVerificationViewButtonAction:(id)sender{
    UIButton *Btn = (UIButton *)sender;
    if (Btn.tag == 100) {
        //时间倒计时
        _timeout = GetCodeMaxTime;
        [self gotoVerifyIphoneViewController];
        [self getCodeButtonTime];
    }else{
        if (self.CodeTF.text.length != 6) {
            [self errorPrompt:3.0 promptStr:@"请输入6位数的验证码"];
            return;
        }
        //        [self VerificationiPhoneCodeRequest];
//        [self setPassworldRequest];
        [self setPassWorldZ];
    }
    
}

#pragma mark  ------  手机验证成功后的跳转  ------
- (void)gotoVerifyIphoneViewController{
    
        NSDictionary *parameters = @{@"at":         getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"mobile":     [self clearPhoneNumerSpaceWithString:self.iphoneNumberString]
                                     };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getSmsCode",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if (![self isBlankString:responseObject[@"r"]]) {
                
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf gotoVerifyIphoneViewController];
                    } withFailureBlock:^{
                        
                    }];
                }else if ([[responseObject objectForKey:@"r"] isEqualToString:verificationOK]) {
                    [self dismissWithDataRequestStatus];
                    self.GetCodeButton.enabled = YES;
                    
                
                }
                
            
            }else{
                
                    [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
                    
                }
            
        } fail:^{
            [self dismissWithDataRequestStatus];
           [self showErrorViewinMain];
            
        }];
    }





-(void)setPassWorldZ{
    [self.CodeTF resignFirstResponder];
    if ([self isBlankString:self.passWorldTextField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入密码"];
    }else if (self.passWorldTextField.text.length < 6){
        [self errorPrompt:3.0 promptStr:@"密码少于6位"];
    }else if (self.passWorldTextField.text.length > 20){
        [self errorPrompt:3.0 promptStr:@"密码多于20位"];
    }else if ([self.payPassStr isEqualToString:self.passWorldTextField.text]){
        [self errorPrompt:3.0 promptStr:@"两种密码不能相同"];
        return;
    }
    [self showWithDataRequestStatus:@"注册中"];
    NSDictionary *parameters = @{@"at":getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"mobile":_iphoneNumberString,
                                 @"code":[WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", self.CodeTF.text, getObjectFromUserDefaults(ACCESSTOKEN)]],
                                 @"payPwd":[NetManager TripleDES:_payPassStr encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 @"password":[NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 /*设备号*/  @"phoneSign": [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                 @"app": @"5"
                                 
                                 };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/registSecond",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf setPassWorldZ];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self getEncryptionString];
                
            }else{
                [self dismissWithDataRequestStatus];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                
            }
        }
        
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
    

}
#pragma mark - 获取加密字
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"mobile": _iphoneNumberString,
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    //验证用户名和获取加密字
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/getcd", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                //登陆接口,传递加密需要的密文
                [self userLoginPost:responseObject[@"cd"] salt:responseObject[@"salt"] sid:responseObject[@"sid_login"]];
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                NSLog(@"获取加密字异常= %@",responseObject[@"msg"]);
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

#pragma mark - 我要去登陆啦
/**
 *  登陆接口
 *
 *  @param cd   用户用来登录的加密字
 *  @param salt 用户的密码加密字
 *  @param sid  用户会话ID
 */  //注册专用



- (void)userLoginPost:(NSString *)cd salt:(NSString *)salt sid:(NSString *)sid {
        AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString * clientIdStr = [self isBlankString:delegate.clientId]?@"":delegate.clientId;
    
    NSDictionary *parameters = @{ @"mobile"  : _iphoneNumberString,
                                  @"sid"     : sid,
                                  @"clientId": clientIdStr,
                                  @"source"  : @"101",
                                  @"at"      : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"password": [NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/login", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] intValue] == 1) {
                [self dismissWithDataRequestStatus];
                //获取到得信息保存到本地    注册进入过
                [self SaveUserDefaultToLocal:[responseObject[@"item"] copy]];
                // 3. 业务事件 1) 注册
                [TalkingDataAppCpa onRegister:_iphoneNumberString];//@"Your_userId"
                
                //[self gotoGestureView];
                if (self.isFindPassworld == 0) {
                    
                    _twoNum.text = @"";
                    _twoImage.image = [UIImage imageNamed:@"组-7"];
                    _threeNum.text = @"";
                    _threeImage.image = [UIImage imageNamed:@"组-7"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:@"注册完成后刷新"];
                    //注册完成后跳去首页的帮助中心
                    //[self customPopViewController:3];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginBackMainView object:nil];
                    //停止所有
                    [self.view endEditing:YES];

                    WDRegisterSuccessPopupView *registerSuccessPopupView = [[WDRegisterSuccessPopupView alloc] init];
                    registerSuccessPopupView.delegate = self;
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window addSubview:registerSuccessPopupView];
                    registerSuccessPopupView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    [UIView animateWithDuration:0.35 animations:^{
                        registerSuccessPopupView.transform = CGAffineTransformIdentity;
                    }
                                     completion:^(BOOL finished) {
                                         registerSuccessPopupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                                     }];
                    

                } else {
                    [self customPopViewController:3];
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
            }
            else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}


- (void)bindingBankCard
{
    [self dismissPopupController];
    //获取用户信息
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    [self showWithDataRequestStatus:@"获取信息中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
            BindingBankCardView.bankPayChannel = regYes;
            BindingBankCardView.pushNumber = 22;
            BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
                
            };
            BindingBankCardView.UserInformationDict = (NSDictionary *) [responseObject[@"item"] copy];
            [self customPushViewController:BindingBankCardView customNum:0];
        } else {
            [self dismissWithDataRequestStatus];
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}




- (void)lookReddenvelope {
    //我的红包
    [self dismissPopupController];
//    RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] init];
//    myRedenvelopeView.redBao = redFrom;
//    [self customPushViewController:myRedenvelopeView customNum:0];
    [self customPopViewController:3];
}

#pragma mark - 保存
- (void)SaveUserDefaultToLocal:(NSDictionary *)userDict {
    saveObjectToUserDefaults(userDict[@"mobile"], MOBILE);
    saveObjectToUserDefaults(userDict[@"sid"], SID);
    saveObjectToUserDefaults([NSString stringWithFormat:@"%zd",[userDict[@"uid"] integerValue]], UID);
    saveObjectToUserDefaults(userDict[@"userName"], USERNAME);
}

- (void)gotoGestureView {
    GestureViewController *gestureVc = [[GestureViewController alloc] init];
    gestureVc.type = GestureViewControllerTypeSetting;
    if (self.isFindPassworld == 0) {
        gestureVc.isShowPupopView = YES;
    }
    [self customPresentViewController:gestureVc withAnimation:YES];
}





#pragma mark - 验证手机验证的接口  //注册专用
- (void)VerificationiPhoneCodeRequest{
    [self.CodeTF resignFirstResponder];
    //验证手机验证码的加载框
    [self showWithDataRequestStatus:@"验证手机..."];
    if (self.isBindingiPhone) {
        NSDictionary *parameters = @{@"at":getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"mobile":_iphoneNumberString,
                                     @"verycode":[WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@",self.CodeTF.text,getObjectFromUserDefaults(ACCESSTOKEN)]],
                                     @"loginName":    _loginName
                                     };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/bindPhone",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf VerificationiPhoneCodeRequest];
        } withFailureBlock:^{
            
        }];
                }else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self dismissWithDataRequestStatus];
                    if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                        [self SaveUserDefaultToLocal:[responseObject[@"item"] copy]];
                    }
                }else{ 
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        } fail:^{
            [self showErrorViewinMain];
        }];
    }else{
        NSDictionary *parameters = @{@"at":         getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"mobile":     _iphoneNumberString,
                                     @"code":       [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@",self.CodeTF.text,getObjectFromUserDefaults(ACCESSTOKEN)]]
                                     };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/checkSmsCode",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf VerificationiPhoneCodeRequest];
        } withFailureBlock:^{
            
        }];
                }else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self dismissWithDataRequestStatus];
                    registerViewController *registerView = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
                    registerView.isFindPassworld = _isFindPassworld;
                    registerView.iPhoneCodeString = self.CodeTF.text;
                    registerView.iphoneNumberString = _iphoneNumberString;
                    [self customPushViewController:registerView customNum:0];
                }else{
                    [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
                }
            }
        } fail:^{
            [self showErrorViewinMain];
        }];
    }
}

#pragma mark ---- 重新获取验证码 ----
- (void)getCodeButtonTime
{
    //    _timeout = 20; //倒计时时间 18268837410
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout <= 0){ //倒计时结束，关闭
            //结束后重新复制
            _timeout = GetCodeMaxTime;
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_GetCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _GetCodeButton.userInteractionEnabled = YES;

                [_GetCodeButton setTintColor:[UIColor colorWithRed:84/255.0 green:182/255.0 blue:210/255.0 alpha:1]];
            });
        }else{
            //   int minutes = timeout / 60;
            int seconds = _timeout % 600;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_GetCodeButton setTitle:[NSString stringWithFormat:@"(%@s)重获取",strTime] forState:UIControlStateNormal];
                _GetCodeButton.userInteractionEnabled = NO;

                [_GetCodeButton setTintColor:LineBackGroundColor];
            });
            _timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (kUIScreenWidth - 32) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), 1, K_Field_Height)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.passwordView addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.passwordView addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}






#pragma mark ---- UITextFieldDelegate -----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }

    if (textField == self.CodeTF) {
        if([string isEqualToString:@"\n"]) {
            //按回车关闭键盘
            [textField resignFirstResponder];
            return NO;
        } else if(string.length == 0) {
            //判断是不是删除键
            return YES;
        } else if(textField.text.length >= kDotCount) {
            //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
            NSLog(@"输入的字符个数大于6，忽略输入");
            return NO;
        } else if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"]) {
            return NO;
        } else {
            return YES;
        }

    }else if (textField == self.passWorldTextField){
        
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
            
        
    }else{
        if([string isEqualToString:@"\n"]) {
            //按回车关闭键盘
            [textField resignFirstResponder];
            return NO;
        } else if(string.length == 0) {
            //判断是不是删除键
            return YES;
        } else if(textField.text.length >= kDotCount) {
            //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
            NSLog(@"输入的字符个数大于6，忽略输入");
            return NO;
        } else if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"]) {
            return NO;
        } else {
            return YES;
        }
    
    }
    
    return YES;
    NSLog(@"变化%@", string);
    
    
    
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange111:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange111:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕走这里");
        //！！！！！！！！！！！！！！！！！！！！！！！！！！
        //这里给一个全局的值保存这个6位数字的值就行
        
        _payPassStr = textField.text;
        
        
    }
}

#pragma mark - init
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 5, kUIScreenWidth - 32, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange111:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.CodeTF.text.length > 5 && self.passWorldTextField.text.length > 5 && self.textField.text.length > 5) {
        _GotoNextButton.backgroundColor = AppBtnColor;
        _GotoNextButton.userInteractionEnabled = YES;
        
    }else{
        _GotoNextButton.backgroundColor = LineBackGroundColor;
        _GotoNextButton.userInteractionEnabled = NO;
    }
    
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    _GotoNextButton.backgroundColor = LineBackGroundColor;
    _GotoNextButton.userInteractionEnabled = NO;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)codeErrorButtonAction:(id)sender {
    UIAlertView *exitAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"请检查手机号码是否正确，和手机是否欠费" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [exitAlert show];
}

- (IBAction)yesOrNoBtn:(id)sender {
    if (sender) {
        _yesOrNoBtn.selected = !_yesOrNoBtn.selected;
    }
    if (_yesOrNoBtn.selected == YES && self.CodeTF.text.length > 5 && self.passWorldTextField.text.length > 5 && self.textField.text.length > 5) {
        _GotoNextButton.backgroundColor = AppBtnColor;
        _GotoNextButton.userInteractionEnabled = YES;

    }else{
        _GotoNextButton.backgroundColor = LineBackGroundColor;
        _GotoNextButton.userInteractionEnabled = NO;
    }
    
}


@end
