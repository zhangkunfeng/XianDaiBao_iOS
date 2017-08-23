
//  BindingBankCardViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AttributedLabel.h"
#import "BankListViewController.h" //银行卡列表
#import "BindingBankCardViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "WithDrawDetailsViewController.h" //投标申请
#import "payView.h"
#import "setPaymentPassWorldViewController.h" //设置交易密码
#import "AFNetworkTool.h"
#import "XRPayPassWorldView.h"
#import "CZProvince.h"
#import "ForgetPassWdViewController.h"
#import "PayYesViewController.h"
#import "XGYTextField.h"
//富友 文件
#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>
#import "XGYTextField/XGYTextField.h"
//连连支付
#import "LLPaySdk.h"

#define TextFont [UIFont systemFontOfSize:15.0]

@interface BindingBankCardViewController () <UITextFieldDelegate,XRPayPassWorldViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FYPayDelegate,LLPaySdkDelegate, XGYTextFieldDelegate> {
    UIView *bankView; //底部说明
    payView *payview;
    
    NSString *InvestorsName;        //投资人得姓名
    NSString *InvestorsID_no;       //投资人的身份证号码
    NSString *InvestorsBankNo;      //投资人银行编号  eg. ICBC
    NSString *InvestorsBankcard_no; //投资人的银行卡号码
    NSString *RechargeMoney;        //充值的金额
    
    NSString *QuotaString; //限额
    
    //连连支付返回的
    NSInteger LLPayresultCode;
    NSString *LLPayMessage;
}

@property (nonatomic, strong)XRPayPassWorldView *payPassWorldView;
@property (nonatomic, retain) LLPaySdk *llPaysdk;      //连连支付的sdk
@property (nonatomic, assign) BOOL isHavePayPassworld; //是否有交易密码

@property (nonatomic, copy) NSString *bankCodeStr;
@property (nonatomic, copy) NSDictionary *orderParamDict; //储存连连支付的数据

@property (nonatomic, copy) NSDictionary *cardDict; //绑卡数据

@property (nonatomic, retain) NSString *sedpassedString;  //交易密码加密字

@property (nonatomic, strong) UITextField *nameField;     //姓名
@property (nonatomic, strong) UITextField *CardidField;   //身份证
@property (nonatomic, strong) UITextField *BankNameField; //银行
@property (nonatomic, strong) UITextField *BankCardField; //银行卡号
@property (nonatomic, strong) UITextField *BankCityField; //开户行城市
@property (nonatomic, strong) UIImageView *BankImageView;//银行图标
@property (nonatomic, strong) UIView *coverView;//pickerView蒙层
@property (nonatomic, strong) NSArray *areas;// 加载所有的地区信息
@property (nonatomic, copy)   NSString *citycode;//城市编码[后台]


@property (strong, nonatomic) IBOutlet UIView *codesView;
@property (nonatomic,assign)__block int timeout;     //重新获取验证码时间
//重新获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *GetCodeButton;
//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;//下一步 | 完成
@property (weak, nonatomic) IBOutlet XGYTextField *CodeTF;

//pickView
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)confirmBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
//银行卡混合支付数据 投资     bankPayDict-》承接 在.h
@property (copy, nonatomic) NSDictionary *bankPayInfo;

@end

@implementation BindingBankCardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[IQKeyboardManager sharedManager].enable = YES;
    [self talkingDatatrackPageBegin:@"绑定银行卡/实名认证 & 银行卡支付"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //[IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"绑定银行卡/实名认证 & 银行卡支付"];
    [AFNetworkTool cancelAllHTTPOperations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CodeTF.delgate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self resetSideBack];
    NSLog(@"%@", _UserInformationDict);
    
    
    if (iPhone4) {
        self.contentScrollView.contentSize = CGSizeMake(iPhoneWidth, self.contentScrollView.contentSize.height + 216);
    }
    
    NSString *titleString = @"";
    if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes) {
        titleString = @"绑定银行卡/实名认证";
        [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else if (self.bankPayChannel == BankPayFromTender || self.bankPayChannel == BankPayFromUndertake){
        titleString = @"银行卡支付";
    }
    
    self.cityPickerView.delegate = self;
    self.cityPickerView.dataSource = self;
    [self setFrame];//pickerViewBackground
    
    [self.CodeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //    switch (self.pushNumber) {
    //    case 11: {
    //        titleString = @"银行卡支付";
    //    } break;
    //    case 22: {
    //        titleString = @"绑定银行卡";
    //    } break;
    //    case 33: {
    //        titleString = @"充值";
    //    } break;
    //    case 44: {
    //        titleString = @"银行卡支付";
    //    } break;
    //    default:
    //        break;
    //    }
    CustomMadeNavigationControllerView *BindingBankCardView = [[CustomMadeNavigationControllerView alloc] initWithTitle:titleString showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:BindingBankCardView];
    
    //    [self addSafetyViewToSubview:self.safeView];
    
    self.RechargePriceNumberFeildWidthConstraint.constant = iPhoneWidth * 0.7;
    
    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self setBindingBankCardViewController];
    
    _timeout = GetCodeMaxTime;
    [_GetCodeButton setTitle:@"点击发送验证码" forState:UIControlStateNormal];
    _GetCodeButton.titleLabel.font=[UIFont systemFontOfSize:13];
    _GetCodeButton.userInteractionEnabled = YES;
}
//添加限制
- (void)textFieldDidChange:(UITextField *)textField
{
    
}
- (void)setBindingBankCardViewController {
    
    QuotaString = @"";          //限额
    InvestorsName = @"";        //投资人得姓名
    InvestorsID_no = @"";       //投资人的身份证号码
    InvestorsBankNo = @"";      //投资人银行简称  ICBC
    InvestorsBankcard_no = @""; //投资人得银行卡号码
    
    if (![self isBlankString:_UserInformationDict[@"info"]]) {
        QuotaString = _UserInformationDict[@"info"];
    }
    
    if (self.bankPayChannel == BankPayFromTender || self.bankPayChannel == BankPayFromUndertake) {
        self.buyBidshowView.hidden = NO;
        self.buyBidshowViewheightConstraint.constant = 145;
        self.payMoneyLable.text = _payAounmtMoneyString;
        self.userMoneyLable.text = self.userMoney;
        self.bankPayMoneyLable.text = self.bankPaymoney;
        self.recordMoneyLable.text = [NSString stringWithFormat:@"%.2f", [self.recordMoneyString doubleValue]];
    }
    
    if (![_UserInformationDict[@"status"] isKindOfClass:[NSNull class]]) {
        NSInteger statusVaule = [_UserInformationDict[@"status"] integerValue];
        switch (statusVaule) {
            case 1: {
                if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
                    if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
                        self.TableViewheightConstraint.constant = 354 - 88;
                    } else {
                        self.TableViewheightConstraint.constant = 354 - 44;
                    }
                } else {
                    self.TableViewheightConstraint.constant = 354 - 44;
                }
                
            } break;
            case 2: {
                if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
                    if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
                        self.TableViewheightConstraint.constant = 354 - 44;
                    } else {
                        self.TableViewheightConstraint.constant = 431;
                    }
                } else {
                    self.TableViewheightConstraint.constant = 354;
                }
                
            } break;
            case 3: {
                if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
                    if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
                        self.TableViewheightConstraint.constant = 354 - 44;
                    } else {
                        self.TableViewheightConstraint.constant = 354;
                    }
                } else {
                    self.TableViewheightConstraint.constant = 354;
                }
            } break;
                
            default:
                break;
        }
    }
    
    if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes) {
        self.codesView.hidden = NO;
        
    }else{
        self.codesView.hidden = YES;
    }
    
       if (self.pushNumber == 33) {
        self.RechargeView.hidden = NO;
        self.RechargeViewheightConstraint.constant = 88;
        self.AvailableBalanceLable.text = self.AvailableBalanceString;
        if ([self isBlankString:self.RechargeMoneyString]) {
            self.RechargeMoneyTF.tag = 8888;
        } else {
            self.RechargeMoneyTF.tag = 7777;
            self.RechargeMoneyTF.text = [NSString stringWithFormat:@"%.2f 元", [self.RechargeMoneyString doubleValue]];
        }
        self.RechargeMoneyTF.delegate = self;
    }
    [self.view layoutIfNeeded];
}

