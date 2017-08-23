//
//  RechargeMyAssetsViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BindingBankCardViewController.h"
#import "RechargeMyAssetsViewController.h"
#import "bankCardPublicView.h"
#import "XRPayPassWorldView.h"
#import "WithDrawDetailsViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "ForgetPassWdViewController.h"


//富友 文件
#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>

//连连支付
#import "LLPaySdk.h"

@interface RechargeMyAssetsViewController ()<FYPayDelegate,XRPayPassWorldViewDelegate,LLPaySdkDelegate>
{
    //连连支付返回的
    NSInteger LLPayresultCode;
    NSString *LLPayMessage;
}
@property (strong, nonatomic)XRPayPassWorldView *payPWDView;
@property (nonatomic, retain) LLPaySdk *llPaysdk;              //连连支付的sdk
@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;
@property (nonatomic,assign)__block int timeout;     //重新获取验证码时间
@property (nonatomic, copy) NSDictionary *orderParamDict; //储存连连支付的数据

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
- (IBAction)sendCodeButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bankCardView;//银行卡界面
@property (weak, nonatomic) IBOutlet UITextField *rechargePriceTextFeild;//充值金额输入框
@property (weak, nonatomic) IBOutlet UILabel *bank;//
@property (nonatomic, strong)NSDictionary *rechargeInfo;//后台充值数据
@property (weak, nonatomic) IBOutlet UIView *safeView;//安全

/**
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
- (IBAction)ConfirmButtonAction:(id)sender;
@end

@implementation RechargeMyAssetsViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rechargePriceTextFeild resignFirstResponder];
    [self.payPWDView.textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    CustomMadeNavigationControllerView *RechargeMyAssetsView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"充值" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:RechargeMyAssetsView];

    /*后续判断加上 区分宝付&富友*/
    self.codeView.hidden = NO;//必不可少
//    self.codeViewHeight.constant = 0;
    
//    [self addSafetyViewToSubview:self.safeView];//后加  picc
    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];

    [self.codeTextFeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setViewallControlStyle];
    
    _rechargePriceTextFeild.delegate = self;
    _codeTextFeild.delegate = self;
    
    !(iPhone4||iPhone5)?[_rechargePriceTextFeild becomeFirstResponder]:0;
    
    _timeout = 60;
    self.codeView.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.codeTextFeild) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    // showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    //showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        //showMsg(@"最多两位小数");
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //showMsg(@"数据格式有误");
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"] && ![string isEqualToString:@"."]) {
        return NO;
    }else if (string.length < 1 && [string isEqual:@"."]){
        
        return NO;
    }else if ([string isEqual:@".."]){
        return NO;
    }

    return YES;
}

#pragma mark - 屏幕上弹
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    /**
     if(iPhone5) toTopHeight = -125.0f;
     else if(iPhone6) toTopHeight = -35.0f;
     else if(iPhone4) toTopHeight = -213.0f;
     */
    CGFloat toTopHeight;
    if (iPhone5) toTopHeight = -78.0f;
    //    else if(iPhone6) toTopHeight = -20.0f;
    else if(iPhone4) toTopHeight = -164.0f;
    else toTopHeight = 0.0f;
    //键盘高度216
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, toTopHeight, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}

