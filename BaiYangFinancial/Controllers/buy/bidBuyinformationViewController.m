//
//  bidBuyinformationViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/11.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "MDbuyConfirmViewController.h"
#import "bidBuyinformationViewController.h"
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"
#import "myRedenvelopeModel.h"
#import "myRedenvelopeListViewController.h"
#import "PayPassViewController.h"
#import "bankCardPublicView.h"
#import "XRPayPassWorldView.h"
#import "WithDrawDetailsViewController.h"
#import "ForgetPassWdViewController.h"
#import "PayYesViewController.h"
#import "Masonry.h"
#import "setPaymentPassWorldViewController.h"
@interface bidBuyinformationViewController ()<UITextFieldDelegate,XRPayPassWorldViewDelegate>{
    NSMutableArray *dataArray;
    NSString * redpackSource;
}
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *redLab;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UILabel *bankXianLab;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *redEnveloperCountLab;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSDictionary *infoDict;            //存入信息的字典
@property (nonatomic, assign) BOOL isHavePayPassworld;         //是否有交易密码
@property (nonatomic, copy) NSDictionary *userInformationDict; //用户的银行卡和身份认证状态
@property (nonatomic, copy) NSDictionary *userInforBankDict;
@property (nonatomic, strong) UIAlertView * bidBuyAlert;

@property (weak, nonatomic) IBOutlet UIButton *quantouBtn;/*设置边框颜色*/
//起投金额
@property (weak, nonatomic) IBOutlet UILabel *qitouLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidTittleNameLabel;
@property (assign, nonatomic) float DeductionMoney;

@property (nonatomic, strong) MDbuyConfirmViewController *buyConfirmView;
@property (nonatomic, strong) PayPassViewController *payView;

@property (assign, nonatomic) BOOL isRequest;
@property (copy, nonatomic) NSString *recordId; //红包id
@property (strong, nonatomic) UITextField *buyConfirmTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bankImg;
@property (nonatomic, strong)NSString *moenyStr;
@property (strong, nonatomic)XRPayPassWorldView *payPassWorldView;
@end

@implementation bidBuyinformationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"投标购买"];
    self.InvestmentAmountTF.text = _tfText;
//    [self loadJudgeTradingPasswordAndCardData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.InvestmentAmountTF resignFirstResponder];
    [self talkingDatatrackPageEnd:@"投标购买"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.payPassWorldView.textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.InvestmentAmountTF.text = _tfText;

   // [self setViewallControlStyle];
    [self resetSideBack];
    [self setBank];
     self.recordId = @"";
    redpackSource = @"";
//    _userMoenyLab.text = @"";
//    _setMoenyLasb.text = @"";
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.activityIndicatorView startAnimating];
    
    //增加导航栏
    CustomMadeNavigationControllerView *bidBuyinformationView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"购买" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:bidBuyinformationView];

    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    [bidBuyinformationView addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 50));
        make.right.mas_offset(-15);
        make.centerY.equalTo(bidBuyinformationView).offset(10);
    }];
    [message addTarget:self action:@selector(message) forControlEvents:(UIControlEventTouchUpInside)];
    [message setTitle:@"限额说明"forState:UIControlStateNormal];
    message.font = [UIFont systemFontOfSize:14];
    
    //[self.InvestmentAmountTF becomeFirstResponder];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.InvestmentAmountTF];

    //获取用户信息
    [self getUserinformation];
    
    
    [self getmyRedenvelopeList];
    [self showWeidaiLoadAnimationView:self];
}

-(void)message{

[self jumpToWebview:[NSString stringWithFormat:@"%@sys/quotaExplainPage?at=%@", GeneralWebsite, getObjectFromUserDefaults(ACCESSTOKEN)] webViewTitle:@"限额说明"];
}