#pragma mark - Action 点击发送验证码
//- (IBAction)allVerificationViewButtonAction:(id)sender{
//    if (self.bankPayChannel == BankPayFromBindingCard) {
//        //[self getiPhoneCodeRequest];
//    }else{
//        [self sendCode];
//    }
//}

/**
 *  下一步的执行方法
 */
- (IBAction)goToPayment:(id)sender {
    [self.view endEditing:YES];
    //投资人的身份信息
    if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
        if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
            InvestorsName = _UserInformationDict[@"userName"];
            InvestorsID_no = _UserInformationDict[@"idNumber"];
        } else {
            if ([_UserInformationDict[@"realStatus"] integerValue] != 0) {//解绑后为1,走此
                if ([self isLegalObject:_UserInformationDict[@"userName"]] || [self isLegalObject:_UserInformationDict[@"idNumber"]]) {
                    InvestorsName = _UserInformationDict[@"userName"];
                    InvestorsID_no = _UserInformationDict[@"idNumber"];
                }else
                {
                    InvestorsName = _nameField.text;
                    InvestorsID_no = _CardidField.text;
                    _nameField.placeholder = @"请输入持卡人姓名";
                }
            }else{
                InvestorsName = _nameField.text;
                InvestorsID_no = _CardidField.text;
            }
        }
    }else {
        InvestorsName = _nameField.text;
        InvestorsID_no = _CardidField.text;
    }
    
    // 投资人得银行卡信息
    if (![_UserInformationDict[@"status"] isKindOfClass:[NSNull class]]) {
        if ([_UserInformationDict[@"status"] integerValue] == 1) {
            if (![self isBlankString:_UserInformationDict[@"bankNo"]]) {
                InvestorsBankNo = _UserInformationDict[@"bankNo"];
            }
            if ([self isLegalObject:_UserInformationDict[@"account"]]) {
                InvestorsBankcard_no = _UserInformationDict[@"account"];
            }
        } else {
            InvestorsBankcard_no = _BankCardField.text;
        }
    } else {
        InvestorsBankcard_no = _BankCardField.text;
    }
    
    //判断是否有支付密码
    if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]]) {
        if ([_UserInformationDict[@"pay"] integerValue] == 1) {
            _isHavePayPassworld = YES;
        }
    }
    
    if ([self isBlankString:InvestorsName]) {
        [self errorPrompt:3.0 promptStr:@"持卡人姓名为空"];
        return;
    }
    
    if ([self isBlankString:InvestorsID_no]) {
        [self errorPrompt:3.0 promptStr:@"身份证号为空"];
        return;
    }
    
    if ([self isBlankString:InvestorsBankcard_no]) {
        [self errorPrompt:3.0 promptStr:@"银行卡号为空"];
        return;
    }
    
    if ([self isBlankString:InvestorsBankNo]) {
        [self errorPrompt:3.0 promptStr:@"请选择发卡银行"];
        return;
    }
    
    if (self.bankPayChannel == BankPayFromBindingCard ||self.bankPayChannel == regYes) {
        if ([self isBlankString:self.citycode]) {
            [self errorPrompt:3.0 promptStr:@"请选择开户行所在地"];
            return;
        }
    }
    
    if (!(self.bankPayChannel == BankPayFromTender || self.bankPayChannel == BankPayFromUndertake)) {
        //        if ([self isBlankString:self.CodeTF.text]) {
        //            self.CodeTF.text = @"0.01";
        //            //[self errorPrompt:3.0 promptStr:@"短信验证码为空"];
        //            return;
        //        }
        //        if ([self.GetCodeButton.titleLabel.text isEqualToString:@"点击发送验证码"]) {
        //            [self errorPrompt:3.0 promptStr:@"请先点击发送验证码"];
        //            return;
        //        }
        
        //        if (self.CodeTF.text.length != 6) {
        //            [self errorPrompt:3.0 promptStr:@"请输入6位数的验证码"];
        //            return;
        //        }
    }
    
    //银行支付
    if (self.bankPayChannel == BankPayFromTender || self.bankPayChannel == BankPayFromUndertake) {
        if (!_isHavePayPassworld) {
            setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
            setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
                if (ishavePW) {
                    _isHavePayPassworld = YES;
                }
            };
            [self customPushViewController:setPaymentPassWorldView customNum:1];
        } else {
            self.payPassWorldView.textField.text = @"";
            [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPassWorldView];
        }
    }else{//绑定银行卡
        [self sureTappend]; //跳转到 XRPayWordViewDelegate 里面确定按钮
    }
}

//收起键盘
- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - HTTP
- (void)sendCode{
    //[self setSendButton];
    NSDictionary *parameters = @{@"acc_no":     _UserInformationDict[@"account"],
                                 @"money":     self.bankPaymoney,
                                 @"mobile":     getObjectFromUserDefaults(MOBILE),
                                 @"uid":      getObjectFromUserDefaults(UID),
                                 @"sid":    getObjectFromUserDefaults(SID),
                                 @"at":     getObjectFromUserDefaults(ACCESSTOKEN)};
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@getBfPaySms",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        WS(weakSelf);
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf sendCode];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf sendCode];
                } withFailureBlock:^{
                    
                }];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        
    }];
}

/**
 *  获取绑卡验证码
 */
//- (void)getiPhoneCodeRequest{
//
//    [self.view endEditing:YES];
//    //投资人的身份信息
//    if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
//        if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
//            InvestorsName = _UserInformationDict[@"userName"];
//            InvestorsID_no = _UserInformationDict[@"idNumber"];
//        } else {
//            InvestorsName = _nameField.text;
//            InvestorsID_no = _CardidField.text;
//        }
//    } else {
//        InvestorsName = _nameField.text;
//        InvestorsID_no = _CardidField.text;
//    }
//
//    // 投资人得银行卡信息
//    if (![_UserInformationDict[@"status"] isKindOfClass:[NSNull class]]) {
//        if ([_UserInformationDict[@"status"] integerValue] == 1) {
//            if (![self isBlankString:_UserInformationDict[@"bankNo"]]) {
//                InvestorsBankNo = _UserInformationDict[@"bankNo"];
//            }
//            if ([self isLegalObject:_UserInformationDict[@"account"]]) {
//                InvestorsBankcard_no = _UserInformationDict[@"account"];
//            }
//        } else {
//            InvestorsBankcard_no = _BankCardField.text;
//        }
//    } else {
//        InvestorsBankcard_no = _BankCardField.text;
//    }
//
//    if ([self isBlankString:InvestorsName]) {
//        [self errorPrompt:3.0 promptStr:@"持卡人姓名为空"];
//        return;
//    }
//
//    if ([self isBlankString:InvestorsID_no]) {
//        [self errorPrompt:3.0 promptStr:@"身份证号为空"];
//        return;
//    }
//
//    if ([self isBlankString:InvestorsBankNo]) {
//        [self errorPrompt:3.0 promptStr:@"请选择银行卡"];
//        return;
//    }
//
//    if ([self isBlankString:InvestorsBankcard_no]) {
//        [self errorPrompt:3.0 promptStr:@"银行卡号为空"];
//        return;
//    }
//
//    [self setSendButton];
//    NSDictionary *parameters = @{@"acc_no":  self.BankCardField.text,
//                                 @"mobile":   getObjectFromUserDefaults(MOBILE),
//                                 @"sid":      getObjectFromUserDefaults(SID),
//                                 @"uid":     getObjectFromUserDefaults(UID),
//                                 @"at":      getObjectFromUserDefaults(ACCESSTOKEN)};
//    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/sendBaoFuSmsForBindH",GeneralWebsite] parameters:parameters success:^(id responseObject) {
//        if (responseObject[@"r"]) {
//            WS(weakSelf);
//            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                NSLog(@"%@",responseObject);
//            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
//                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
//                    [weakSelf getiPhoneCodeRequest];
//                } withFailureBlock:^{
//
//                }];
//            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
//                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
//                    [weakSelf getiPhoneCodeRequest];
//                } withFailureBlock:^{
//
//                }];
//            }else{
//                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
//            }
//        }
//    } fail:^{
//
//    }];
//}