#pragma mark -屏幕恢复
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setViewallControlStyle {
    //添加银行卡界面
    NSString *bankCardIcon = @"bankcardStyle_image.png";
    NSString *bankName = @"银行";
    NSString *bankCardNumber = @"***** **** **** ****";
    NSString *bankStyle = @"暂无";
    if ([_UserInformationDict[@"status"] integerValue] != 2) {
        bankStyle = @"储蓄卡";
        if (![_UserInformationDict[@"bank"] isKindOfClass:[NSNull class]] && ![self isBlankString:_UserInformationDict[@"bank"]]) {
            bankName = _UserInformationDict[@"bank"];
        }
        if (![_UserInformationDict[@"bankNo"] isKindOfClass:[NSNull class]] && ![self isBlankString:_UserInformationDict[@"bankNo"]]) {
            bankCardIcon = _UserInformationDict[@"bankNo"];
        }
        if (![self isBlankString:_UserInformationDict[@"accountHidden"]] && ![_UserInformationDict[@"accountHidden"] isKindOfClass:[NSNull class]]) {
            bankCardNumber = _UserInformationDict[@"accountHidden"];
        }
    }
    bankCardPublicView *bankCardView = [[bankCardPublicView alloc] initWithsetBank:bankCardIcon bankCardName:bankName bankCardNumber:bankCardNumber bankCardStyle:bankStyle];
    [self.bankCardView addSubview:bankCardView];

    if ([self isLegalObject:_UserInformationDict[@"info"]]) {
        self.bank.text = _UserInformationDict[@"info"];
    }
}

#pragma mark - payPassworldViewDelegate
- (void)sureTappend{
    [self getEncryptionString];/*移除支付视图在下级页面处理[self cancelTappend]*/
}

- (void)cancelTappend{

    [self dismissPopupController];
}

-(void)forgetPassWorldTappend{
    [self.payPWDView clearUpPassword];
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

//- (void)forgetPassWorldTappend{
//    NSDictionary *parameters = @{@"at":     getObjectFromUserDefaults(ACCESSTOKEN),
//                                 @"mobile": getObjectFromUserDefaults(MOBILE)
//                                 };
//    [self showWithDataRequestStatus:@"验证短信获取中..."];
//    WS(weakSelf);
//    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getSmsCode",GeneralWebsite] parameters:parameters success:^(id responseObject) {
//        if (![self isBlankString:responseObject[@"r"]]) {
//            if ([[responseObject objectForKey:@"r"] intValue] == 1) {
//                [self dismissWithDataRequestStatus];
//                [self dismissPopupController];
//                VerificationiPhoneCodeViewController *VerificationCode = [[VerificationiPhoneCodeViewController alloc] initWithNibName:@"VerificationiPhoneCodeViewController" bundle:nil];
//                VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
//                VerificationCode.timeout = GetCodeMaxTime;
//                VerificationCode.isFindPassworld = 2;
//                [self customPushViewController:VerificationCode customNum:0];
//            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
//                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
//                    [weakSelf forgetPassWorldTappend];
//                } withFailureBlock:^{
//                    
//                }];
//            }
//            else{
//                [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
//           
//            }
//        }
//    } fail:^{
//        [self errorPrompt:3.0 promptStr:errorPromptString];
//    }];
//
//}
/**  充值接口
 *   连连充值接口  bank/lianlianRecharge   富友充值接口  bank/BaoFuRecharge
 *   参数uid sid  name  card_no  id_no  money appType bankId  pwd  与富有参数一致
 */
#pragma mark - 充值接口
- (void)gotoPay{
    /* 富友 & 连连支付
    NSString * urlStr;
    if (self.rechargeType == FuyouPay) {
        urlStr = @"bank/fuYouRecharge";
    }else if(self.rechargeType == LianlianPay){
        urlStr = @"bank/lianlianRecharge";
    }*/
    
    NSString * sms_codeStr = [self isBlankString:self.codeTextFeild.text]?
                             @"":self.codeTextFeild.text;
    NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                 @"sid":   getObjectFromUserDefaults(SID),
                                 @"at" :   getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"name"   : _UserInformationDict[@"userName"],
                                 @"id_no"  : _UserInformationDict[@"idNumber"],
                                 @"card_no": _UserInformationDict[@"account"],
                                 @"bankId" : _UserInformationDict[@"bankId"],
                                 @"money"  : self.rechargePriceTextFeild.text,
                                 @"appType": @"101",
                                 @"pwd":  [NetManager TripleDES:self.payPWDView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 /* 宝付有验证码，接富友给删掉，需删除或传@"" 不然会蹦*/
                                 @"sms_code":  sms_codeStr };
    
    NSLog(@"parameters = %@",parameters);
    
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/lianlianRecharge",GeneralWebsite]/*[NSString stringWithFormat:@"%@%@",GeneralWebsite,![self isBlankString:_chargeUrl]?_chargeUrl:urlStr]*/ parameters:parameters success:^(id responseObject) {
        [self.payPWDView clearUpPassword];
        NSLog(@"%@",responseObject);
        WS(weakSelf);
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self cancelTappend];/*移除支付视图<-->*/
                [KVNProgress dismiss];/*隐藏提示视图<-->*/
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _rechargeInfo = [responseObject[@"item"] copy];
//                    if (self.rechargeType == FuyouPay) {
//                        [self loadFuYouPayRechargePage]; /**富友方案*/
//                    }else if (self.rechargeType == LianlianPay){
//                        [self loadLianlianPayRechargePage]; /**连连方案*/
//                    }
                    [self loadLianlianPayRechargePage];
                }
                
                //宝付 方案
