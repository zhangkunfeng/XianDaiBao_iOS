//
//  ForgetPassWdViewController.m
//  BaiYangFinancial
//
//  Created by dudu on 2017/6/29.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "ForgetPassWdViewController.h"
#import "registerViewController.h"
#import "GestureViewController.h"
#import "setPaymentPassWorldViewController.h"
@interface ForgetPassWdViewController ()

@end

@implementation ForgetPassWdViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self resetSideBack];
    CustomMadeNavigationControllerView *VerificationCode = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"验证手机" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:VerificationCode];
    [self.CodeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //时间倒计时
    [self getCodeButtonTime];
    
    [self setTextFeildAndButtonStyle];
    
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.CodeTF) {
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
    
    UILabel *nuulLabl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.CodeTF.frame.size.width)];
    self.CodeTF.leftView = nuulLabl2;
    self.CodeTF.leftViewMode = UITextFieldViewModeAlways;
    
    if (iPhoneWidth == 320) {
        self.GetCodeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
//    self.CodeTF.layer.borderWidth = 1.0f;
//    self.CodeTF.layer.borderColor = LineBackGroundColor.CGColor;
    
  //  self.iPhoneNumberLable.text = [NSString stringWithFormat:@"+86 %@",self.iphoneNumberString];
    
    //    [self addSafetyViewToSubview:self.fundsafetyView];
}

#pragma mark - 返回按钮
- (void)goBack{
    if (!_isFindPassworld) {
        self.BackTimeNumber(_timeout);
    }
    [self customPopViewController:0];
}

#pragma mark - 界面所有按钮的点击方法 获取验证码&下一步
- (IBAction)allVerificationViewButtonAction:(id)sender{
    UIButton *Btn = (UIButton *)sender;
    if (Btn.tag == 111) {
        //时间倒计时
        _timeout = GetCodeMaxTime;
        [self gotoVerifyIphoneViewController];
        [self getCodeButtonTime];
    }else{
        if (self.CodeTF.text.length != 6) {
            [self errorPrompt:3.0 promptStr:@"请输入6位数的验证码"];
            return;
        }
#if 1  //正式
        [self VerificationiPhoneCodeRequest];
#elif 0 //测试
        setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
        setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
            if (ishavePW) {
                //            _isHavePayPassworld = YES;
            }
        };
        // [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
        setPaymentPassWorldView.iPhoneCodeString = self.CodeTF.text;
        setPaymentPassWorldView.set = 2;
        setPaymentPassWorldView.initalClassName = self.initalClassName;
        [self customPushViewController:setPaymentPassWorldView customNum:0];
#endif
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
                
                
            }else{
             [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
            }
            
            
        }else{
            
            [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
            
        }
        
    } fail:^{
        [self dismissWithDataRequestStatus];
        
         //[self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
        
        [self showErrorViewinMain];
    }];
}






#pragma mark - 验证手机验证的接口  //注册专用
- (void)VerificationiPhoneCodeRequest{
    [self.CodeTF resignFirstResponder];
    //验证手机验证码的加载框
    [self showWithDataRequestStatus:@"验证手机..."];
    if (self.isBindingiPhone) {
        NSDictionary *parameters = @{@"at":         getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"mobile":     _iphoneNumberString,
                                     @"verycode":       [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@",self.CodeTF.text,getObjectFromUserDefaults(ACCESSTOKEN)]],
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
                    if (_isFindPassworld == 2) {
                        setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
                        setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
                            if (ishavePW) {
                                //            _isHavePayPassworld = YES;
                            }
                        };
                       // [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
                        setPaymentPassWorldView.iPhoneCodeString = self.CodeTF.text;
                        setPaymentPassWorldView.set = 2;
                        setPaymentPassWorldView.initalClassName = self.initalClassName;
                        [self customPushViewController:setPaymentPassWorldView customNum:0];

                    }else{
                        registerViewController *registerView = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
                        registerView.isFindPassworld = _isFindPassworld;
                        registerView.iPhoneCodeString = self.CodeTF.text;
                        registerView.iphoneNumberString = _iphoneNumberString;
                        registerView.initalClassName = self.initalClassName;
                        [self customPushViewController:registerView customNum:0];

                    }
                    
                }else{
                    [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
                }
            }
        } fail:^{
            [self errorPrompt:3.0 promptStr:errorPromptString];
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
                [_GetCodeButton setTitleColor:AppMianColor forState:UIControlStateNormal];
                //[_GetCodeButton setBackgroundColor:AppBtnColor];
            });
        }else{
            //   int minutes = timeout / 60;
            int seconds = _timeout % 600;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_GetCodeButton setTitle:[NSString stringWithFormat:@"(%@s)重新获取",strTime] forState:UIControlStateNormal];
                _GetCodeButton.userInteractionEnabled = NO;
                //[_GetCodeButton setBackgroundColor:LineBackGroundColor];
                [_GetCodeButton setTitleColor:LineBackGroundColor forState:UIControlStateNormal];
            });
            _timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark ---- UITextFieldDelegate -----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"range.length === %zd >>>>>> string ===== %@",range.length,string);
    if (range.length == 0) {
        if (textField.text.length > 4) {
            _GotoNextButton.backgroundColor = AppBtnColor;
            _GotoNextButton.userInteractionEnabled = YES;
        }else{
            _GotoNextButton.backgroundColor = LineBackGroundColor;
            _GotoNextButton.userInteractionEnabled = NO;
        }
    }else{
        if (textField.text.length > 6) {
            _GotoNextButton.backgroundColor = AppBtnColor;
            _GotoNextButton.userInteractionEnabled = YES;
        }else{
            _GotoNextButton.backgroundColor = LineBackGroundColor;
            _GotoNextButton.userInteractionEnabled = NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 5) {
        _GotoNextButton.backgroundColor = AppBtnColor;
        _GotoNextButton.userInteractionEnabled = YES;
    }else{
        _GotoNextButton.backgroundColor = LineBackGroundColor;
        _GotoNextButton.userInteractionEnabled = NO;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = AppMianColor.CGColor;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = LineBackGroundColor.CGColor;
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

#pragma mark - 保存
- (void)SaveUserDefaultToLocal:(NSDictionary *)userDict{
    saveObjectToUserDefaults(userDict[@"mobile"], MOBILE);
    saveObjectToUserDefaults(userDict[@"sid"], SID);
    saveObjectToUserDefaults([NSString stringWithFormat:@"%zd",[userDict[@"uid"] integerValue]], UID);
    saveObjectToUserDefaults(userDict[@"userName"], USERNAME);
    
    //[self gotoGestureView];
    [self customPopViewController:3];
}

#pragma mark - 设置手势密码
- (void)gotoGestureView
{
    GestureViewController *gestureVc = [[GestureViewController alloc] init];
    gestureVc.type = GestureViewControllerTypeSetting;
    //    [self customPresentViewController:gestureVc withAnimation:YES];
    [self customPushViewController:gestureVc customNum:1];
}

@end