/**
 *  绑卡接口
 */
#pragma mark - 绑卡接口
//- (void)theOnCaed{
//    NSDictionary *parameters = @{@"at"    : getObjectFromUserDefaults(ACCESSTOKEN),
//                                 @"sid"   : getObjectFromUserDefaults(SID),
//                                 @"uid"   : getObjectFromUserDefaults(UID),
//                                 @"mobile": getObjectFromUserDefaults(MOBILE),
//                                 @"acc_no" : InvestorsBankcard_no,
//                                 @"id_card": InvestorsID_no,
//                                 @"bankno" : InvestorsBankNo,
//                                 @"accntnm": InvestorsName,
//                                 @"sms_code": self.CodeTF.text,
//                                 @"cityId"  : self.citycode?self.citycode:@""};
//    [self showWithDataRequestStatus:@"请求中..."];/*绑卡请求中*/
//    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/bindBaofuCardH",GeneralWebsite] parameters:parameters success:^(id responseObject) {
//        if (responseObject[@"r"]) {
//            WS(weakSelf);
//            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                self.isRefresh(YES);
//                [self showWithSuccessWithStatus:@"绑卡成功"];
//                [self XROnCustEvent1AuthenticationSuccess];//认证 自定义效果点
//               [self performSelector:@selector(goBack) withObject:nil afterDelay:3.0f];
//            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
//                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
//                    [weakSelf sureTappend];
//                } withFailureBlock:^{
//
//                }];
//            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
//                [self errorPrompt:3.0 promptStr:@"请求网络超时,请重试！"];
//            }else{
//                [self dismissWithDataRequestStatus];
//                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
//            }
//        }
//    } fail:^{
//        [self errorPrompt:3.0 promptStr:errorPromptString];
//    }];
//}


- (void)theOnCaed{
    if ([self.CodeTF.text isEqualToString:@""]) {
        self.CodeTF.text = @"0.01";
    }
    NSDictionary *parameters = @{@"at"    : getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"sid"   : getObjectFromUserDefaults(SID),
                                 @"uid"   : getObjectFromUserDefaults(UID),
                                 @"mobile": getObjectFromUserDefaults(MOBILE),
                                 @"card_no" : InvestorsBankcard_no,
                                 @"id_card": InvestorsID_no,
                                 @"bankno" : InvestorsBankNo,
                                 @"accntnm": InvestorsName,
                                 @"money": self.CodeTF.text,
                                 @"appType"  : @"101"};
    [self showWithDataRequestStatus:@"请求中..."];/*绑卡请求中*/
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/lianlianRechargeBindCard",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (responseObject[@"r"]) {
            WS(weakSelf);
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                self.isRefresh(YES);
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _bankPayInfo = [responseObject[@"item"] copy];
                    
                    //                   [self loadBankPayFuyouPage:_bankPayInfo];  /*富友介入方案 */
                    [self loadLianlianPayRechargePage]; /**连连方案*/
                    [self dismissWithDataRequestStatus];
                }
                //                [self showWithSuccessWithStatus:@"绑卡成功"];
                //                [self XROnCustEvent1AuthenticationSuccess];//认证 自定义效果点
                //                [self performSelector:@selector(goBack) withObject:nil afterDelay:3.0f];
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTappend];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [self errorPrompt:3.0 promptStr:@"请求网络超时,请重试！"];
            }else{
                [self dismissWithDataRequestStatus];
                [self shakeView:_payPassWorldView];
                
                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self shakeView:_payPassWorldView];

        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}