//                WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
//                    WithDrawDetailsView.payMonryString = self.rechargePriceTextFeild.text;
//                    WithDrawDetailsView.titleString = @"充值";
//                    WithDrawDetailsView.pushNumber = 2;
//                    WithDrawDetailsView.userInfodict = [_UserInformationDict copy];
//                [self customPushViewController:WithDrawDetailsView customNum:0];
                
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
                [self shakeView1:self.payPWDView];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self shakeView1:self.payPWDView];
        [self errorPrompt:3.0 promptStr:errorPromptString];
        [self.payPWDView clearUpPassword];
    }];
    
    
//exception 输出
 @try{

 }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}

/*
{ data =     (
 );
 item =     {
 amt = 100;
 bankCard = 6212260200086326374;
 idNo = 410482199212253012;
 idType = 0;
 mchNtCd = 0003310F0308105;
 mchntKey = skjg0amcjyb1haq0sh0pjkr3k64hk1va;
 mchntOrdId = 022016122914084584385447419;
 murl = "https://frontend.yiqifu.com/rechargeCallback/returnByFuYou";
 name = "\U8d75\U8f89\U8f89";
 userId = 133195;
 };
 msg = "<null>";
 r = 1;
 total = 0;
 } */

#pragma mark - 以下是富友接入方案
- (void)loadFuYouPayRechargePage{
    
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"] ;
    
    NSString * myMCHNTORDERID = [NSString stringWithFormat:@"%@",self.rechargeInfo[@"mchntOrdId"]];  // 商户订单号MAX(20)
    NSString * myMCHNTCD =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"mchNtCd"]]; //商户号(15)
    NSString * myUSERID =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"userId"]];  // 用户ID MAX(20)
    
