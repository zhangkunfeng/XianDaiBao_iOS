//
//  RollInViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/1/16.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "RollInViewController.h"
#import "XRPayPassWorldView.h"
#import "VerificationiPhoneCodeViewController.h"
#import "ForgetPassWdViewController.h"

#define RollInTitle @"充值"

@interface RollInViewController ()<XRPayPassWorldViewDelegate>

@property (strong, nonatomic)XRPayPassWorldView *payPWDView;
@property (nonatomic, strong)NSDictionary *rollInInfo;//后台充值数据
@property (weak, nonatomic) IBOutlet UILabel *assetsBlancesLab;
@property (weak, nonatomic) IBOutlet UITextField *rollInMoneyTF;
- (IBAction)confirmRollInBtnAction:(id)sender;

@end

@implementation RollInViewController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:RollInTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:RollInTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    CustomMadeNavigationControllerView *RollInView = [[CustomMadeNavigationControllerView alloc] initWithTitle:RollInTitle showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:RollInView];
    
    [self.rollInMoneyTF becomeFirstResponder];
    
    [self loadUserAvailableBalance];
}

- (void)goBack
{
    [self customPopViewController:0];
}

/**
 *  用户当前余额接口user/getUserCurrentBalance
 */
- (void)loadUserAvailableBalance
{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getUserCurrentBalance", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"获取用户可用余额接口 = %@",responseObject);
                if ([self isLegalObject:responseObject[@"item"]]) {
                    self.assetsBlancesLab.text = [NSString stringWithFormat:@"%@元", [Number3for1 formatAmount: responseObject[@"item"]]];
                }

            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmRollInBtnAction:(id)sender {
    [self goRollInMyChangeMoney];
}

- (void)goRollInMyChangeMoney {
    
    if (!self.rollInMoneyTF.text.length) {
        [self errorPrompt:3.0 promptStr:@"请输入金额"];
        return;
    }
    
    if ([self.rollInMoneyTF.text doubleValue] < 1) {
        [self errorPrompt:3.0 promptStr:@"转入金额不能小于1元钱"];
        return;
    }
    
//    NSString * blanceMoneyStr = [Number3for1 forDelegateChar:[self.assetsBlancesLab.text substringToIndex:self.assetsBlancesLab.text.length-1]];
//    NSString * deleStr = [self.assetsBlancesLab.text substringToIndex:self.assetsBlancesLab.text.length-1];
    
    float blanceMoney = [[Number3for1 forDelegateChar:[self.assetsBlancesLab.text substringToIndex:self.assetsBlancesLab.text.length-1]] floatValue];
    if ([self.rollInMoneyTF.text floatValue] > blanceMoney) {
        [self errorPrompt:3.0 promptStr:@"转入金额不能大于账户余额"];
        return;
    }
    
    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPWDView];
}




#pragma mark - payPassworldViewDelegate
- (void)sureTappend{
    [self getEncryptionString];
}
- (void)cancelTappend{
    [self dismissPopupController];
}

- (void)forgetPassWorldTappend{
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);

    [self customPushViewController:VerificationCode customNum:0];
    
}
//获取交易密码加密字  秘钥
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
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
                    [weakSelf getEncryptionString];
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self showWithDataRequestStatus:@"处理中..."];
                [weakSelf gotoRollInOperationPay];
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

/**
 *  零钱包转入接口 bank/tenderCoin
 */
#pragma mark - 转入接口
- (void)gotoRollInOperationPay{
        
        NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                     @"sid":   getObjectFromUserDefaults(SID),
                                     @"at" :   getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"bid":   _bid?_bid:@"7",
                                     @"source"      : @"101",
                                     @"tenderAmount": self.rollInMoneyTF.text,
                                     @"payPassword" : [NetManager TripleDES:self.payPWDView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]};
        
        NSLog(@"零钱包转入传入参数：\n parameters = %@",parameters);
        
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/tenderCoin",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            WS(weakSelf);
            if (responseObject[@"r"]) {
                if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    NSLog(@"零钱包转入接口后台返回数据 = %@",responseObject);
                    [self cancelTappend];/*移除支付视图<-->*/
                    [self showWithSuccessWithStatus:@"转入成功"];
//                    if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
//                        _rollInInfo = [responseObject[@"item"] copy];
//                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.rollInRefresh(YES);
                        [self customPopViewController:0];
                    });
                    
                }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf gotoRollInOperationPay];
                    } withFailureBlock:^{
                        
                    }];
                }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf gotoRollInOperationPay];
                    } withFailureBlock:^{
                        
                    }];
                }else{
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        } fail:^{
            [self errorPrompt:3.0 promptStr:errorPromptString];
        }];

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