-(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

#pragma mark - 投标混合支付 银行卡
- (void)tenderPay{
    [self.payPassWorldView.textField resignFirstResponder];
    if ([self isBlankString:_bidPasswordString]) {
        _bidPasswordString = @"";
    }
    NSString *urlString = @"";
    if (_isOptimizationBid) {
        urlString = @"bank/sdInvestBid";
    } else {
        urlString = @"bank/sdBid";
    }
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"bid": _productBID,
                                  // @"payPassword": [WDEncrypt md5FromString:payview.payPassworldTF.text],
                                  @"payPassword": [NetManager TripleDES:self.payPassWorldView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]  ,
                                  @"tenderAmount": _payAounmtMoneyString,
                                  @"source": @"101",
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"bidPassword": [NetManager TripleDES:_bidPasswordString encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"name": InvestorsName,
                                  @"id_no": InvestorsID_no,
                                  @"card_no": InvestorsBankcard_no,
                                  @"bankId": _UserInformationDict[@"bankId"],
                                  @"rechargeAmount": self.bankPaymoney,
                                  @"recordId": self.recordId,
                                  @"sms_code":  self.CodeTF.text,
                                  @"redpackSource":self.redpackSource,
                                  @"isNewChannel":@"1"};
    //显示支付加载框
    //    [self showInpayingLoadingView:self];
    [self showWithDataRequestStatus:@"安全支付中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, urlString] parameters:parameters success:^(id responseObject) {
        //        NSLog(@"校验返回信息 : %@",responseObject);
        [self.payPassWorldView clearUpPassword];
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf tenderPay];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf tenderPay];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self hideInpayingLoadingView];
                [self dismissWithDataRequestStatus];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _bankPayInfo = [responseObject[@"item"] copy];
                    //                   [self loadBankPayFuyouPage:_bankPayInfo];  /*富友介入方案 */
                    [self loadLianlianPayRechargePage]; /**连连方案*/
                }
                
                /*宝付方案*/
                //                WithDrawDetailsViewController *WithDrawDetailsView =
                //                [[WithDrawDetailsViewController alloc]
                //                 initWithNibName:@"WithDrawDetailsViewController"
                //                 bundle:nil];
                //                WithDrawDetailsView.payMonryString = self.payAounmtMoneyString;
                //                WithDrawDetailsView.titleString = @"投标申请";
                //                WithDrawDetailsView.pushNumber = 0;
                //                WithDrawDetailsView.bidNameString = _bidNameString;
                //                [self customPushViewController:WithDrawDetailsView customNum:0];
                
            } else {
                //隐藏支付加载框
                //                [self hideInpayingLoadingView];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  //隐藏支付加载框
                                  //                                  [self hideInpayingLoadingView];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}
#pragma mark -  富友 接入入方案
- (void)loadBankPayFuyouPage:(NSDictionary *)bankPayData
{
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"] ;
    
    NSString * myMCHNTORDERID = [NSString stringWithFormat:@"%@",bankPayData[@"mchntOrdId"]];  // 商户订单号MAX(20)
    NSString * myMCHNTCD =  [NSString stringWithFormat:@"%@",bankPayData[@"mchNtCd"]]; //商户号(15)
    NSString * myUSERID =  [NSString stringWithFormat:@"%@",bankPayData[@"userId"]];  // 用户ID MAX(20)
    
    //    CGFloat myAMT_f =[self.rechargePriceTextFeild.text floatValue] * 100;
    NSString * myAMT = [NSString stringWithFormat:@"%.0f", [bankPayData[@"amt" ] floatValue]];//  订单金额 MAX(12)，单位为分
    NSString * myBANKCARD =  [NSString stringWithFormat:@"%@",bankPayData[@"bankCard"]];//银行卡号 MAX（20）0
    
    NSString * myBACKURL =  [NSString stringWithFormat:@"%@",bankPayData[@"murl"]]; //回调地址
    NSString * myNAME =  [NSString stringWithFormat:@"%@",bankPayData[@"name"]] ;   //姓名
    NSString * myIDNO =  [NSString stringWithFormat:@"%@",bankPayData[@"idNo"]];  // 身份证号
    NSString * myIDTYPE =  [NSString stringWithFormat:@"%@",bankPayData[@"idType"]];   //  证件类型，目前只支持身份证，代号（0）
    
    NSString * myTYPE = [NSString stringWithFormat:@"02"] ;
    NSString * mySIGNTP = [NSString stringWithFormat:@"MD5"] ;
    NSString * myMCHNTCDKEY =  [NSString stringWithFormat:@"%@",bankPayData[@"mchntKey"]];  // 商户秘钥
    NSString * mySIGN = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@" , myTYPE,myVERSION,myMCHNTCD,myMCHNTORDERID,myUSERID,myAMT,myBANKCARD,myBACKURL,myNAME,myIDNO,myIDTYPE,myMCHNTCDKEY] ;
    
    mySIGN = [mySIGN MD5String];
    NSDictionary * dicD = @{@"TYPE":myTYPE,@"VERSION":myVERSION,@"MCHNTCD":myMCHNTCD,@"MCHNTORDERID":myMCHNTORDERID,@"USERID":myUSERID,@"AMT":myAMT,@"BANKCARD":myBANKCARD,@"BACKURL":myBACKURL,@"NAME":myNAME,@"IDNO":myIDNO,@"IDTYPE":myIDTYPE,@"SIGNTP":mySIGNTP,@"SIGN":mySIGN} ;
    
    FUMobilePay * pay = [FUMobilePay shareInstance];
    if([pay respondsToSelector:@selector(mobilePay:delegate:)])
        [pay performSelector:@selector(mobilePay:delegate:) withObject:dicD withObject:self];
}

//实现FYPayDelegate 代理 支付结果回调方法 此处接收支付结果
- (void)payCallBack:(BOOL)success responseParams:(NSDictionary *)responseParams
{
    if (success) {
        
        WithDrawDetailsViewController *WithDrawDetailsView =
        [[WithDrawDetailsViewController alloc]
         initWithNibName:@"WithDrawDetailsViewController"
         bundle:nil];
        if (self.bankPayChannel == BankPayFromTender) {
            WithDrawDetailsView.titleString = @"投标申请";
            WithDrawDetailsView.pushNumber = 0;
        }else{
            WithDrawDetailsView.pushNumber = 33;
            WithDrawDetailsView.titleString = @"承接申请";
        }
        WithDrawDetailsView.payMonryString = self.payAounmtMoneyString;
        WithDrawDetailsView.bidNameString = _bidNameString;
        [self customPushViewController:WithDrawDetailsView customNum:0];
        
    }else if([responseParams[@"RESPONSECODE"] isEqualToString:@"-2"]){
        [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"充值失败,参数:%@",responseParams[@"RESPONSEMSG"]]];
        
    }else if ([responseParams[@"RESPONSECODE"] isEqualToString:@"8143"]){
        [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"充值失败,参数:%@",responseParams[@"RESPONSEMSG"]]];
        
    }else{//失败
        [self errorPrompt:3.0 promptStr:responseParams[@"RESPONSEMSG"]];
        NSLog(@"失败原因:%@",responseParams[@"RESPONSEMSG"]);
    }
}
#pragma mark - 连连支付接入方案
- (void)loadLianlianPayRechargePage
{
    if (self.bankPayChannel == BankPayFromUndertake) {
        _bankPayInfo = [_bankPayDict copy];
    }else if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes){
        _cardDict = @{};
        if (_bankPayInfo == nil) {
            return;
        } else {
            _cardDict = @{ @"acct_name"   : _bankPayInfo[@"acct_name"], //self.nameField.text
                           @"busi_partner": _bankPayInfo[@"busi_partner"],
                           @"card_no"     : _bankPayInfo[@"card_no"], //self.BankCardField.text
                           @"dt_order"    : _bankPayInfo[@"dt_order"],
                           @"id_no"       : _bankPayInfo[@"id_no"], //self.CardidField.text
                           @"money_order" : _bankPayInfo[@"money_order"],
                           @"no_order"    : _bankPayInfo[@"no_order"],
                           @"notify_url"  : _bankPayInfo[@"notify_url"],
                           @"oid_partner" : _bankPayInfo[@"oid_partner"],
                           @"risk_item"   : _bankPayInfo[@"risk_item"],
                           @"sign_type"   : _bankPayInfo[@"sign_type"],
                           @"sign"        : _bankPayInfo[@"sign"],
                           @"user_id"     : _bankPayInfo[@"user_id"],
                           @"valid_order" : _bankPayInfo[@"valid_order"],
                           @"info_order"  : _bankPayInfo[@"info_order"],
                           @"name_goods"  : _bankPayInfo[@"name_goods"]};
            NSLog(@"%@", _orderParamDict);
            [self payWithSignedOrder:_cardDict];
        }
        
    }
    _orderParamDict = @{};
    if (_bankPayInfo == nil) {
        return;
    } else if ([self isBlankString:_bankPayInfo[@"no_order"]]) {
        [self errorPrompt:3.0 promptStr:@"订单号为空"];
    } else if ([self isBlankString:_bankPayInfo[@"dt_order"]]) {
        [self errorPrompt:3.0 promptStr:@"商户订单时间为空"];
    } else if ([self isBlankString:_bankPayInfo[@"money_order"]]) {
        [self errorPrompt:3.0 promptStr:@"大侠你要充值多少钱呀"];
    } else if ([self isBlankString:_bankPayInfo[@"busi_partner"]]) {
        [self errorPrompt:3.0 promptStr:@"业务类型为空"];
    } else if ([self isBlankString:_bankPayInfo[@"sign_type"]]) {
        [self errorPrompt:3.0 promptStr:@"没有加密方式"];
    } else if ([self isBlankString:_bankPayInfo[@"sign"]]) {
        [self errorPrompt:3.0 promptStr:@"加密字符串"];
    } else if ([self isBlankString:_bankPayInfo[@"user_id"]]) {
        [self errorPrompt:3.0 promptStr:@"用户id用空"];
    } else if ([self isBlankString:_bankPayInfo[@"oid_partner"]]) {
        [self errorPrompt:3.0 promptStr:@"商户号为空"];
    } else if ([self isBlankString:_bankPayInfo[@"valid_order"]]) {
        [self errorPrompt:3.0 promptStr:@"过期时间为空"];
    } else if ([self isBlankString:_bankPayInfo[@"acct_name"]]) {
        [self errorPrompt:3.0 promptStr:@"姓名为空"];
    } else if ([self isBlankString:_bankPayInfo[@"id_no"]]) {
        [self errorPrompt:3.0 promptStr:@"身份证号码为空"];
    } else if ([self isBlankString:_bankPayInfo[@"card_no"]]) {
        [self errorPrompt:3.0 promptStr:@"银行卡号为空"];
    } else {
        _orderParamDict = @{ @"acct_name"   : _bankPayInfo[@"acct_name"], //self.nameField.text
                             @"busi_partner": _bankPayInfo[@"busi_partner"],
                             @"card_no"     : _bankPayInfo[@"card_no"], //self.BankCardField.text
                             @"dt_order"    : _bankPayInfo[@"dt_order"],
                             @"id_no"       : _bankPayInfo[@"id_no"], //self.CardidField.text
                             @"money_order" : _bankPayInfo[@"money_order"],
                             @"no_order"    : _bankPayInfo[@"no_order"],
                             @"notify_url"  : _bankPayInfo[@"notify_url"],
                             @"oid_partner" : _bankPayInfo[@"oid_partner"],
                             @"risk_item"   : _bankPayInfo[@"risk_item"],
                             @"sign_type"   : _bankPayInfo[@"sign_type"],
                             @"sign"        : _bankPayInfo[@"sign"],
                             @"user_id"     : _bankPayInfo[@"user_id"],
                             @"valid_order" : _bankPayInfo[@"valid_order"],
                             @"info_order"  : _bankPayInfo[@"info_order"],
                             @"name_goods"  : _bankPayInfo[@"name_goods"]};
        NSLog(@"%@", _orderParamDict);
        [self payWithSignedOrder:_orderParamDict];
    }
}