//    CGFloat myAMT_f =[self.rechargePriceTextFeild.text floatValue] * 100;
    NSString * myAMT = [NSString stringWithFormat:@"%.0f", [self.rechargeInfo[@"amt" ] floatValue]];//  订单金额 MAX(12)，单位为分
    NSString * myBANKCARD =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"bankCard"]];//银行卡号 MAX（20）0
    
    NSString * myBACKURL =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"murl"]]; //回调地址
    NSString * myNAME =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"name"]] ;   //姓名
    NSString * myIDNO =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"idNo"]];  // 身份证号
    NSString * myIDTYPE =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"idType"]];   //  证件类型，目前只支持身份证，代号（0）
    
    NSString * myTYPE = [NSString stringWithFormat:@"02"] ;
    NSString * mySIGNTP = [NSString stringWithFormat:@"MD5"] ;
    NSString * myMCHNTCDKEY =  [NSString stringWithFormat:@"%@",self.rechargeInfo[@"mchntKey"]];  // 商户秘钥
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
            WithDrawDetailsView.payMonryString = self.rechargePriceTextFeild.text;
            WithDrawDetailsView.titleString = @"充值";
            WithDrawDetailsView.pushNumber = 2;
            WithDrawDetailsView.userInfodict = [_UserInformationDict copy];
            [self customPushViewController:WithDrawDetailsView customNum:0];
        });
        
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
        _orderParamDict = @{};
        if (_rechargeInfo == nil) {
            return;
        } else if ([self isBlankString:_rechargeInfo[@"no_order"]]) {
            [self errorPrompt:3.0 promptStr:@"订单号为空"];
        } else if ([self isBlankString:_rechargeInfo[@"dt_order"]]) {
            [self errorPrompt:3.0 promptStr:@"商户订单时间为空"];
        } else if ([self isBlankString:_rechargeInfo[@"money_order"]]) {
            [self errorPrompt:3.0 promptStr:@"大侠你要充值多少钱呀"];
        } else if ([self isBlankString:_rechargeInfo[@"busi_partner"]]) {
            [self errorPrompt:3.0 promptStr:@"业务类型为空"];
        } else if ([self isBlankString:_rechargeInfo[@"sign_type"]]) {
            [self errorPrompt:3.0 promptStr:@"没有加密方式"];
        } else if ([self isBlankString:_rechargeInfo[@"sign"]]) {
            [self errorPrompt:3.0 promptStr:@"加密字符串"];
        } else if ([self isBlankString:_rechargeInfo[@"user_id"]]) {
            [self errorPrompt:3.0 promptStr:@"用户id用空"];
        } else if ([self isBlankString:_rechargeInfo[@"oid_partner"]]) {
            [self errorPrompt:3.0 promptStr:@"商户号为空"];
        } else if ([self isBlankString:_rechargeInfo[@"valid_order"]]) {
            [self errorPrompt:3.0 promptStr:@"过期时间为空"];
        } else if ([self isBlankString:_rechargeInfo[@"acct_name"]]) {
            [self errorPrompt:3.0 promptStr:@"姓名为空"];
        } else if ([self isBlankString:_rechargeInfo[@"id_no"]]) {
            [self errorPrompt:3.0 promptStr:@"身份证号码为空"];
        } else if ([self isBlankString:_rechargeInfo[@"card_no"]]) {
            [self errorPrompt:3.0 promptStr:@"银行卡号为空"];
        } else {
            _orderParamDict = @{ @"acct_name"   : _rechargeInfo[@"acct_name"], //self.nameField.text
                                 @"busi_partner": _rechargeInfo[@"busi_partner"],
                                 @"card_no"     : _rechargeInfo[@"card_no"], //self.BankCardField.text
                                 @"dt_order"    : _rechargeInfo[@"dt_order"],
                                 @"id_no"       : _rechargeInfo[@"id_no"], //self.CardidField.text
                                 @"money_order" : _rechargeInfo[@"money_order"],
                                 @"no_order"    : _rechargeInfo[@"no_order"],
                                 @"notify_url"  : _rechargeInfo[@"notify_url"],
                                 @"oid_partner" : _rechargeInfo[@"oid_partner"],
                                 @"risk_item"   : _rechargeInfo[@"risk_item"],
                                 @"sign_type"   : _rechargeInfo[@"sign_type"],
                                 @"sign"        : _rechargeInfo[@"sign"],
                                 @"user_id"     : _rechargeInfo[@"user_id"],
                                 @"valid_order" : _rechargeInfo[@"valid_order"],
                                 @"info_order"  : _rechargeInfo[@"info_order"],
                                 @"name_goods"  : _rechargeInfo[@"name_goods"]};
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
            WithDrawDetailsView.payMonryString = self.rechargePriceTextFeild.text;
            WithDrawDetailsView.titleString = @"充值";
            WithDrawDetailsView.pushNumber = 2;
            WithDrawDetailsView.userInfodict = [_UserInformationDict copy];
            [self customPushViewController:WithDrawDetailsView customNum:0];
        });
        
        
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
                                 @"orderid": _rechargeInfo[@"no_order"],
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
    }fail:^{
                                  
    }];
}