#pragma mark - 获取用户信息
- (void)getUserinformation {
    NSString *bidStyle = @"";
    NSString *bidVaule = @"";
    if (self.bidType == OptimizationBid) {
        bidStyle = @"apId";
        bidVaule = _AssetsproductBID;
    } else {
        bidStyle = @"bid";
        bidVaule = _productBID;
    }
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
                                  bidStyle: bidVaule
    };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getUserBalance", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getUserinformation];
        } withFailureBlock:^{
            
        }];

            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getUserinformation];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                //隐藏袋鼠
                [self dismissWeidaiLoadAnimationView:self];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]] && ![responseObject[@"item"] isEqual:[NSNull null]]) {
                    _infoDict = [responseObject[@"item"] copy];
                    //初始化所有的控件
                    [self initWithAllController];
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                //隐藏袋鼠
                [self dismissWeidaiLoadAnimationView:self];
            }
        }
    }
        fail:^{
            //隐藏袋鼠
            [self dismissWeidaiLoadAnimationView:self];
        }];
}

#pragma mark - Action
- (IBAction)userButtonAction:(id)sender {
    
//    PayPassViewController *payVC = [[PayPassViewController alloc]init];
//    payVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    payVC.providesPresentationContextTransitionStyle = YES;
//    payVC.definesPresentationContext = YES;
//    payVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    
//    
//   [self presentViewController:payVC animated:NO completion:^{
//       
//   }];
    
    
    if (self.bidType == GreenhandBid) { //可省略  前面已判断过
        if ([self isLegalObject:_infoDict[@"isIntegral"]]) {
            if ([_infoDict[@"isIntegral"] integerValue] == 1) {
                [self nextstepAction];
            } else {
                [self errorPrompt:3.0 promptStr:@"您已经不是新手了，把机会让给新人吧！"];
            }
        }
    } else if (self.bidType == DirectionalBid) {
        if ([self.DirectionalMoneyString doubleValue] > [_infoDict[@"accAmount"] doubleValue]) {
            [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"定向标，只有资产到达%.0f万的用户才能投资", [self.DirectionalMoneyString doubleValue] / 10000]];
        } else {
            [self nextstepAction];
        }
    } else {
        [self nextstepAction];
    }
}

//下一步的执行方法
- (void)nextstepAction {
//    [self.InvestmentAmountTF resignFirstResponder];
    [self loadJudgeTradingPasswordAndCardData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.bidType == GreenhandBid) { //可省略  前面已判断过
        if ([self isLegalObject:_infoDict[@"isIntegral"]]) {
            if ([_infoDict[@"isIntegral"] integerValue] == 1) {
                [self nextstepAction];
            } else {
                [self errorPrompt:3.0 promptStr:@"您已经不是新手了，把机会让给新人吧！"];
            }
        }
    } else if (self.bidType == DirectionalBid) {
        if ([self.DirectionalMoneyString doubleValue] > [_infoDict[@"accAmount"] doubleValue]) {
            [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"定向标，只有资产到达%.0f万的用户才能投资", [self.DirectionalMoneyString doubleValue] / 10000]];
        } else {
            [self nextstepAction];
        }
    } else {
        [self nextstepAction];
    }
    return YES;
}

