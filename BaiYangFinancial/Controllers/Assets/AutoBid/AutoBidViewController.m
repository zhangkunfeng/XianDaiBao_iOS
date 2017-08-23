//
//  AutoBidViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/17.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AutoBidViewController.h"
#import "BindingBankCardViewController.h"
#import "SelfSetingViewController.h"
#import "AssetsRulesViewController.h"
#import "PhotosScrollViewController.h"

@interface AutoBidViewController () {
    NSDictionary *_accinfoDict;
    NSDictionary *_UserInformationDict; //用户信息
    NSString *MonthMin;
    NSString *MonthMax;
    NSString *AmountMin;
}

@end

@implementation AutoBidViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"自动投标"];
    [AFNetworkTool cancelAllHTTPOperations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"自动投标"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self resetSideBack];
    [self showWeidaiLoadAnimationView:self];

    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"自动投标" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    [self loadAutoData];
    [self addTapGesture];
    if (iPhone4) {
        self.backScrollerView.scrollEnabled = YES;
    } else {
        self.backScrollerView.scrollEnabled = NO;
    }
    MonthMin = @"0";
    MonthMax = @"0";
    AmountMin = @"0";
}
//设置投标开关的开启或关闭状态
- (void)setSwitchButton {
    if (self.openSwitch.on) {
        _isOpenswith = @"1";
    } else {
        _isOpenswith = @"0";
    }

    if (![self isBlankString:_isOpenswith]) {//有值
        [self getMyBankCardinformation];
    }
}
#pragma mark - 设置自动投标的时候先获取用户的信息
- (void)getMyBankCardinformation {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
    };
    WS(weakSelf);
    [self showWithDataRequestStatus:@"设置中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getMyBankCardinformation];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getMyBankCardinformation];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([responseObject[@"item"][@"realStatus"] integerValue] == 0) {
                    [self setAutoBidisOpen];
                } else {
                    [self dismissWithDataRequestStatus];
                    [self initWithsetAutoError];
                    if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                        _UserInformationDict = [responseObject[@"item"] copy];
                        //没有认证过去认证
                        UIAlertView *exitAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"设置自动投标需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        [exitAlert show];
                    }
                }
            } else {
                [self initWithsetAutoError];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
        fail:^{
            [self initWithsetAutoError];
            [self errorPrompt:3.0 promptStr:@"设置失败，亲重试"];
        }];
}
- (void)addTapGesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBtnClick:)];
    [self.autoSettingView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoBidbuttonAction:)];
    [self.aboutBidRule addGestureRecognizer:tap1];
}
#pragma mark - 加载数据
- (void)loadAutoData {
    
    if (![self isBlankString:getObjectFromUserDefaults(UID)]) {
        NSDictionary *parameters = @{
            @"uid": getObjectFromUserDefaults(UID),
            @"sid": getObjectFromUserDefaults(SID),
            @"at": getObjectFromUserDefaults(ACCESSTOKEN),
        };
        [self showWithDataRequestStatus:@"加载中..."];
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getAutoBid", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadAutoData];
        } withFailureBlock:^{
            
        }];
                } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadAutoData];
                } withFailureBlock:^{
                    
                }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self dismissWithDataRequestStatus];
                    if ([[responseObject objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        _accinfoDict = [responseObject objectForKey:@"item"];
//                        NSLog(@"loadAutoData = %@",_accinfoDict);
                        saveObjectToUserDefaults([NSString stringWithFormat:@"%@",_accinfoDict[@"enabled"]], SWITCHOPEN);
                        [self setvalue];
                    }
                    [self dismissWeidaiLoadAnimationView:self];
                } else {
                    [self dismissWeidaiLoadAnimationView:self];
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
                }
            }
        }
            fail:^{
                [self dismissWeidaiLoadAnimationView:self];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
            }];
    }
}
//设置自动投标界面的数据
- (void)setvalue {
    NSString *leftMonthStr = [[_accinfoDict objectForKey:@"timeLimitMonthMin"] stringValue];
    if ([leftMonthStr isEqualToString:@"0"]) {
        self.leftMonth.text = @"不限";
    } else {
        MonthMin = [NSString stringWithFormat:@"%zd", [[_accinfoDict objectForKey:@"timeLimitMonthMin"] integerValue]];
        ;
        self.leftMonth.text = [NSString stringWithFormat:@"%@个月", MonthMin];
    }
    NSString *rightMonthStr = [[_accinfoDict objectForKey:@"timeLimitMonthMax"] stringValue];
    if ([rightMonthStr isEqualToString:@"0"]) {
        self.rightMonth.text = @"不限";
    } else {
        MonthMax = [NSString stringWithFormat:@"%zd", [[_accinfoDict objectForKey:@"timeLimitMonthMax"] integerValue]];
        self.rightMonth.text = [NSString stringWithFormat:@"%@个月", MonthMax];
    }
    NSString *minAmountStr = [[_accinfoDict objectForKey:@"minAmount"] stringValue];
    if ([minAmountStr isEqualToString:@"0"]) {
        self.minAmount.text = @"不限";
    } else {
        AmountMin = [NSString stringWithFormat:@"%.2f", [[_accinfoDict objectForKey:@"minAmount"] doubleValue]];
        ;
//        self.minAmount.text = [NSString stringWithFormat:@"%@%@", [_accinfoDict objectForKey:@"minAmount"], @"元"];
        self.minAmount.text = [NSString stringWithFormat:@"%@元", [Number3for1 formatAmount:[_accinfoDict objectForKey:@"minAmount"]]];
    }
    //判断是否开启自动投标
    if ([_accinfoDict[@"enabled"] integerValue] == 0) {
        
        self.topAutoNumberLable.text = @"当前开启自动投标人数";
        [self.openSwitch setOn:NO];
        _isOpenswith = @"0";
        self.openLab.text = @"已关闭";
        self.bidSetView.hidden = YES;
        self.bidSetHeightConstraint.constant = 0;
//        self.openLab.textColor = [UIColor redColor];
        
//        self.partLeftLabel.text = @"";
//        self.partRightLabel.text = @"";
        [self.view layoutIfNeeded];
    } else {
        [self.openSwitch setOn:YES];
        self.topAutoNumberLable.text = @"我的自动投标排名";
        _isOpenswith = @"1";
        self.openLab.text = @"已开启";
        self.bidSetView.hidden = NO;
//        self.openLab.textColor = RGB(91, 192, 249);
        self.bidSetHeightConstraint.constant = 98;
        
//        self.numberLab.text = @"";
        [self.view layoutIfNeeded];
    }

    [self numberLabel];
}
//TODO:当前排队投标人数
- (void)numberLabel {
    if ([_isOpenswith isEqualToString:@"0"]) {
        //略繁琐
        self.numberLab.hidden = NO;
        self.partRightLabel.hidden = YES;
        self.partLeftLabel.hidden = YES;
        self.partLeftLabel.text = @"";
        self.partRightLabel.text = @"";
        
        self.numberLab.text = [NSString stringWithFormat:@"%@人", [_accinfoDict objectForKey:@"count"]];
    } else {
        self.numberLab.hidden = YES;
        self.partRightLabel.hidden = NO;
        self.partLeftLabel.hidden = NO;
        //自动排行右边部分
        self.partLeftLabel.text = [NSString stringWithFormat:@"%zd",[_accinfoDict[@"rank"] integerValue]];
        self.partRightLabel.text = [NSString stringWithFormat:@"/%@",[_accinfoDict objectForKey:@"count"]];
        
//        self.numberLab.text = [NSString stringWithFormat:@"%zd/%@", [_accinfoDict[@"rank"] integerValue], [_accinfoDict objectForKey:@"count"]];
    }
}
//TODO:投标开关按钮
- (IBAction)switchBtn:(id)sender {
    [self setSwitchButton];
}
//TODO:自助设置按钮
- (void)setBtnClick:(UITapGestureRecognizer *)tap{
//    self.setBtn.enabled = NO;
//    self.setBtn.adjustsImageWhenHighlighted = NO;//设置点击不高亮
    SelfSetingViewController *setVc = [[SelfSetingViewController alloc] initWithNibName:@"SelfSetingViewController" bundle:nil];
    //传值给下一页面数据
    setVc.minMonthString = self.leftMonth.text; //1个月
    setVc.maxMonthString = self.rightMonth.text;//3个月
    setVc.minAmountString = self.minAmount.text;//467,834,567.00元
    setVc.isOpenAutoBid = _isOpenswith;

    //下级页面修改保存后回调赋值给本级页面
    setVc.backAutoBidViewValue = ^(NSString *minMonth, NSString *maxMonth, NSString *minMoney) {
//        NSLog(@"%@",maxMonth);
//        NSLog(@"%@",minMonth);
//        NSLog(@"%@",minMoney);
        MonthMin = minMonth;
        MonthMax = maxMonth;
        AmountMin = minMoney;
        if ([minMonth isEqualToString:@"0"]) {
            self.leftMonth.text = @"不限";
        } else {
            self.leftMonth.text = [NSString stringWithFormat:@"%@个月", minMonth];
        }
        if ([maxMonth isEqualToString:@"0"]) {
            self.rightMonth.text = @"不限";
        } else {
            self.rightMonth.text = [NSString stringWithFormat:@"%@个月", maxMonth];
            ;
        }
        if ([minMoney isEqualToString:@"0"]) {
            self.minAmount.text = @"不限";
        } else {
            self.minAmount.text = [NSString stringWithFormat:@"%@元", [Number3for1 formatAmount:minMoney]];
            ;
        }
    };
    [self customPushViewController:setVc customNum:0];
}
//TODO:返回按钮
- (void)goBack {
    if (self.pushNumber == 10010) {
        [self customPopViewController:3];
    } else {
        [self customPopViewController:0];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setAutoBidisOpen {
    NSDictionary *parameters = @{
        @"uid": getObjectFromUserDefaults(UID),
        @"sid": getObjectFromUserDefaults(SID),
        @"at": getObjectFromUserDefaults(ACCESSTOKEN),
        @"timeLimitMonthMin": MonthMin,
        @"timeLimitMonthMax": MonthMax,
        @"minAmount": AmountMin,
        @"enabled": _isOpenswith,
    };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/setAutoBid", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf setAutoBidisOpen];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf setAutoBidisOpen];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                _accinfoDict = nil;
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _accinfoDict = [responseObject[@"item"] copy];
                    //回调我的资产界面展示
                    if (_accinfoDict != nil) {
                        NSLog(@"%@",_accinfoDict);
                        self.backAssetsView(_accinfoDict);
                    }
                    saveObjectToUserDefaults([NSString stringWithFormat:@"%@",_accinfoDict[@"enabled"]], SWITCHOPEN);
                    [self setvalue];
                }
                [self showWithSuccessWithStatus:@"设置成功"];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshProductList object:nil];
            } else {
                [self initWithsetAutoError];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
        fail:^{
            [self initWithsetAutoError];
        }];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {

        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}