- (void)payWithSignedOrder:(NSDictionary *)signedOrder {
    self.llPaysdk = [[LLPaySdk alloc] init];
    //    self.llPaysdk.sdkDelegate = self; //开发提示 没有设置代理
    [LLPaySdk sharedSdk].sdkDelegate = self;//遵从代理
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:LLPayTypeVerify
                                            andTraderInfo:signedOrder];
    
    //    self.sdk = [[[LL***PaySdk alloc] init] autorealse]; // 创建
    //    self.sdk.sdkDelegate = self;  // 设置回调
    //    NSDictionary* signedDic = **** // 加过签名的订单字典
    //    [self.sdk presentPaySdkInViewController:rootVC withTraderInfo:signedDic];
    
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            NSString *result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                //                NSString *payBackAgreeNo = dic[@"agreementno"];
                //                _agreeNumField.text = payBackAgreeNo;
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = @"支付单处理中";
            } else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = @"支付单失败";
            } else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = @"支付单已退款";
            }
        } break;
        case kLLPayResultFail: {
            msg = @"支付失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"支付取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    //连连支付返回，充值状态存到数据库
    LLPayresultCode = resultCode;
    LLPayMessage = msg;
    [self saveRechargeToData];
    //支付成功之后做一些处理
    if ([msg isEqualToString:@"支付成功"]) {
        if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes) {
            self.isRefresh(YES);
            [self showWithSuccessWithStatus:@"绑卡成功"];
            [self customPopViewController:0];
            return;
        }
        WithDrawDetailsViewController *WithDrawDetailsView =
        [[WithDrawDetailsViewController alloc]
         initWithNibName:@"WithDrawDetailsViewController"
         bundle:nil];
        if (self.bankPayChannel == BankPayFromTender) {
            //            WithDrawDetailsView.titleString = @"投标申请";
            //            WithDrawDetailsView.pushNumber = 0;
            PayYesViewController *payVC = [[PayYesViewController alloc]initWithNibName:@"PayYesViewController" bundle:nil];
            payVC.moen = self.payAounmtMoneyString;
            [self customPushViewController:payVC customNum:0];
            
        }else{
            WithDrawDetailsView.pushNumber = 33;
            WithDrawDetailsView.titleString = @"承接申请";
        }
        WithDrawDetailsView.payMonryString = self.payAounmtMoneyString;
        WithDrawDetailsView.bidNameString = _bidNameString;
        [self customPushViewController:WithDrawDetailsView customNum:0];
        
    } else {
        [self errorPrompt:3.0 promptStr:msg];
    }
}


/*
 Printing description of parameter:
 {
 at = M41c41c4881c309dedfb4c86a51f5ad8f;
 code = 2;
 message = "\U652f\U4ed8\U53d6\U6d88";
 orderid = 022017032822493904220705407;
 sid = 5b3af4b74a19cefd2e412487661aa13d;
 "source_end" = IOS;
 uid = 169354;
 }
 */
#pragma mark - 充值状态存到数据库
- (void)saveRechargeToData {
    WS(weakSelf);
    NSDictionary *parameter = @{ @"code": [NSString stringWithFormat:@"%zd", LLPayresultCode],
                                 @"appType": @"101",
                                 @"orderid": _bankPayInfo[@"no_order"],
                                 @"uid": getObjectFromUserDefaults(UID),
                                 @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"sid": getObjectFromUserDefaults(SID),
                                 @"message": LLPayMessage };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/phoneRechargeCallback", GeneralWebsite] parameters:parameter success:^(id responseObject) {
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf saveRechargeToData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf saveRechargeToData];
                } withFailureBlock:^{
                    
                }];
            }
        }
    }
                              fail:^{
                                  
                              }];
}


//废弃 ？ 没找到相关
- (void)gotoPay{
    NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                 @"sid":    getObjectFromUserDefaults(SID),
                                 @"at":    getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"money":   self.bankPaymoney,
                                 @"appType":   @"101",
                                 @"name":    _UserInformationDict[@"userName"],
                                 @"id_no":    _UserInformationDict[@"idNumber"],
                                 @"card_no":   _UserInformationDict[@"account"],
                                 @"bankId":   _UserInformationDict[@"bankId"],
                                 @"pwd":  [NetManager TripleDES:self.payPassWorldView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]  ,
                                 @"sms_code":   self.CodeTF.text};
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/BaoFuRecharge",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        WS(weakSelf);
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTappend];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTappend];
                } withFailureBlock:^{
                    
                }];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        
    }];
}

#pragma mark - 承接混合支付 银行卡
- (void)gotoPayInTranfering {
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"bid": _productBID,
                                  @"pwd": [NetManager TripleDES:self.payPassWorldView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"appType": @"101",
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"transpwd": [NetManager TripleDES:_bidPasswordString encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"name": InvestorsName,
                                  @"id_no": InvestorsID_no,
                                  @"card_no": InvestorsBankcard_no,
                                  @"bankId": _UserInformationDict[@"bankId"],
                                  @"tenderAmount": self.bankPaymoney,
                                  @"tid": _tranferId,
                                  @"version": @"4",
                                  @"sms_code":   self.CodeTF.text,
                                  @"isNewChannel":@"1"};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/notEnoughTransBid", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf gotoPayInTranfering];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf gotoPayInTranfering];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    //承接  银行卡混合支付后台数据  （连连 富友  返回数据）
                    _bankPayDict = [responseObject[@"item"] copy];
                    //隐藏支付加载框
                    //                    [self hideInpayingLoadingView];
                    [self dismissWithDataRequestStatus];
                    //                    [self loadBankPayFuyouPage:_bankPayDict];   /*富友介入方案 */
                    [self loadLianlianPayRechargePage];       /*连连介入方案 */
                    
                    /*宝付处理方案*/
                    //                    WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
                    //                    WithDrawDetailsView.payMonryString = self.payAounmtMoneyString;
                    //                    WithDrawDetailsView.bidNameString = self.bidNameString;
                    //                    WithDrawDetailsView.pushNumber = 33;
                    //                    WithDrawDetailsView.titleString = @"承接申请";
                    //                    [self customPushViewController:WithDrawDetailsView customNum:0];
                }
            } else {
                //隐藏支付加载框
                //                [self hideInpayingLoadingView];
                [self.payPassWorldView clearUpPassword];

                [self shakeView:self.payPassWorldView];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self.payPassWorldView clearUpPassword];

                                  [self shakeView:self.payPassWorldView];

                                  //隐藏支付加载框
                                  //                                  [self hideInpayingLoadingView];
                                  [self errorPrompt:3.0 promptStr:@"交易失败"];
                              }];
}