-(void)setBank{
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
                [weakSelf setBank];
            } withFailureBlock:^{
                
                
                
            }];
        }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
            [weakSelf setBank];
        } withFailureBlock:^{
            
            
            
        }];
        
        
        }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
        
        [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _userInforBankDict = [responseObject[@"item"] copy];
                NSString *str = _userInforBankDict[@"account"];
                str = [str substringFromIndex:15];
                
                _bankName.text = [NSString stringWithFormat:@"%@(尾号%@)",_userInforBankDict[@"bankNo"],str];
                
                _bankImg.image = [UIImage imageNamed:@"bankcardStyle_image.png"];
                _bankXianLab.text = _userInforBankDict[@"info"];
                
                NSString *bankCardIcon  = _userInforBankDict[@"bankNo"];
                if (self) {
                    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankListPlist" ofType:@"plist"];
                    NSDictionary *bankListDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                    if ([[bankListDict allKeys] containsObject:bankCardIcon]) {
                        //self.bankGroundView.hidden = NO;
                        [self.bankImg setImage:[UIImage imageNamed:bankCardIcon]];
                    }else{
                        [self.bankImg setImage:[UIImage imageNamed:@"bankcardStyle_image.png"]];
                    }
                    //                    self.bankCardName.text = bankCardNameStr;
                    //                    self.bankCardNumber.text = bankCardNumberStr;
                    //                    self.bankCardStyle.text = bankCardStyleStr;
                    
                }
                
            }
            
        }else{
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
        
        
    } fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];

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
                _userInformationDict = [responseObject[@"item"] copy];
                //是否设置交易密码
                if (![_userInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_userInformationDict[@"pay"] integerValue] == 1) {
                    
                    //是否绑卡
                    if ([_userInformationDict[@"status"] integerValue] == 2) {
                        _bidBuyAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"银行卡支付需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_bidBuyAlert show];
                        
                    } else {
                        
                        if ([_infoDict[@"tenderAmount"] doubleValue] >= [_TenderMinAmountString doubleValue]) {
                            if ([self.InvestmentAmountTF.text doubleValue] < [_TenderMinAmountString doubleValue]) {
                                [self errorPrompt:3.0 promptStr:[NSString stringWithFormat: @"%@元起投",_TenderMinAmountString]];
                            } else {
                                [self pushSureView];
                            }
                        } else {
                            [self pushSureView];
                        }
                        
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
    [self.InvestmentAmountTF resignFirstResponder];
    if (alertView == _bidBuyAlert && buttonIndex != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
            BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
            BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
                
            };
            BindingBankCardView.UserInformationDict = [_userInformationDict copy];
            [self customPushViewController:BindingBankCardView customNum:0];
        });
    }
}
- (void)pushSureView {
    if (![self isPureFloat:self.InvestmentAmountTF.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入数字"];
        return;
    }
    if ([self.InvestmentAmountTF.text doubleValue] == 0) {
        [self errorPrompt:3.0 promptStr:@"请输入购买金额"];
        return;
    }
    if ([self.InvestmentAmountTF.text doubleValue] > [_infoDict[@"tenderAmount"] doubleValue]) {
        [self errorPrompt:3.0 promptStr:@"可投金额不足"];
        return;
    }
    if ([_QuotaMoneyString doubleValue] > 0 && [self.InvestmentAmountTF.text doubleValue] > [_QuotaMoneyString doubleValue]) {
        [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"每位用户限投%.0f元", [_QuotaMoneyString doubleValue]]];
        return;
    }
    [self gotoPayButtonAction];
    
}
#pragma mark - remainingBalancePayViewDelegate
- (void)gotoPayButtonAction {
    if (!_isHavePayPassworld) {
        [self cancelButtonAction];
        setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
        setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
            if (ishavePW) {
                _isHavePayPassworld = YES;
            }
        };
        [self customPushViewController:setPaymentPassWorldView customNum:1];
    } else {
        [self cancelButtonAction];
        if ([self isLegalObject:_userInformationDict]) {
            [self okThisOrderPayway];
        } else {
            [self getUserInformation];
        }
    }
}
- (void)forgetPassWorldTappend{
    [self dismissPopupController];
    [self.payPassWorldView clearUpPassword];
    [self dismissWithDataRequestStatus];
    
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);
    [self customPushViewController:VerificationCode customNum:0];
    
}
- (void)cancelButtonAction {
    [self dismissPopupController];
}