// 设置失败的时候
- (void)initWithsetAutoError {
    if ([_isOpenswith isEqualToString:@"1"]) {
        _isOpenswith = @"0";
        [self.openSwitch setOn:NO];
        self.openLab.text = @"关闭中";
//        self.openLab.textColor = [UIColor redColor];
        self.bidSetView.hidden = YES;
        self.bidSetHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } else {
        _isOpenswith = @"1";
        [self.openSwitch setOn:YES];
        self.openLab.text = @"已开启";
//        self.openLab.textColor = RGB(91, 192, 249);
        self.bidSetView.hidden = NO;//未连接
        self.bidSetHeightConstraint.constant = 98;//未连接
        [self.view layoutIfNeeded];
    }
}

- (void)autoBidbuttonAction:(UITapGestureRecognizer *)tap{
#if 0    
    PhotosScrollViewController * autoBidRuleView = [[PhotosScrollViewController alloc] init];
    [autoBidRuleView createPhotosScrollViewTitleString:@"自动投标" photoImageString:@"http://qianluwangstyle.oss-cn-hangzhou.aliyuncs.com/zdtbPic/zdtb.png" imageType:ImageUrlStrType heightWidthScale:0];
    [self customPushViewController:autoBidRuleView customNum:0];
        
#elif 0
    AssetsRulesViewController * assetsRulesVC = [[AssetsRulesViewController alloc] init];
    assetsRulesVC.rulesType = AutoBidRulesType;
    [self customPushViewController:assetsRulesVC customNum:0];
#elif 1
    [self jumpToWebview:AutoBidguizeURL webViewTitle:@"自动投标"];
#endif
}
@end
