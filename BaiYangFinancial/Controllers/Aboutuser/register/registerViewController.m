//
//  registerViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/6.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "GestureViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "registerViewController.h"
#import <AdSupport/AdSupport.h>
#import "TalkingDataAppCpa.h"
#import "NetManager.h"
#import "AppDelegate.h"
@interface registerViewController ()

@property (nonatomic, retain) NSString *titleStr;

@end

@implementation registerViewController
@synthesize titleStr;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"设置密码"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"设置密码"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     [self resetSideBack];
    switch (self.isFindPassworld) {
    case 0:
        titleStr = @"设置登录密码";
        break;
    case 1:
        titleStr = @"设置新登录密码";
        break;
    case 2:
        titleStr = @"设置新支付密码";
        self.passWorldTextField.placeholder = @"设置新的支付密码",
        self.againPassworldTextField.placeholder = @"确认新的交易密码";
        self.IntroductionsString.text = @"新的支付密码由6-20位数字组成";
        self.passWorldTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.againPassworldTextField.keyboardType = UIKeyboardTypeNumberPad;
        break;
    default:
        break;
    }
    CustomMadeNavigationControllerView *registerView = [[CustomMadeNavigationControllerView alloc] initWithTitle:titleStr showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:registerView];
    [self.passWorldTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.againPassworldTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

//    [self addSafetyViewToSubview:self.fundsafetyView];

    [self setTextFieldStyle];
}
//输入限制
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.passWorldTextField | textField == self.againPassworldTextField) {
        if (self.isFindPassworld == 2) {//支付密码
            if (textField.text.length > 20) {
                textField.text = [textField.text substringToIndex:20];
            }
            
        }else{
            if (textField.text.length > 20) {
                textField.text = [textField.text substringToIndex:20];
            }
            
        }
    }
}

#pragma mark - 点击屏幕空白区域收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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


#pragma mark - 设置textfield的样式
- (void)setTextFieldStyle {
    for (int i = 0; i < 2; i++) {
        //添加左边图片
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 50, (iPhoneWidth-40)/6);//self.passWorldTextField.frame.size.height 1000
        
        UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LOGIN_PASSWORD]];
        CGFloat UserNameImageViewHeight;
        if (iPhone4 || iPhone5) UserNameImageViewHeight = view.frame.size.height;
        else UserNameImageViewHeight = 50;
        UserNameleftImageView.frame = CGRectMake(0,(view.frame.size.height-50)/2, 50, UserNameImageViewHeight);
        [view addSubview:UserNameleftImageView];

        UILabel *Leftlable = [[UILabel alloc] init];
        //Leftlable.text = titleStr;
        Leftlable.textAlignment = NSTextAlignmentCenter;
        CGSize SizeRect = [self labelAutoCalculateRectWith:Leftlable.text FontSize:17.0 MaxSize:CGSizeMake(iPhoneWidth, MAXFLOAT)];
        Leftlable.frame = CGRectMake(0, 0, SizeRect.width + 10, (iPhoneWidth - 40) / 5);
        if (i == 0) {
//            self.passWorldTextField.layer.borderWidth = 1.0f;
//            self.passWorldTextField.layer.borderColor = LineBackGroundColor.CGColor;
            self.passWorldTextField.leftView = view;
            self.passWorldTextField.leftViewMode = UITextFieldViewModeAlways;
        } else {
//            Leftlable.text = [NSString stringWithFormat:@"重复%@", [titleStr substringWithRange:NSMakeRange(2, titleStr.length - 2)]];
//            self.againPassworldTextField.layer.borderWidth = 1.0f;
//            self.againPassworldTextField.layer.borderColor = LineBackGroundColor.CGColor;
            self.againPassworldTextField.leftView = view;
            self.againPassworldTextField.leftViewMode = UITextFieldViewModeAlways;
        }
    }

    if (self.isFindPassworld) {
        //[self.FinishButton setTitle:@"完成密码重置" forState:UIControlStateNormal];
    }
}

#pragma mark - 返回
- (void)goBack {
    [self customPopViewController:0];
}

#pragma mark - 完成的点击事件
- (IBAction)finishButtonAction:(id)sender {
    [self setPassworldRequest];
}

- (void)setPassworldRequest {
    if (self.isFindPassworld == 2) {
        if (self.passWorldTextField.text.length != 6) {
            [self errorPrompt:3.0 promptStr:@"支付密码为6位"];
        } else {
            self.isFindPassworld = 33;
            [self setPassworldRequest];
        }
    } else if ([self isBlankString:self.passWorldTextField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入密码"];
    } else if (![self.passWorldTextField.text isEqualToString:self.againPassworldTextField.text]) {
        [self errorPrompt:3.0 promptStr:@"两次输入不一致"];
    } else if (self.passWorldTextField.text.length < 6) {
        [self errorPrompt:3.0 promptStr:@"密码少于6位"];
    } else if (self.passWorldTextField.text.length > 20) {
        [self errorPrompt:3.0 promptStr:@"密码多于20位"];
    } else {
        NSDictionary *parameters = nil;
        NSString *string1 = @"";
        switch (self.isFindPassworld) {
        case 0:
            //注册
            [self showWithDataRequestStatus:@"设置登录密码中..."];
            string1 = @"login/regLoginName";
            parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                            @"mobile": _iphoneNumberString,
                            @"password": [NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                            @"code": [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", _iPhoneCodeString, getObjectFromUserDefaults(ACCESSTOKEN)]],
                 /*设备号*/  @"phoneSign": [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                            @"app": @"5"
            };
                NSLog(@"注册pwd -> %@",[NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]);
            break;
        case 1:
            //重置登录密码   忘记密码
            [self showWithDataRequestStatus:@"设置登录密码中..."];
            string1 = @"phone/modifyPsw";
            parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                            @"mobile": _iphoneNumberString,
                            @"password": /*[WDEncrypt md5FromString:self.passWorldTextField.text]*/[NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                            @"code": [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", _iPhoneCodeString, getObjectFromUserDefaults(ACCESSTOKEN)]],
                            @"tag": [WDEncrypt base64EncodedStringFromString:self.passWorldTextField.text]
            };
            break;
        case 33:
            //重置交易密码
            [self showWithDataRequestStatus:@"设置支付密码中..."];
            string1 = @"phone/resetTradePwd";
            parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                            @"uid": getObjectFromUserDefaults(UID),
                            @"sid": getObjectFromUserDefaults(SID),
                            @"code": [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", _iPhoneCodeString, getObjectFromUserDefaults(ACCESSTOKEN)]],
                            @"newPay": /*[WDEncrypt md5FromString:self.passWorldTextField.text]*/  [NetManager TripleDES:self.passWorldTextField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]
            };
            break;
        default:
            break;
        }
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, string1] parameters:parameters success:^(id responseObject) {
            if (responseObject) {
                //                NSLog(@"responseObject = %@",responseObject);
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf setPassworldRequest];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf setPassworldRequest];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    if (self.isFindPassworld != 33) {
                        [self getEncryptionString];
                    } else {
                        [self showWithSuccessWithStatus:@"支付密码修改成功"];
                        [self customPopViewController:3];
                    }
                } else {
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
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = AppMianColor.CGColor;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = LineBackGroundColor.CGColor;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    NSString *passwordstr = [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:self.passWorldTextField.text], salt]], cd]];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:@"注册完成后刷新"];
                    //注册完成后跳去首页的帮助中心
                    [self customPopViewController:3];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginBackMainView object:nil];
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
@end