- (void)okThisOrderPayway {
    
    if ([_userInformationDict[@"status"] integerValue] != 1) {
        BindingBankCardViewController *bindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        bindingBankCardView.UserInformationDict = [_userInformationDict copy];
        bindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        bindingBankCardView.isRefresh = ^(BOOL isRefresh){
            
        };
        [self customPushViewController:bindingBankCardView customNum:0];
    }else{
        //替换下,
        NSString * userSurplusMoney = [self.userSurplusMoneyLable.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([userSurplusMoney doubleValue] >= [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [_redBsetLab.text doubleValue]] doubleValue]) {//账户余额直接支付
            self.payPassWorldView.textField.text = @"";
            [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPassWorldView];
        } else { //投标充值
            BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
            BindingBankCardView.payAounmtMoneyString = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]]];
            BindingBankCardView.userMoney = userSurplusMoney;
            BindingBankCardView.bankPaymoney = [NSString stringWithFormat:@"%.2f", [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]] doubleValue] - [userSurplusMoney doubleValue] - [_redBsetLab.text doubleValue]];
            BindingBankCardView.productBID = self.productBID;
            BindingBankCardView.bidNameString = [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]];
            BindingBankCardView.bidPasswordString = self.bidPasswordString;
            BindingBankCardView.UserInformationDict = [_userInformationDict copy];
            BindingBankCardView.bankPayChannel = BankPayFromTender;
            BindingBankCardView.recordMoneyString = [NSString stringWithFormat:@"%.2f", self.DeductionMoney];
            NSString *bidType = @"";
            if (self.bidType == OptimizationBid) {
                bidType = @"优选计划";
            }
            if ([bidType isEqualToString:@"优选计划"]) {
                BindingBankCardView.isOptimizationBid = YES;
            }
            BindingBankCardView.recordId = self.recordId;
            BindingBankCardView.redpackSource = redpackSource;
            
            [self customPushViewController:BindingBankCardView customNum:0];
        }
    }
}
//获取用户信息（支付定单的时候需要）
- (void)getUserInformation {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    [self showWithDataRequestStatus:@"安全验证中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf getUserInformation];
            }
                                                                 withFailureBlock:^{
                                                                     
                                                                 }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf getUserInformation];
            }
                                                             withFailureBlock:^{
                                                                 
                                                             }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _userInformationDict = [responseObject[@"item"] copy];
                [self okThisOrderPayway];
            }
        } else {
            [self dismissWithDataRequestStatus];
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                              }];
}


- (void)sureTappend{//账户余额够输入支付密码代理
    [self.payPassWorldView.textField resignFirstResponder];
    if ([self isBlankString:self.payPassWorldView.textField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入支付密码"];
    } else {
        //[self dismissPopupController];
        [self payOrder];
    }
}
//支付定单  (此处是 账户余额够的情况下支付，所以不是要调用充值，故展示投标成功页面）
- (void)payOrder {
    if ([self isBlankString:getObjectFromUserDefaults(ACCESSTOKEN)] || [self isBlankString:getObjectFromUserDefaults(UID)]) {
        return;
    }
    NSString *bankId = @"";
    if (![_userInformationDict[@"bankId"] isEqual:[NSNull null]]) {
        bankId = [NSString stringWithFormat:@"%zd", [_userInformationDict[@"bankId"] integerValue]];
    }
    NSString *bidType = @"";
    if (self.bidType == OptimizationBid) {
        bidType = @"优选计划";
    }

    NSString *urlString = @"";
    if ([bidType isEqualToString:@"优选计划"]) {
        urlString = @"bank/sdInvestBid";
    } else {
        urlString = @"bank/sdBid";//
    }
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"bid": self.productBID,
                                  @"payPassword":[NetManager TripleDES:self.payPassWorldView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"tenderAmount": [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]],
                                  @"source": @"101",
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"bidPassword": [NetManager TripleDES:self.bidPasswordString encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"name": [self isBlankString:_userInformationDict[@"userName"]] ? @"" : _userInformationDict[@"userName"],
                                  @"id_no": [self isBlankString:_userInformationDict[@"idNumber"]] ? @"" : _userInformationDict[@"idNumber"],
                                  @"card_no": [self isBlankString:_userInformationDict[@"account"]] ? @"" : _userInformationDict[@"account"],
                                  @"bankId": bankId,
                                  @"rechargeAmount": @"0",
                                  @"recordId": self.recordId,
                                  @"redpackSource":redpackSource
                                  };
    //     [self showInpayingLoadingView:self];  支付动画   暂不启用
    [self showWithDataRequestStatus:@"安全支付中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, urlString] parameters:parameters success:^(id responseObject) {
        [self.payPassWorldView clearUpPassword];
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf payOrder];
                }
                                                                     withFailureBlock:^{
                                                                         
                                                                     }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf payOrder];
                }
                                                                 withFailureBlock:^{
                                                                     
                                                                 }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                //                 [self hideInpayingLoadingView];支付动画   暂不启用
                [self dismissWithDataRequestStatus];

                [self dismissPopupController];
                
                [self performSelector:@selector(pushPayYesViewController) withObject:nil afterDelay:0.25];
              
            } else {
                [self dismissWithDataRequestStatus];

                [self shakeView:_payPassWorldView];
                //[self hideInpayingLoadingView];支付动画   暂不启用
//                [self.payPassWorldView clearUpPassword];
//                [self dismissWithDataRequestStatus];
                //[self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self shakeView:_payPassWorldView];
                                  [self.payPassWorldView clearUpPassword];
                                  //            [self hideInpayingLoadingView];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (void)pushPayYesViewController{
    PayYesViewController *WithDrawDetailsView = [[PayYesViewController alloc] initWithNibName:@"PayYesViewController" bundle:nil];
    WithDrawDetailsView.moen = [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]];
    [self customPushViewController:WithDrawDetailsView customNum:0];
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
#pragma mark - 初始化所有的控件
- (void)initWithAllController {
    
    self.bidTittleNameLabel.text = _bidNameString;
    if ([_infoDict[@"pay"] intValue] == 1) {
        _isHavePayPassworld = YES;
    }
    //设置全投button的样式
    self.allSendButton.layer.borderWidth = .5;
    self.allSendButton.layer.borderColor = [self colorFromHexRGB:@""].CGColor;
    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];

    if ([self isLegalObject:_infoDict[@"tenderAmount"]]) {
    self.SurplusMoneyLable.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%@", _infoDict[@"tenderAmount"]]];
    } else {
        self.SurplusMoneyLable.text = @"0.00";
    }
    self.userSurplusMoneyLable.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%@", _infoDict[@"balance"]]];

    if ([self.QuotaMoneyString doubleValue] > 0) {
        self.QuotaMoneyLable.hidden = NO;
        self.limitsinvestMoneyLeftstring.hidden = NO;
//        self.QuotaMoneyLable.text = [NSString stringWithFormat:@"%@元", self.QuotaMoneyString];
        self.QuotaMoneyLable.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:self.QuotaMoneyString]];
    }

    if ([_infoDict[@"tenderAmount"] doubleValue] < 100) {
        self.InvestmentAmountTF.text = [NSString stringWithFormat:@"%.2f", [_infoDict[@"tenderAmount"] doubleValue]];
        self.InvestmentAmountTF.userInteractionEnabled = NO;
    }
    
    //最小可投
    if (_TenderMinAmountString) {
        self.qitouLabel.text = [NSString stringWithFormat:@"%@元", _TenderMinAmountString];
        self.InvestmentAmountTF.placeholder = [NSString stringWithFormat:@"%@元起投", _TenderMinAmountString];
        
    }
}