//获取交易密码加密字  秘钥
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
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
                    [weakSelf getEncryptionString];
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                /*添加提示信息<-->在gotoPlay页面隐藏*/
                [KVNProgress showWithStatus:@"充值中..."];
                [weakSelf gotoPay];
            } else {
                [self dismissWithDataRequestStatus];
                [self shakeView1:self.payPWDView];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self shakeView1:_payPWDView];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}




-(void)shakeView1:(UIView*)viewToShake
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


#pragma mark---- 点击屏幕空白区域收起键盘  ----
- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 返回代理的实现
- (void)goBack {
    [self customPopViewController:0];
}

#pragma mark - 充值的确认按钮点击事件
- (IBAction)ConfirmButtonAction:(id)sender {
    //去充值
    [self goRechargeMyassets];
}

#pragma mark - 去充值
- (void)goRechargeMyassets {
    if ([self.rechargePriceTextFeild.text doubleValue] < 0.01) {
        [self errorPrompt:3.0 promptStr:@"请输入金额"];
        return;
    }

//    if ([self.rechargePriceTextFeild.text doubleValue] < 2) {
//        [self errorPrompt:3.0 promptStr:@"充值金额必须大于2元"];
//        return;
//    }
    
    // 宝付 后台验证码
//    if (self.codeView.hidden == NO) {
//        if ([self.codeButton.titleLabel.text isEqualToString:@"点击发送验证码"]) {
//            [self errorPrompt:3.0 promptStr:@"请先点击发送验证码"];
//            return;
//        }
//        if (self.codeTextFeild.text.length != 6) {
//            [self errorPrompt:3.0 promptStr:@"请输入6位数的验证码"];
//            return;
//        }
//    }
    
    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPWDView];
}


//- (IBAction)sendCodeButtonAction:(id)sender {
//    if ([self isBlankString:self.rechargePriceTextFeild.text] || [self.rechargePriceTextFeild.text doubleValue] == 0) {
//        [self errorPrompt:3.0 promptStr:@"请输入充值金额"];
//        return;
//    }
//    [self sendCode];
//}

//  获取验证码
//- (void)sendCode{
//    NSDictionary *parameters = @{@"uid":    getObjectFromUserDefaults(UID),
//                                 @"sid":    getObjectFromUserDefaults(SID),
//                                 @"at" :    getObjectFromUserDefaults(ACCESSTOKEN),
//                                 @"mobile": getObjectFromUserDefaults(MOBILE),
//                                 @"acc_no": _UserInformationDict[@"account"],
//                                 @"money" : self.rechargePriceTextFeild.text,};
//    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@getRbPaySms",GeneralWebsite] parameters:parameters success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//        WS(weakSelf);
//        if (responseObject[@"r"]) {
//            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                [weakSelf setSendButton];
//            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
//                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
//                    [weakSelf sendCode];
//                } withFailureBlock:^{
//                    
//                }];
//            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
//                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
//                    [weakSelf sendCode];
//                } withFailureBlock:^{
//                    
//                }];
//            }else{
//                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
//            }
//        }
//    } fail:^{
//        
//    }];
//}

- (void)setSendButton
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //结束后重新复制
                _timeout = GetCodeMaxTime;
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:@"点击发送验证码" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
                self.rechargePriceTextFeild.userInteractionEnabled = YES;
                [self.codeButton setBackgroundColor:AppBtnColor];
            });
        }else{
            int seconds = _timeout % 600;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:[NSString stringWithFormat:@"(%@s)重新获取",strTime] forState:UIControlStateNormal];
                self.codeButton.titleLabel.font=[UIFont systemFontOfSize:13];
                self.codeButton.userInteractionEnabled = NO;
                self.rechargePriceTextFeild.userInteractionEnabled = NO;
                [self.codeButton setBackgroundColor:LineBackGroundColor];
            });
            _timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - setters && getters
- (XRPayPassWorldView *)payPWDView{
    if (!_payPWDView) {
        _payPWDView = [[XRPayPassWorldView alloc] init];
        _payPWDView.delegate = self;
    }
    [_payPWDView.textField becomeFirstResponder];
    return _payPWDView;
}

@end
