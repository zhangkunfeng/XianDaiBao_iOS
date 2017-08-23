//
//  TransferViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/16.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "TransferViewController.h"
#import "TransferButtonViewController.h"
#import "remainingBalancePayView.h"
#import "setPaymentPassWorldViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "BindingBankCardViewController.h"
#import "WithDrawDetailsViewController.h"
#import "XRPayPassWorldView.h"
#import "ForgetPassWdViewController.h"

@interface TransferViewController ()<remainingBalancePayViewDelegate,XRPayPassWorldViewDelegate>{
    NSDictionary *_accinfoDict;
    NSString *userMyassetsMoneyString;//使用账户支付的金额
    NSString *userMyBankMoneyString;//使用银行卡支付的金额
}
@property (nonatomic, strong) UIAlertView * transferAlert;
@property (nonatomic, strong)XRPayPassWorldView *payPassWorldView;
@property (nonatomic, retain)NSString *sedpassedString;//交易密码的加密密钥
@property (nonatomic, assign)BOOL isHavePayPassworld;//是否有交易密码
@property (nonatomic, copy)NSDictionary *userInformationDict;

@property (nonatomic, copy) NSDictionary *UserInformationDictionary;
@property (weak, nonatomic) IBOutlet UIImageView *chengjieImageView;


- (IBAction)transferRuleAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *BigView;

@end

@implementation TransferViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //隐藏加载动画
    [self dismissWeidaiLoadAnimationView:self];
    //移除报错界面
    [self hideMDErrorShowView:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.payPassWorldView.textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];

    //显示加载动画
    [self showWeidaiLoadAnimationView:self];
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"债权承接" showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:AutobidView];
    [self loadTranferDetailsDta];
    
//    [self setTheGradientWithView:self.BigView];
    
    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)keybordDown:(id)sender{
    [self.view endEditing:YES];
}


#pragma mark - 承接按钮 点击方法
- (IBAction)TransferButtonAction:(id)sender {
    /*if ([self.recoverTimeShow.text isEqualToString:@"此标已被承接"]) {
               [KVNProgress showErrorWithStatus:@"此标已被承接了"];
    }else{
    }*/
    [self TransferAction];
    
}

#pragma mark - HTTP
- (void)loadTranferDetailsDta{
    NSDictionary *parameters = @{@"at" :  getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"uid":  getObjectFromUserDefaults(UID),
                                 @"sid":  getObjectFromUserDefaults(SID),
                                 @"bid":  _transferbid_id,
                                 @"tid":  _debtUid,
                                 @"version": @"4"};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getTranList",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadTranferDetailsDta];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadTranferDetailsDta];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self hideMDErrorShowView:self];
                if ([[responseObject objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                    _accinfoDict = [[responseObject objectForKey:@"item"] copy];
                    if (_accinfoDict != nil) {
                        [self transferPrice];
                        [self waitPrice];
                        [self principalPrice];
                        [self interestPrice];
                        [self setValue];
                        [self daishou];
                    }
                }
                //隐藏加载动画
                [self dismissWeidaiLoadAnimationView:self];
            }else{
                //隐藏加载动画
                [self dismissWeidaiLoadAnimationView:self];
                // 显示报错界面
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    } fail:^{
        //隐藏加载动画
        [self dismissWeidaiLoadAnimationView:self];
        // 显示报错界面
        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
    }];
}

#pragma mark - MDErrorShowViewDelegate
- (void)againLoadingData
{
    [self loadTranferDetailsDta];
}