#pragma mark---- 点击屏幕空白区域收起键盘  ----
- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
}


-(void)textFieldDidChange:(NSNotification *)obj{
    NSString *toBeString = self.InvestmentAmountTF.text;
    if ([self.InvestmentAmountTF.text floatValue] > [_infoDict[@"tenderAmount"] floatValue]) {
        self.InvestmentAmountTF.text = [NSString stringWithFormat:@"%.2f", [_infoDict[@"tenderAmount"] floatValue]];
        return;
    }
    
    int length = 0;
    if ([toBeString rangeOfString:@"."].location != NSNotFound) {
        length = (int)[toBeString rangeOfString:@"."].location + 3;
        NSLog(@"%d", length);
    }
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.InvestmentAmountTF markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.InvestmentAmountTF positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (length != 0 && toBeString.length > length) {
                self.InvestmentAmountTF.text = [toBeString substringToIndex:length];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (length != 0 && toBeString.length > length) {
            
            self.InvestmentAmountTF.text = [toBeString substringToIndex:length];
            
            
        }
    }
}

#pragma mark - UITextFieldDeledage
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.bidType == OptimizationBid) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   

    [self setRed];
    [self getmyRedenvelopeList];

}


#pragma mark - 返回代理方法的实现
- (void)goBack {
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 全投按钮事件
//- (IBAction)allinvestButtonAction:(id)sender {
//    if ([_infoDict[@"tenderAmount"] doubleValue] < 100) {
//        self.InvestmentAmountTF.text = [NSString stringWithFormat:@"%.2f", [_infoDict[@"tenderAmount"] doubleValue]];
//        return;
//    } else if ([_infoDict[@"balance"] doubleValue] == 0) {
//        self.InvestmentAmountTF.text = [NSString stringWithFormat:@"%.2f", [_infoDict[@"tenderAmount"] doubleValue]];
//    } else if ([_infoDict[@"balance"] doubleValue] < [_infoDict[@"tenderAmount"] doubleValue]) {
//        if (self.bidType == OptimizationBid) {
//            self.InvestmentAmountTF.text = [NSString stringWithFormat:@"%zd", [_infoDict[@"balance"] integerValue]];
//        } else {
//            self.InvestmentAmountTF.text = _infoDict[@"balance"];
//        }
//    } else {
//        self.InvestmentAmountTF.text = _infoDict[@"tenderAmount"];
//    }
//}

#pragma mark - HTTP
- (void)getmyRedenvelopeList {
        NSString *bid = @"";
    if (self.bidType) {
        bid = @"apId";
    } else {
        bid = @"bid";
    }
    
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  bid: self.productBID,
                                  @"tenderAmount": [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]] };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/bidRedList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            NSArray *array = responseObject[@"data"];
            if ([dataArray count] > 0) {
                [dataArray removeAllObjects];
//                [self.tableView reloadData];
                [self setRed];

            }

            if ([array count] > 0) {
                for (int i = 0; i < [array count]; i++) {
                    myRedenvelopeModel *model = [[myRedenvelopeModel alloc] initWithmyRedenvelopeModel:[array objectAtIndex:i]];
                    [dataArray addObject:model];
                }
                [dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    myRedenvelopeModel *model1 = obj1;
                    myRedenvelopeModel *model2 = obj2;
                    int a = [model1.RedenvelopeMoney intValue];
                    int b = [model2.RedenvelopeMoney intValue];
                    return a>b?NSOrderedAscending:NSOrderedDescending;
                }];
                //默认取第一个值
                redpackSource = [NSString stringWithFormat:@"%@",array[0][@"redpackSource"]];
            }
            self.isRequest = YES;