//获取交易密码加密字
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    //添加支付加载框
    //    [self showInpayingLoadingView:self];
    [self showWithDataRequestStatus:@"安全支付中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                _sedpassedString = responseObject[@"sedpassed"];
                if (![self isBlankString:_sedpassedString]) {
                    if (self.bankPayChannel == BankPayFromUndertake) {
                        [self gotoPayInTranfering];
                    }else{//容错
                        [self errorPrompt:3.0 promptStr:@"获取信息出错,请重试"];
                    }
                }else{//容错
                    [self errorPrompt:3.0 promptStr:@"获取信息出错,请重试"];
                }
            } else {
                //                [self hideInpayingLoadingView];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  //                                  [self hideInpayingLoadingView];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}


#pragma mark - CustomUINavBarDelegate
- (void)goBack {
    if (self.bankPayChannel == BankPayFromTender || self.pushNumber == 33 || self.bankPayChannel == BankPayFromUndertake || self.bankPayChannel == BankPayFromBindingCard) {
        [self customPopViewController:0];
    } else {
        [self customPopViewController:3];
    }
}

#pragma mark - XRPayPassWorldViewDelegate
- (void)sureTappend{
    if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes) {
        [self theOnCaed];
        //绑卡时   支付视图不退出  bug
        //        return;
        [self cancelTappend];
    }
    
    if (self.bankPayChannel == BankPayFromTender) {
        [self tenderPay];
        //        return;
        [self cancelTappend];
    }
    
    if (self.bankPayChannel == BankPayFromUndertake) {
        [self getEncryptionString];
    }
    
    
}

- (void)cancelTappend{
    
    [self dismissPopupController];
}

- (void)forgetPassWorldTappend{
    
    [self.payPassWorldView clearUpPassword];
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);
    [self customPushViewController:VerificationCode customNum:0];
}

#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
            if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
                return 1;
            } else {
                return 2;
            }
        } else {
            return 2;
        }
    } else if (section == 1) {
        if ([self isLegalObject:_UserInformationDict[@"state"]]) {
            if ([_UserInformationDict[@"state"] integerValue] != 2) {
                return 1;
            } else {
                if (self.bankPayChannel==BankPayFromTender||self.bankPayChannel==BankPayFromUndertake) {
                    return 2;
                }
                return 3;
            }
        } else {
            if (self.bankPayChannel==BankPayFromTender||self.bankPayChannel==BankPayFromUndertake) {
                return 2;
            }
            return 3;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes) {
            return 0.5;
        }else{
            return 0.5;
        }
    }
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *personMessage = [[UILabel alloc] init];
    personMessage.font = [UIFont systemFontOfSize:14.0];
    personMessage.textColor = [self colorFromHexRGB:@"898989"];
    if (section == 0) {
        personMessage.text = @"    持卡人信息";
    } else {
        personMessage.text = @"    银行卡信息";
    }
    return personMessage;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        self.codesView.frame = CGRectMake(0, 0, iPhoneWidth, 85);
        return self.codesView;
    }else{
        if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes) {
            UILabel * footerLabel = [[UILabel alloc] init];
            footerLabel.textColor = [UIColor redColor];
            footerLabel.font = [UIFont systemFontOfSize:13];
            return footerLabel;
        }
        return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableViewID = @"BindingBankCardTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewID];
    }
    cell.textLabel.font = TextFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (![_UserInformationDict[@"realStatus"] isKindOfClass:[NSNull class]]) {
            if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
                NSLog(@"realStatus = %@",_UserInformationDict[@"realStatus"]);
                cell.textLabel.text = @"身份信息";
                [cell.contentView addSubview:self.CardidField];
            } else {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"姓名";
                    [cell.contentView addSubview:self.nameField];
                } else {
                    cell.textLabel.text = @"身份证";
                    [cell.contentView addSubview:self.CardidField];
                }
            }
        } else {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"姓名";
                [cell.contentView addSubview:self.nameField];
            } else {
                cell.textLabel.text = @"身份证";
                [cell.contentView addSubview:self.CardidField];
            }
        }
    } else {
        if ([self isLegalObject:_UserInformationDict[@"state"]]) {
            if ([_UserInformationDict[@"state"] integerValue] != 2) {
                cell.textLabel.text = @"银行信息";
                [cell.contentView addSubview:self.BankCardField];
            } else {
                if (indexPath.row == 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"发卡银行";
                    [cell.contentView addSubview:self.BankNameField];
                }else if(indexPath.row == 1){
                    cell.textLabel.text = @"银行卡号";
                    [cell.contentView addSubview:self.BankCardField];
                }else{//投标承接不走
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"开户行所在地";
                    [cell.contentView addSubview:self.BankCityField];
                }
            }
        } else {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"银行卡";
                [cell.contentView addSubview:self.BankNameField];
            } else if(indexPath.row == 1){
                cell.textLabel.text = @"银行卡号";
                [cell.contentView addSubview:self.BankCardField];
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"开户行所在地";
                [cell.contentView addSubview:self.BankCityField];
            }
        }
    }
    return cell;
}