#pragma mark - 获取用户信息
- (void)getUserinformation{
    NSDictionary *parameters = @{@"uid":          getObjectFromUserDefaults(UID),
                                 @"sid":          getObjectFromUserDefaults(SID),
                                 @"at":           getObjectFromUserDefaults(ACCESSTOKEN)
                                 };
    //显示数据加载框
    [self showWithDataRequestStatus:@"信息匹配中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getUserBalance",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getUserinformation];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getUserinformation];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                //隐藏加载框
                [self dismissWithDataRequestStatus];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]] && ![responseObject[@"item"] isEqual:[NSNull null]]) {
        
                    //判断是否有交易密码
                    if ([responseObject[@"item"][@"pay"] integerValue] == 1) {
                        _isHavePayPassworld = YES;
                    }else{
                        _isHavePayPassworld = NO;
                    }
                    if ([responseObject[@"item"][@"balance"] doubleValue] >= [_accinfoDict[@"transferPrice"] doubleValue]) {
                        userMyassetsMoneyString = [NSString stringWithFormat:@"%.2f",[_accinfoDict[@"transferPrice"] doubleValue]];
                        userMyBankMoneyString = @"0.00";
                    }else{
                        userMyassetsMoneyString = responseObject[@"item"][@"balance"];
                        userMyBankMoneyString = [NSString stringWithFormat:@"%.2f",[_accinfoDict[@"transferPrice"] doubleValue] - [responseObject[@"item"][@"balance"] doubleValue]];
                    }
                    remainingBalancePayView *Balancepayview = [[remainingBalancePayView alloc] initWithremainingBanlancepayView:[NSString stringWithFormat:@"%.2f",[_accinfoDict[@"transferPrice"] doubleValue]] userMyassetsMoney:userMyassetsMoneyString userMyBankMoney:userMyBankMoneyString theDelegate:self];
                    [self showPopupWithStyle:CNPPopupStyleCentered popupView:Balancepayview];
                }
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}

//获取交易密码加密字
- (void)getEncryptionString{
    NSDictionary *parameters = @{@"uid":          getObjectFromUserDefaults(UID),
                                 @"sid":          getObjectFromUserDefaults(SID),
                                 @"at":           getObjectFromUserDefaults(ACCESSTOKEN)
                                 };
    [self showWithDataRequestStatus:@"承接中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                _sedpassedString = responseObject[@"sedpassed"];
                if (![self isBlankString:_sedpassedString]) {
                    [self TransferBId];
                }else{
                    
                    [self errorPrompt:3.0 promptStr:@"承接失败，请重试..."];//此方法内置取消上个提示
                }
            }else{
                
                
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:@"承接失败，请重试..."];
    }];
}

//承接转让债权  余额支付接口
- (void)TransferBId{
    NSString *transpwd  = @"";
    if ([_accinfoDict[@"bid"] isKindOfClass:[NSNull class]]) {
        [self errorPrompt:3.0 promptStr:@"参数错误，请重试"];
    }else if ([transpwd isKindOfClass:[NSNull class]]){
        [self errorPrompt:3.0 promptStr:@"参数错误，请重试"];
    }else{
        NSDictionary *parameters = @{@"uid":          getObjectFromUserDefaults(UID),
                                     @"sid":          getObjectFromUserDefaults(SID),
                                     @"at":           getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"tid":          _debtUid,
                                     @"bid":          [NSString stringWithFormat:@"%zd",[_accinfoDict[@"bid"] integerValue]],
                                     @"pwd":          [NetManager TripleDES:self.payPassWorldView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                     @"transpwd":     [NetManager TripleDES:transpwd encryptOrDecrypt:kCCEncrypt key:K3DESKey]  ,
                                     @"version":       @"4"
                                     };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/undertakeTranBid",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf TransferBId];
                    } withFailureBlock:^{
                        
                    }];
                }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf TransferBId];
                    } withFailureBlock:^{
                        
                    }];
                }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                    //移除加载框
                    [self dismissWithDataRequestStatus];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
                        WithDrawDetailsView.payMonryString = [NSString stringWithFormat:@"%.2f",[_accinfoDict[@"transferPrice"] doubleValue]];
                        WithDrawDetailsView.bidNameString = _accinfoDict[@"title"];
                        WithDrawDetailsView.pushNumber = 33;
                        WithDrawDetailsView.titleString = @"承接申请";
                        [self customPushViewController:WithDrawDetailsView customNum:0];
                    });
                  
                }else{
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        } fail:^{
            [self errorPrompt:3.0 promptStr:@"承接失败，请重试..."];
        }];
    }
}