//            [self.tableView reloadData];
            [self setRed];
            
        }
    }
                              fail:^{
                                  
                              }];
}

-(void)setRed{
    if (self.isRequest) {
        //[self.getmyRedenvelopeLable removeFromSuperview];
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
        if ([dataArray count] == 0) {
            _redLab.text = @"无可用红包";
            _redLab.textColor = [UIColor lightGrayColor];
//            _redBsetLab.hidden = YES;//抵扣hideen
            //            _realDiKouLabel.hidden  = YES;
            //            self.tableView.userInteractionEnabled = YES;
            _redBsetLab.text = @"0元";
            
            
            NSString * userSurplusMoney = [self.userSurplusMoneyLable.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            _investmentLab.text = self.InvestmentAmountTF.text;
            if ([userSurplusMoney doubleValue] >= [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [self.redBsetLab.text doubleValue]] doubleValue]){
                _investmentLab.text = _InvestmentAmountTF.text;
                _userMoenyLab.text = [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [self.redBsetLab.text doubleValue]];
                _setMoenyLasb.text = @"0.00";
                
            }else{
                _investmentLab.text = _InvestmentAmountTF.text;
                _userMoenyLab.text = userSurplusMoney;
                _setMoenyLasb.text = [NSString stringWithFormat:@"%.2f", [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]- [userSurplusMoney doubleValue] - [self.redBsetLab.text doubleValue]] doubleValue] ];
            }

        } else {
            myRedenvelopeModel *model = [dataArray objectAtIndex:0];
            if ([[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]] doubleValue] * model.RedenvelopeMaxRatio / 100 < [model.RedenvelopeMoney floatValue]) {
                self.DeductionMoney = [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]] doubleValue] * model.RedenvelopeMaxRatio / 100;
            } else {
                self.DeductionMoney = [model.RedenvelopeMoney floatValue];
            }
            self.recordId = model.RedenvelopeID;
            _redEnveloperCountLab.hidden = NO;
            _redEnveloperCountLab.text = [NSString stringWithFormat:@"%ld张可用",(unsigned long)[dataArray count]];
            [_redLab setTextColor:[self colorFromHexRGB:/*@"FA6522"*/@"3A3A3A"]];
            [_redLab setText:[NSString stringWithFormat:@"%@元红包", model.RedenvelopeMoney]];
            _redBsetLab.text  = [NSString stringWithFormat:@"%@元", model.RedenvelopeMoney];
            NSString * userSurplusMoney = [self.userSurplusMoneyLable.text stringByReplacingOccurrencesOfString:@"," withString:@""];
           
            _investmentLab.text = self.InvestmentAmountTF.text;
            if ([userSurplusMoney doubleValue] >= [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [self.redBsetLab.text doubleValue]] doubleValue]){
                _investmentLab.text = _InvestmentAmountTF.text;
                _userMoenyLab.text = [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [self.redBsetLab.text doubleValue]];
                _setMoenyLasb.text = @"0.00";
                
            }else{
                _investmentLab.text = _InvestmentAmountTF.text;
                _userMoenyLab.text = userSurplusMoney;
                _setMoenyLasb.text = [NSString stringWithFormat:@"%.2f", [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]- [userSurplusMoney doubleValue] - [self.redBsetLab.text doubleValue]] doubleValue] ];
            }
            
            _redBsetLab.hidden = NO;//抵扣
        }

    }
}