#pragma mark - UITextField
- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:UITextFieldFram];
        _nameField.font = TextFont;
        _nameField.delegate = self;
        if ([self isLegalObject:_UserInformationDict[@"realStatus"]]) {
            //            NSLog(@"_UserInformationDict = %@",_UserInformationDict);
            if ([_UserInformationDict[@"realStatus"] integerValue] == 1 && ![_UserInformationDict[@"userNameHidden"] isEqualToString:@""]) {//解绑后为1,走此   正常注册1
                if ([self isLegalObject:_UserInformationDict[@"userNameHidden"]]) {
                    _nameField.text = _UserInformationDict[@"userNameHidden"];
                    _nameField.enabled = NO;
                }
                
            }else{//[_UserInformationDict[@"userNameHidden"] isEqualToString:@""]
                
                _nameField.placeholder = @"请输入持卡人姓名";
                _nameField.enabled = YES;
            }
        }
    }
    return _nameField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag != 7777) {
        //  self.contentScrollView.contentSize = CGSizeMake(iPhoneWidth, self.contentScrollView.contentSize.height + 216);//不知道啥作用 反而滑动区域变大
    }
    
    if (textField.tag == 10086) {
        [self.BankCardField resignFirstResponder];
        NSLog(@"我在做选择银行卡的动作");
        //        self.contentScrollView.contentSize = CGSizeMake(iPhoneWidth, self.contentScrollView.contentSize.height - 216);//同上
        BankListViewController *bankListView = [[BankListViewController alloc] initWithNibName:@"BankListViewController" bundle:nil];
        bankListView.backBankDict = ^(NSDictionary *bankListDict) {
            if (bankListDict != nil) {
                _bankDict = [bankListDict copy];
                _BankNameField.text = [NSString stringWithFormat:@"%@", bankListDict[@"name"]];
                [self settingBankNameImageViewFrame];
                UIImage * bankImage= [UIImage imageNamed:bankListDict[@"bankNo"]];
                _BankImageView.image = bankImage?bankImage:[UIImage imageNamed:@"bank_icon_default"];
                [_BankNameField addSubview:_BankImageView];
                //添加左边图片
                //                UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bankListDict[@"bankNo"]]];
                //                _BankNameField.leftView = UserNameleftImageView;
                //                _BankNameField.leftViewMode = UITextFieldViewModeAlways;
                QuotaString = bankListDict[@"info"];
                if ([self isLegalObject:bankListDict[@"bankNo"]]) {
                    InvestorsBankNo = bankListDict[@"bankNo"];
                }
                [self.ShowTableview reloadData];
            }
        };
        if (_bankDict != nil) {
            bankListView.bankName = [_bankDict objectForKey:@"name"];
        }
        [self customPushViewController:bankListView customNum:0];
    }else if (textField.tag == 10010) {
        NSLog(@"我在做选择城市的动作");
        [self.view endEditing:YES];
        
        [self.view addSubview:self.coverView];
        [self.view addSubview:self.pickerBgView];
        self.coverView.alpha = 0;
        
        CGRect pickerBgViewRect = self.pickerBgView.frame;
        pickerBgViewRect.origin.y = self.view.frame.size.height;
        self.pickerBgView.frame = pickerBgViewRect;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.coverView.alpha = 0.3;
            CGRect pickerBgViewRect = self.pickerBgView.frame;
            CGFloat pickerViewH = self.pickerBgView.frame.size.height;
            pickerBgViewRect.origin.y = self.view.frame.size.height - pickerViewH;
            self.pickerBgView.frame = pickerBgViewRect;
        }];
        
        //                [self.ShowTableview reloadData];
        
        
    }else if (textField.tag == 8888) {
        return YES;
    } else if (textField.tag == 9999) {
        if (_BankCardField.text.length > 0) {
            _BankCardField.font = [UIFont systemFontOfSize:20];
        }
        return YES;
    } else if (textField.tag == 66666) {
        return YES;
    } else if (textField == _nameField) {
        
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag == 9999) {
        _BankCardField.font = TextFont;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 66666) {
        _CardidField.font = TextFont;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //限制输入两位小数
    if (textField.tag == 8888) {
        NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
        [futureString insertString:string atIndex:range.location];
        NSInteger flag = 0;
        const NSInteger limited = 2;
        for (NSInteger i = futureString.length - 1; i >= 0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
    } else if (textField.tag == 9999) {
        if (_BankCardField.text.length > 0) {
            _BankCardField.font = [UIFont systemFontOfSize:20];
            if (string.length == 0) {
                return YES;
            }
            NSInteger existedLength = _BankCardField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength > 19) {
                return NO;
            }
        }
    } else if (textField.tag == 66666) {
        if (_CardidField.text.length > 0) {
            _CardidField.font = [UIFont systemFontOfSize:20];
            if (string.length == 0) {
                return YES;
            }
            NSInteger existedLength = _CardidField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength > 18) {
                return NO;
            }
        }
    }
    
    /*
     if (textField == self.titleField) {
     if (textField.length > 20) return NO;
     }
     
     return YES;
     */
    
    
    return YES;
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

- (UITextField *)CardidField {
    if (!_CardidField) {
        _CardidField = [[UITextField alloc] initWithFrame:UITextFieldFram];
        _CardidField.font = TextFont;
        _CardidField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _CardidField.returnKeyType = UIReturnKeyDone;//身份证有X 字母出现
        if ([self isLegalObject:_UserInformationDict[@"realStatus"]]) {
            if ([_UserInformationDict[@"realStatus"] integerValue] == 0) {
                _CardidField.delegate = self;
                _CardidField.tag = 7777;
                _CardidField.text = [NSString stringWithFormat:@"%@ (%@)", _UserInformationDict[@"userNameHidden"], _UserInformationDict[@"idNumberHidden"]];
                InvestorsName = _UserInformationDict[@"userName"];
                InvestorsID_no = _UserInformationDict[@"idNumber"];
            } else {
                _CardidField.placeholder = @"请输入持卡人身份证号码";
                _CardidField.delegate = self;
                _CardidField.tag = 66666;
                if ([self isLegalObject:_UserInformationDict[@"realStatus"]]) {
                    if ([_UserInformationDict[@"realStatus"] integerValue] == 1 && ![_UserInformationDict[@"userNameHidden"] isEqualToString:@""]) {//解绑后是1 走此
                        if ([self isLegalObject:_UserInformationDict[@"idNumberHidden"]]) {
                            _CardidField.text = _UserInformationDict[@"idNumberHidden"];
                            _CardidField.enabled = NO;
                        }
                    }
                }
            }
        } else {
            _CardidField.placeholder = @"请输入持卡人身份证号码";
            _CardidField.delegate = self;
            _CardidField.enabled = YES;
            _CardidField.tag = 66666;
        }
    }
    return _CardidField;
}

- (UITextField *)BankNameField {
    if (!_BankNameField) {
        _BankNameField = [[UITextField alloc] initWithFrame:BankNameCityFram];
        _BankImageView = [[UIImageView alloc] init];
        _BankImageView.contentMode = UIViewContentModeScaleAspectFit;//20范围内等比例
        if ([self isLegalObject:_UserInformationDict[@"status"]]) {
            if ([_UserInformationDict[@"status"] integerValue] == 1) {
                //不好看 右对齐
                //                _BankNameField.textAlignment = NSTextAlignmentRight;
                //                _BankNameField.text = [NSString stringWithFormat:@"%@", _UserInformationDict[@"bank"]];
                //                [self settingBankNameImageViewFrame];
                //                _BankImageView.image = [UIImage imageNamed:_UserInformationDict[@"bankNo"]];
                //                [_BankNameField addSubview:_BankImageView];
                //                _BankNameField.enabled = NO;/*jinzhi*/
                _BankNameField.text = [NSString stringWithFormat:@"   %@", _UserInformationDict[@"bank"]];
                UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_UserInformationDict[@"bankNo"]]];
                _BankNameField.leftView = UserNameleftImageView;
                _BankNameField.leftViewMode = UITextFieldViewModeAlways;
                _BankNameField.enabled = NO;
            }
        }
        if (self.bankPayChannel == BankPayFromBindingCard  || self.bankPayChannel == regYes/*绑定银行卡*/ ) {
            _BankNameField.placeholder = @"选择银行卡";
//            _BankNameField.textAlignment = NSTextAlignmentRight;
            [_BankNameField setValue:[NSNumber numberWithInt:34] forKey:@"paddingLeft"];
            _BankNameField.textColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1/1.0];
//            [_BankNameField setValue:RGB(77, 186, 248) forKeyPath:@"_placeholderLabel.textColor"];
        }
        _BankNameField.delegate = self;
        _BankNameField.tag = 10086;
        _BankNameField.font = TextFont;
        //        [_BankNameField setValue:AppMianColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _BankNameField;
}
- (void)settingBankNameImageViewFrame
{
    //自适应位置
    CGSize textSize = [self labelAutoCalculateRectWith:_BankNameField.text FontSize:15 MaxSize:CGSizeMake(iPhoneWidth*0.61, MAXFLOAT)];
    CGFloat bankimageX = CGRectGetWidth(_BankNameField.frame)-textSize.width-15-10;
    _BankImageView.frame = CGRectMake(bankimageX, 14.5, 15, 15);
}