- (void)gotoBankPayView{
    NSDictionary *parameters = @{@"uid":               getObjectFromUserDefaults(UID),
                                 @"sid":                getObjectFromUserDefaults(SID),
                                 @"state":              @"1",
                                 @"at":                 getObjectFromUserDefaults(ACCESSTOKEN)
                                 };
    //加载框
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf gotoBankPayView];
            } withFailureBlock:^{
                
            }];
        }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf gotoBankPayView];
            } withFailureBlock:^{
                
            }];
        }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isKindOfClass:[NSNull class]]) {
                
                BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
                BindingBankCardView.payAounmtMoneyString = [NSString stringWithFormat:@"%.2f",[_accinfoDict[@"transferPrice"] doubleValue]];
                BindingBankCardView.userMoney = userMyassetsMoneyString;
                BindingBankCardView.bankPaymoney = userMyBankMoneyString;
                BindingBankCardView.productBID = _accinfoDict[@"bid"];
                BindingBankCardView.tranferId = _debtUid;
                BindingBankCardView.bidNameString = [self isBlankString:_accinfoDict[@"title"]]?@"":_accinfoDict[@"title"];
                BindingBankCardView.bidPasswordString = @"";
                BindingBankCardView.UserInformationDict = [responseObject[@"item"] copy];
                BindingBankCardView.bankPayChannel = BankPayFromUndertake;
                [self customPushViewController:BindingBankCardView customNum:0];
             
            }
        }else{
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:@"稍后重试"];
    }];
}
#pragma mark - XRPayPassWorldViewDelegate
- (void)sureTappend{
    if ([self isBlankString:self.payPassWorldView.textField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入密码"];
        return;
    }
    [self cancelTappend];
    [self getEncryptionString];
}

- (void)cancelTappend{
    [self dismissPopupController];
}

- (void)forgetPassWorldTappend{
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
        VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
        //VerificationCode.timeout = GetCodeMaxTime;
        VerificationCode.isFindPassworld = 2;
        VerificationCode.initalClassName = NSStringFromClass([self class]);
        
        [self customPushViewController:VerificationCode customNum:0];
    });
  
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack{
    [self customPopViewController:0];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.contentScrollView.contentSize = CGSizeMake(iPhoneWidth, self.contentScrollView.contentSize.height + 150);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.contentScrollView.contentSize = CGSizeMake(iPhoneWidth, self.contentScrollView.contentSize.height - 150);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self TransferAction];
    return YES;
}