- (XRPayPassWorldView *)payPassWorldView{
    if (!_payPassWorldView) {
        _payPassWorldView = [[XRPayPassWorldView alloc] init];
        _payPassWorldView.delegate = self;
    }
    [_payPassWorldView.textField becomeFirstResponder];
    
    return _payPassWorldView;
}

- (void)cancelTappend{
    [self dismissPopupController];
}
- (IBAction)redTap:(UITapGestureRecognizer *)sender {
    myRedenvelopeListViewController *myRedenvelopeListView = [[myRedenvelopeListViewController alloc] init];
    myRedenvelopeListView.dataArray = [dataArray copy];
    myRedenvelopeListView.block_RedenvelopeList = ^(NSDictionary *dict) {
        if ([self isLegalObject:dict]) {
            self.recordId = dict[@"RedenvelopeID"];
            [_redLab setText:[NSString stringWithFormat:@"%@元红包", dict[@"RedenvelopeMoney"]]];
            /*新增*/
            _redBsetLab.text = [NSString stringWithFormat:@"%@元", dict[@"RedenvelopeMoney"]];
            
            if ([[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]] doubleValue] * [dict[@"RedenvelopeMaxRatio"] floatValue] / 100 < [dict[@"RedenvelopeMoney"] floatValue]) {
                self.DeductionMoney = [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]] doubleValue] * [dict[@"RedenvelopeMaxRatio"] doubleValue] / 100;
            } else {
                self.DeductionMoney = [dict[@"RedenvelopeMoney"] floatValue];
            }
            // [self.DisplayLable setText:[NSString stringWithFormat:@"%.2f", self.DeductionMoney]];
            //传过来redpackSource值
            redpackSource = [NSString stringWithFormat:@"%@",dict[@"redpackSource"]];
        } else {
            self.recordId = @"";
            [_redLab setText:@"不使用红包"];
            /*新增*/
            _redBsetLab.text = @"0元";
            //[self.DisplayLable setText:@"0.00"];
            self.DeductionMoney = 0.00;
        }
        NSString * userSurplusMoney = [self.userSurplusMoneyLable.text stringByReplacingOccurrencesOfString:@"," withString:@""];

        if ([userSurplusMoney doubleValue] >= [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [self.redBsetLab.text doubleValue]] doubleValue]){
            _investmentLab.text = _InvestmentAmountTF.text;
            _userMoenyLab.text = [NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue] - [self.redBsetLab.text doubleValue]];
            _setMoenyLasb.text = @"0.00";
            
        }else{
            _investmentLab.text = _InvestmentAmountTF.text;
            _userMoenyLab.text = userSurplusMoney;
            _setMoenyLasb.text = [NSString stringWithFormat:@"%.2f", [[NSString stringWithFormat:@"%.2f", [self.InvestmentAmountTF.text doubleValue]- [userSurplusMoney doubleValue] - [self.redBsetLab.text doubleValue]] doubleValue] ];
        }


    };
    [self customPushViewController:myRedenvelopeListView customNum:0];
    
    
}
@end