- (UITextField *)BankCardField {
    if (!_BankCardField) {
        _BankCardField = [[UITextField alloc] initWithFrame:UITextFieldFram];
        _BankCardField.font = TextFont;
        _BankCardField.delegate = self;
        _BankCardField.tag = 9999;
        _BankCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _BankCardField.keyboardType = UIKeyboardTypeNumberPad;
        [_BankCardField setValue:[NSNumber numberWithInt:50] forKey:@"paddingLeft"];

        if ([self isLegalObject:_UserInformationDict[@"state"]]) {
            if ([_UserInformationDict[@"state"] integerValue] != 2) {
                //status  等于1的时候有卡  不需要输入卡号
                _BankCardField.tag = 7777;
                UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_UserInformationDict[@"bank"]]];
                _BankCardField.leftView = UserNameleftImageView;
                _BankCardField.leftViewMode = UITextFieldViewModeAlways;
                _BankCardField.text = [NSString stringWithFormat:@" (%@)", _UserInformationDict[@"accountHidden"]];
            } else if ([_UserInformationDict[@"status"] integerValue] == 1) {
                _BankCardField.enabled = NO;/*jinzhi(不详走此法)*/
                _BankCardField.text = _UserInformationDict[@"account"];
            } /*else {
               _BankCardField.placeholder = @"请输入银行卡号";
               }*/
        }else {
            _BankCardField.placeholder = @"请输入银行卡号";
        }
    }
    return _BankCardField;
}

- (UITextField *)BankCityField {
    if (!_BankCityField) {
        _BankCityField = [[UITextField alloc] initWithFrame:BankNameCityFram];
        
        if ([self isLegalObject:_UserInformationDict[@"status"]]) {
            if ([_UserInformationDict[@"status"] integerValue] == 1) {
                _BankCityField.text = [NSString stringWithFormat:@"   %@", _UserInformationDict[@""]];//后台加返回值参数  city
            }
        }
        if (self.bankPayChannel == BankPayFromBindingCard || self.bankPayChannel == regYes/*绑定银行卡*/) {
            _BankCityField.placeholder = @"选择开户银行所在地";
//            _BankCityField.textAlignment = NSTextAlignmentRight;
            [_BankCityField setValue:[NSNumber numberWithInt:33] forKey:@"paddingLeft"];
            _BankCityField.textColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1/1.0];

//            [_BankCityField setValue:RGB(77, 186, 248) forKeyPath:@"_placeholderLabel.textColor"];
        }
        _BankCityField.delegate = self;
        _BankCityField.tag = 10010;
        _BankCityField.font = TextFont;
        //        [_BankNameField setValue:AppMianColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _BankCityField;
}

- (void)setSendButton{
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
                [self.GetCodeButton setTitle:@"点击发送验证码" forState:UIControlStateNormal];
                self.GetCodeButton.userInteractionEnabled = YES;
                [self.GetCodeButton setBackgroundColor:AppBtnColor];
            });
        }else{
            int seconds = _timeout % 600;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.GetCodeButton setTitle:[NSString stringWithFormat:@"(%@s)重新获取",strTime] forState:UIControlStateNormal];
                self.GetCodeButton.titleLabel.font=[UIFont systemFontOfSize:13];
                self.GetCodeButton.userInteractionEnabled = NO;
                
                [self.GetCodeButton setBackgroundColor:LineBackGroundColor];
            });
            _timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        // 如果是第1列, 那么应该显示所有的省的记录, 也就是说有多少个省, 第一列就显示多少行
        return self.areas.count;
    }else{
        
        // 第2列有多少行，取决于第一列选中了哪个省。
        // 获取第1列用户选中的行的索引
        NSInteger rowIdx = [self.cityPickerView selectedRowInComponent:0];
        CZProvince *province = self.areas[rowIdx];
        return province.city.count;
    }
}

#pragma mark 代理方法
//每行每列显示什么数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //第一列
    if (component == 0) {
        CZProvince *province = self.areas[row];
        return province.name;
    }else{
        //第二列
        //获取第一列选中的索引
        NSInteger provinceIdx = [self.cityPickerView selectedRowInComponent:0];
        // 2. 根据第一列选中行的索引, 找到对应的省份模型
        CZProvince *province = self.areas[provinceIdx];
        
        if (row < province.city.count) {
            // 3. 从省份模型中, 根据当前的row索引, 找到对应的城市信息, 并返回
            return province.city[row];
            
        }else{
            return nil;
        }
    }
}

//触发后选中某项
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //如果第是0列， 表示选中的省份发生变化
    if (component == 0) {
        //刷新第2列中的数据
        [self.cityPickerView reloadComponent:1];
        
        // 手动设置第二列的第0个被选中
        [self.cityPickerView selectRow:0 inComponent:1 animated:YES];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *myLabel = nil;
    if (component == 0) {
        myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];;
        myLabel.textAlignment = NSTextAlignmentCenter;
        CZProvince *province = self.areas[row];
        
        myLabel.text = province.name;
        myLabel.font = [UIFont systemFontOfSize:16];
    }else{
        
        myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.font = [UIFont systemFontOfSize:16];
        
        NSInteger provinceIdx = [self.cityPickerView selectedRowInComponent:0];
        // 2. 根据第一列选中行的索引, 找到对应的省份模型
        CZProvince *province = self.areas[provinceIdx];
        if (row < province.city.count) {
            
            myLabel.text = province.city[row][@"name"];
        }
    }
    return myLabel;
}


#pragma mark - ************* 懒加载地区数据 *************
- (NSArray *)areas
{
    if (_areas == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city-h5" ofType:@"json"];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        
        NSMutableArray *arrayDicts = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *arrayModels = [NSMutableArray array];
        
        for (NSDictionary *dict in arrayDicts) {
            CZProvince *model = [CZProvince provinceWithDict:dict];
            [arrayModels addObject:model];
        }
        _areas = arrayModels;
    }
    return _areas;
}

- (void)setFrame{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0;
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    self.pickerBgView.frame = CGRectMake(0, 0, iPhoneWidth, 180);
}

- (IBAction)cancelBtnClick:(id)sender {
    [self hideMyPicker];
}
- (void)hideMyPicker{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = 0;
        
        CGRect pickerBgViewRect = self.pickerBgView.frame;
        pickerBgViewRect.origin.y = self.view.frame.size.height;
        self.pickerBgView.frame = pickerBgViewRect;
        
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

- (IBAction)confirmBtnClick:(id)sender {
    
    // 1. 获取第0列当前被选中的行的索引
    NSInteger proIdx = [self.cityPickerView selectedRowInComponent:0];
    // 2. 获取第1列当前被选中的行的索引
    NSInteger cityIdx = [self.cityPickerView selectedRowInComponent:1];
    
    // 3. 根据索引去self.areas数组中查找数据, 并把数据显示到label上。
    CZProvince *province = self.areas[proIdx];
    //    self.selectedCity.text = province.name;
    if (cityIdx < province.city.count) {
        self.BankCityField.text = [NSString stringWithFormat:@"%@-%@", province.name, province.city[cityIdx][@"name"]];
        NSArray *areaArr = province.city[cityIdx][@"area"];
        self.citycode = areaArr.firstObject;
    }
    
    [self hideMyPicker];
    [self.ShowTableview reloadData];
}

//xgy添加
//#pragma mark 键盘即将退出
- (void)keyboardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.contentScrollView.transform = CGAffineTransformIdentity;
    }];
    
    //    if(isiPhone4 || isiPhone5){
    //        self.scrollView_login.scrollEnabled = NO;
    //    }
}

- (void)keyboardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = 0;
    ty = - rect.size.height * 0.8;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        if (self.CodeTF.editing) {
            self.contentScrollView.transform = CGAffineTransformMakeTranslation(0, ty);

        }
    }];
}

//xgy添加
//代理方法
- (void)textFieldFinished{
    
    [self.CodeTF resignFirstResponder];
}

@end