- (void)TransferAction{
    if ([getObjectFromUserDefaults(UID) integerValue] == [_debtUid integerValue]) {
        [self errorPrompt:3.0 promptStr:@"不能承接自己转让标的"];
    }else {
        [self loadJudgeTradingPasswordAndCardData];
    }
}
#pragma mark - 判断设置交易密码以及绑卡方法
- (void)loadJudgeTradingPasswordAndCardData{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _UserInformationDictionary = [responseObject[@"item"] copy];
                //是否设置交易密码
                if (![_UserInformationDictionary[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDictionary[@"pay"] integerValue] == 1) {
                    
                    //是否绑卡
                    if ([_UserInformationDictionary[@"status"] integerValue] == 2) {
                        _transferAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"债权转让需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_transferAlert show];
                        
                    } else {
                        [self getUserinformation];
                    }
                    
                }else{
                    [self setPaymentPassWordController];
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

//设置支付密码页面
- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            //            _isHavePayPassworld = YES;
        }
    };
    [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [self customPushViewController:setPaymentPassWorldView customNum:1];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _transferAlert && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDictionary copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}

#pragma mark - remainingBalancePayViewDelegate
- (void)gotoPayButtonAction{
    if (!_isHavePayPassworld) {
        [self cancelButtonAction];
        setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
        setPaymentPassWorldView.backUpView = ^(BOOL ishavePW){
            if (ishavePW) {
                _isHavePayPassworld = YES;
            }
        };
        [self customPushViewController:setPaymentPassWorldView customNum:1];
    }else{
        [self cancelButtonAction];

        if ([userMyBankMoneyString isEqualToString:@"0.00"]) {
            self.payPassWorldView.textField.text = @"";
            [self.payPassWorldView clearUpPassword];
            self.payPassWorldView.bottomDistance.constant = iPhone6_?220:iPhone5?125:216;

            [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPassWorldView];
        }else{
            //账户余额不够的时候用户银行卡支付
            [self gotoBankPayView];
        }
    }
}

- (void)cancelButtonAction{
    [self dismissPopupController];
}

#pragma mark - setters && getters
- (XRPayPassWorldView *)payPassWorldView{
    if (!_payPassWorldView) {
        _payPassWorldView = [[XRPayPassWorldView alloc] init];
        _payPassWorldView.delegate = self;
    }
    [_payPassWorldView.textField becomeFirstResponder];

    return _payPassWorldView;
}



//传值-标名/年化利率/剩余期数/待收日期(暂无)/折价率
- (void)setValue{

    //折价率    （项目总额-转让价格）/ 总额
    if ([self isLegalObject:_accinfoDict[@"transferPrice"]]) {
        self.discountRateLab.text = [NSString stringWithFormat:@"%.2f",([_accinfoDict[@"recoverCapital"]  floatValue] - [_accinfoDict[@"transferPrice"] floatValue])/[_accinfoDict[@"recoverCapital"]  floatValue] * 100];
    }
    
    //剩余期数
    self.recoverPeriod.text=[NSString stringWithFormat:@"%@",[_accinfoDict objectForKey:@"recoverPeriod"]];//10期
    
    
    NSString * recoverTimeShowString;
    //标的状态 及 承接按钮
    if ([self isBlankString:[_accinfoDict objectForKey:@"recoverTimeShow"]]) {
        recoverTimeShowString = @"";
    }else{
        recoverTimeShowString = [NSString stringWithFormat:@"%@",[_accinfoDict objectForKey:@"recoverTimeShow"]];
        if ([recoverTimeShowString isEqualToString:@"此标已被承接"]) {
            [self.undertakeBtn setTitle:@"已承接" forState:UIControlStateNormal];
            self.undertakeBtn.backgroundColor = LineBackGroundColor;
            self.undertakeBtn.enabled = NO;
            self.chengjieImageView.image = [UIImage imageNamed:@"yichengjie"];
        }
    }
    
    //利率
    self.borrowAnnualYield.text=[NSString stringWithFormat:@"%.2f",[[_accinfoDict objectForKey:@"borrowAnnualYield"] doubleValue]];
    
    //标题
    self.bidName.text=[NSString stringWithFormat:@"%@",[_accinfoDict objectForKey:@"title"]];
    if ([[_accinfoDict objectForKey:@"password"] isKindOfClass:[NSNull class]]) {
        
    }
    
    
}
//设置转让价格
- (void)transferPrice
{
#if 0
    if ([self isLegalObject:_accinfoDict[@"transferPrice"]]) {
        self.transferPriceLab.text=[NSString stringWithFormat:@"%.2f%@",[_accinfoDict[@"transferPrice"] doubleValue],@""];
    }else{
        self.transferPriceLab.text = @"";
    }
    [self.transferPriceLab setColor:AppMianColor fromIndex:0 length:self.transferPriceLab.text.length];
    [self.transferPriceLab setFont:[UIFont systemFontOfSize:15] fromIndex:0 length:self.transferPriceLab.text.length-1];
    //设置元字的大小
    [self.transferPriceLab setFont:[UIFont systemFontOfSize:12] fromIndex:self.transferPriceLab.text.length-1 length:1];
#endif
    if ([self isLegalObject:_accinfoDict[@"transferPrice"]]) {
        self.transferPriceLab.text = [Number3for1 formatAmount:_accinfoDict[@"transferPrice"]];
    }else{
        self.transferPriceLab.text = @"";
    }
}
//设置待收总额
- (void)waitPrice
{
#if 0
    if ([self isLegalObject:_accinfoDict[@"recoverInterest"]]) {
        self.waitPriceLab.text=[NSString stringWithFormat:@"%.2f%@",[_accinfoDict[@"recoverInterest"] doubleValue],@""];
    }else{
        self.waitPriceLab.text = @"";
    }
    [self.waitPriceLab setColor:[self colorFromHexRGB:@"3A3A3A"] fromIndex:0 length:self.waitPriceLab.text.length-1];
    [self.waitPriceLab setColor:[self colorFromHexRGB:@"898989"] fromIndex:self.waitPriceLab.text.length-1 length:1];
    [self.waitPriceLab setFont:[UIFont systemFontOfSize:15] fromIndex:0 length:self.waitPriceLab.text.length-1];
    [self.waitPriceLab setFont:[UIFont systemFontOfSize:12] fromIndex:self.waitPriceLab.text.length-1 length:1];
#endif
    if ([self isLegalObject:_accinfoDict[@"recoverInterest"]]) {
        self.waitPriceLab.text=[Number3for1 formatAmount:_accinfoDict[@"recoverInterest"]];
    }else{
        self.waitPriceLab.text = @"";
    }
}
//设置待收本金
- (void)principalPrice
{
#if 0
    if ([self isLegalObject:_accinfoDict[@"recoverCapital"]]) {
        self.principalLab.text=[NSString stringWithFormat:@"%.2f%@",[_accinfoDict[@"recoverCapital"] doubleValue],@""];
    }else{
        self.principalLab.text = @"";
    }
    [self.principalLab setColor:[self colorFromHexRGB:@"3A3A3A"] fromIndex:0 length:self.principalLab.text.length-1];
    [self.principalLab setColor:[self colorFromHexRGB:@"898989"] fromIndex:self.principalLab.text.length-1 length:1];
    [self.principalLab setFont:[UIFont systemFontOfSize:15] fromIndex:0 length:self.principalLab.text.length-1];
    [self.principalLab setFont:[UIFont systemFontOfSize:12] fromIndex:self.principalLab.text.length-1 length:1];
#endif
    if ([self isLegalObject:_accinfoDict[@"recoverCapital"]]) {
        self.principalLab.text= [Number3for1 formatAmount:_accinfoDict[@"recoverCapital"]];
    }else{
        self.principalLab.text = @"";
    }
}
-(void)daishou{
    
if ([self isLegalObject:_accinfoDict[@"recoverCapital"]]) {
    self.SHouyiLab.text= [Number3for1 formatAmount: [NSString stringWithFormat:@"%.02f",[_accinfoDict[@"recoverCapital"] doubleValue]/1000 * 2 ]];
}else{
    self.SHouyiLab.text = @"";
}

}
//设置待收利息
- (void)interestPrice
{
#if 0
    if ([self isLegalObject:_accinfoDict[@"recoverInterest"]]) {
        self.interestLab.text=[NSString stringWithFormat:@"%.2f%@",[_accinfoDict[@"recoverInterest"] doubleValue],@""];
    }else{
        self.interestLab.text = @"";
    }
    [self.interestLab setColor:[self colorFromHexRGB:@"3A3A3A"] fromIndex:0 length:self.interestLab.text.length-1];
    [self.interestLab setColor:[self colorFromHexRGB:@"898989"] fromIndex:self.interestLab.text.length-1 length:1];
    [self.interestLab setFont:[UIFont systemFontOfSize:15] fromIndex:0 length:self.interestLab.text.length-1];
    [self.interestLab setFont:[UIFont systemFontOfSize:12] fromIndex:self.interestLab.text.length-1 length:1];
#endif
    if ([self isLegalObject:_accinfoDict[@"recoverInterest"]]) {
        self.interestLab.text= [Number3for1 formatAmount:_accinfoDict[@"recoverInterest"]];
    }else{
        self.interestLab.text = @"";
    }
}



- (IBAction)transferRuleAction:(id)sender {
    [self jumpToWebview:AssignmentDetailsURL webViewTitle:@"债权转让规则"];    
}
@end
