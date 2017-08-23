//
//  SettingViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "GestureVerifyViewController.h"
#import "GestureViewController.h"
#import "LoginPswViewController.h"
#import "PCCircleViewConst.h"
#import "SettingViewController.h"
#import "TradePswViewController.h"
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"
#import "MyBankCardViewController.h"
#import "ChangeViewController.h"
#import "AutoBidViewController.h"
#import "Masonry.h"
typedef NS_ENUM(NSInteger, ButtonJumpType) {
    RecentlyState = 0,//充值 已注
    WithdrawState,    //提现 已注
    ChangeMoneyState, //零钱包
    AutoBidState,     //自动投标
};

@interface SettingViewController ()<UIAlertViewDelegate> {
    int  index;
    BOOL IsOpen;
    NSDictionary *_accinfoDict;
    UISwitch *_switchBtn;
    UIButton *_btn;
    NSInteger setSwitchOpen;
    UIAlertView * alertTel;
    UIAlertView *exitAlert;
    UIAlertView *certificationAlert;//实名认证
    NSArray * _titleArray;
    CGFloat _scrollHeight;//调节scrollV高度
    
    NSTimer * _timer;
    UIAlertView * changeMoneyAlert; //零钱包
    UIAlertView * autoBidAlert;     //自动投标

}
@property (weak, nonatomic) IBOutlet UILabel *kefuLab;
@property (nonatomic, assign) BOOL isHavePayPassworld; //是否有交易密码
@property (weak, nonatomic) IBOutlet UILabel *VersionsLabel;
@property (copy, nonatomic) NSDictionary * customServiceDict;
@property (nonatomic, strong) UISwipeGestureRecognizer *topSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *bottomSwipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (nonatomic, copy) NSDictionary *accinfoDict;          //资产数据
@property (nonatomic, copy) NSDictionary *UserInformationDict;  //用户信息字典
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:self.title];
    [self setQLStatusBarStyleDefault];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadSettingData]; //addData->reloadData
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
    [self setQLStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCustomerServiceData];
    [self resetSideBack];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview.scrollEnabled = YES;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
//    if (iPhone5) {
//        self.tableview.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneWidth - 100);
//    }
    _customServiceDict = [NSDictionary dictionary];
    DetailPageNavigationView *settingView = [[DetailPageNavigationView alloc] initWithDetailPageNavigationViewTitle:@"账户设置" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    
    settingView.lineLabel.hidden = YES;
    
    [self.view addSubview:settingView];
    
    [self saveNSUserDefaults];
    
    [self addSwipeGesture];
    
    //    _titleArray = @[@"登录密码",
    //                    @"支付密码",
    //                    @"手势密码",
    //                    @"银行卡管理",
    //                    @"实名认证",
    //                    @"手机号码"]; //版本号xib中体现
    
    //存放列表图片和标题
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"settingTitleAndImagePlist" ofType:@"plist"];
    _titleAndimageArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    index = 0;
    
    //版本号
    self.VersionsLabel.text = [NSString stringWithFormat:@"v%@",[self getLocalAppVersion]];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myAction)];
    [self.myView addGestureRecognizer:myTap];
    
    [self loadSettingData];
}

- (void)loadCustomerServiceData {
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/queryServiceHotline?at=%@", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _customServiceDict = [responseObject[@"item"] copy];
                _kefuLab.text = _customServiceDict[@"workTime"];
                
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  
                              }];
}


- (void)addSwipeGesture
{
    self.topSwipeGestureRecognizer    = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.bottomSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.topSwipeGestureRecognizer.direction    = UISwipeGestureRecognizerDirectionUp;
    self.bottomSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.SettingView addGestureRecognizer:self.topSwipeGestureRecognizer];
    [self.SettingView addGestureRecognizer:self.bottomSwipeGestureRecognizer];
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        
        CGFloat toTopHeight , iPhoneHt;
        /*
         if (iPhone5){
         toTopHeight = 10.0f;
         iPhoneHt = 10.0f;
         }
         else */if(iPhone4)
         {
             toTopHeight = -80.0f;
             iPhoneHt = 80.0f;
         }
         else{
             toTopHeight = 64.0f;
             iPhoneHt = 0.0f;
         }
        
        //滑动效果（动画）
        NSTimeInterval animationDuration = 0.1f;
        [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动
        self.SettingView.frame = CGRectMake(0.0f, toTopHeight, self.view.frame.size.width, self.view.frame.size.height + iPhoneHt);
        
        [UIView commitAnimations];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        
        //滑动效果
        NSTimeInterval animationDuration = 0.1f;
        [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //恢复屏幕
        self.SettingView.frame = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)myAction{
    [self jumpToWebview:PlatformIntroduced webViewTitle:@"关于白杨"];
}

//TODO:返回按钮
- (void)goBack {
    [self customPopViewController:0];
}


#pragma mark - 加载数据
- (void)loadSettingData {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadSettingData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadSettingData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _accinfoDict = [responseObject[@"item"] copy];
                if (_accinfoDict != nil) {
                    if (![_accinfoDict[@"pay"] isKindOfClass:[NSNull class]] && [_accinfoDict[@"pay"] integerValue] == 1) {
                        _isHavePayPassworld = YES;
                    }
                    [_tableview reloadData];
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  index++;
                                  if (index < 3) {
                                      [self loadSettingData];
                                  }else{
                                      [self errorPrompt:3.0 promptStr:errorPromptString];
                                  }
                              }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithRed:58 / 255.0 green:58 / 255.0 blue:58 / 255.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:137 / 255.0 green:137 / 255.0 blue:137 / 255.0 alpha:1.0];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cell.textLabel.text = _titleArray[indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"头像";
            if (!_btn) {
                _btn = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth-40, 7, 30, 30)];
            }
            [_btn setImage:[UIImage imageNamed:@"ios图标_28 "] forState:UIControlStateNormal];
            [cell.contentView addSubview:_btn];

        }else if (indexPath.row == 1){
            cell.textLabel.text = @"实名认证";
            if (![_accinfoDict[@"idNumberHidden"] isKindOfClass:[NSNull class]]  && [self isLegalObject:_accinfoDict]) {
                if ([_accinfoDict[@"realStatus"] integerValue] == 0) {
                    cell.detailTextLabel.text = _accinfoDict[@"idNumberHidden"];
                } else {
                    cell.detailTextLabel.text = @"未认证";
                }
            } else {
                cell.detailTextLabel.text = @"未认证";
            }
            
        }else{
            
            cell.textLabel.text = @"手机号码";
            NSString * valueString = getObjectFromUserDefaults(MOBILE);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@*****%@", [valueString substringWithRange:NSMakeRange(0, 3)], [valueString substringWithRange:NSMakeRange(8, 3)]];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"自动投标";
            
        }else{
            cell.textLabel.text = @"银行卡";
            if (![_accinfoDict[@"idNumberHidden"] isKindOfClass:[NSNull class]]  && [self isLegalObject:_accinfoDict]) {
                if ([_accinfoDict[@"realStatus"] integerValue] == 0) {
                    cell.detailTextLabel.text = @"1张";
                } else {
                    cell.detailTextLabel.text = @"0张";
                }
            } else {
                cell.detailTextLabel.text = @"0张";
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改登录密码";
        }else{
            cell.textLabel.text = @"修改支付密码";
        }
        
//        else{
//            cell.textLabel.text = @"手势密码";
//            if (!_switchBtn) {
//                _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(iPhoneWidth-65, 7, 0, 0)];
//            }
//            if (setSwitchOpen == 1) {
//                IsOpen = YES;
//                [_switchBtn setOn:YES];
//            } else {
//                IsOpen = NO;
//                [_switchBtn setOn:NO];
//            }
//            
//            [_switchBtn addTarget:self action:@selector(switchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:_switchBtn];
//            
//        }
    }else{
        cell.textLabel.text = @"客服电话";
        cell.detailTextLabel.text = _customServiceDict[@"service_hotline"];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:@"#999999"];
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2){
        if (indexPath.row != 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    switch (indexPath.row) {
        case 2:
        {
        }
            break;
        case 3:
        {
        }
            break;
        case 4:
        {
        }
            break;
        case 5:
        {
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if(indextPath.section == 0){
//        return 0;
//    }
    if (section == 0) {
        return 0;
    }
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            _isHavePayPassworld = YES;
        }
    };
    [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [self customPushViewController:setPaymentPassWorldView customNum:1];
}


- (void)getMyBankCardinformation{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    //加载框
    WS(weakSelf);
    //    [_viewController showWithDataRequestStatus:@"加载中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsiteT] parameters:parameters success:^(id responseObject) {
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
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isKindOfClass:[NSNull class]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
                
                //自动投标
                if ([_UserInformationDict[@"status"] integerValue] == 2 ) {
                    autoBidAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"自动投标需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                    [autoBidAlert show];
                } else {
                    
                    AutoBidViewController *AutobidView = [[AutoBidViewController alloc] init];
                    AutobidView.backAssetsView = ^(NSDictionary *autoSettingDict) {
                        if ([autoSettingDict[@"enabled"] integerValue] == 0) { //自动投标关闭
                            // self.autoNumberLable.text = @"无忧理财!";
                            // self.autoexplainLable.text = @"(未开启)";
                        } else {
                            // self.autoNumberLable.text = @"无忧理财!";
                            //self.autoexplainLable.text = @"(已开启)";
                        }
                    };
                    [self customPushViewController:AutobidView customNum:0];
                }
            }
            
            /*branchState 为0的话  可以修改支行信息  为1 不可修改支行信息
             *state 为1锁住银行信息  为2已审核可以更改   为3 提现审核中不可修改
             *status 1有卡 2无卡  3替换
             *realStatus 0 身份信息通过  1不通过  2审核中
             */
            
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self showErrorViewinMain];
                              }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (_isHavePayPassworld) {
            [self getMyBankCardinformation];
            
            
            
        }else{
            [self dismissWithDataRequestStatus];
            [self setPaymentPassWordController];
            
            NSLog(@"456");
        }
        
        
        // [self loadSettingData:AutoBidState];
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        LoginPswViewController *loginVc = [[LoginPswViewController alloc] init];
        [self customPushViewController:loginVc customNum:0];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        if (!_isHavePayPassworld) {
            exitAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"你还没有支付密码,请先设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            exitAlert.tag = 11111;
            [exitAlert show];
        } else {
            TradePswViewController *tradeVc = [[TradePswViewController alloc] init];
            [self customPushViewController:tradeVc customNum:0];
        }
    }
    
    if ( indexPath.section == 1 && indexPath.row == 1) {//银行卡
        //我的银行卡
        MyBankCardViewController *myBankCard = [[MyBankCardViewController alloc] init];
        [self customPushViewController:myBankCard customNum:0];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (![_accinfoDict[@"idNumberHidden"] isKindOfClass:[NSNull class]]) {
            if ([_accinfoDict[@"realStatus"] integerValue] == 0) {
                
            } else {
                certificationAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有实名认证,请先认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [certificationAlert show];
            }
        } else {
            certificationAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有实名认证,请先认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [certificationAlert show];
        }
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_customServiceDict[@"service_hotline"]];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

- (void)switchBtnClick {
    if (IsOpen == NO) {
        //打开Switch开关后 弹出设置手势密码界面
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;
        gestureVc.hidesBottomBarWhenPushed = YES;
        gestureVc.isSettingGesture = YES;
        gestureVc.openGesture = ^(BOOL isOpen) {
            if (isOpen) {
                [self saveNSUserDefaults];
                [_switchBtn setOn:YES];
                IsOpen = YES;
            }
        };
        [self presentViewController:gestureVc animated:YES completion:^{
        }];
        
    } else if (IsOpen == YES) {
        //关闭手势密码 弹出验证手势密码界面
        GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
        gestureVerifyVc.hidesBottomBarWhenPushed = YES;
        gestureVerifyVc.closeGesture = ^(BOOL isClose) {
            if (isClose) {
                [self saveNSUserDefaults];
                [_switchBtn setOn:NO];
                IsOpen = NO;
            } else {
                [self saveNSUserDefaults];
                [_switchBtn setOn:YES];
                IsOpen = YES;
            }
        };
        [self presentViewController:gestureVerifyVc animated:YES completion:^{
            
        }];
    }
}

//将手势密码的开关状态保存到本地
- (void)saveNSUserDefaults {
    if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length] > 0) {
        setSwitchOpen = 1;
    } else {
        setSwitchOpen = 0;
    }
    //刷新
    //    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    //    [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 退出登陆
- (IBAction)exitBtn:(id)sender {
    exitAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    exitAlert.tag = 10000;
    [exitAlert show];
}

#pragma mark - UIAlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0 && alertView == exitAlert)
    {
        if (alertView.tag == 10000) {
            removeObjectFromUserDefaults(UID);
            removeObjectFromUserDefaults(SID);
            //            removeObjectFromUserDefaults(USERNAME);
            //            removeObjectFromUserDefaults(MOBILE);
            //            removeObjectFromUserDefaults(PAYPSWSTATUS);
            removeObjectFromUserDefaults(gestureFinalSaveKey);
            removeObjectFromUserDefaults(InviteCode);
            //            self.exitLogin(YES);
            [self customPopViewController:3];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginBackMainView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscoveryView object:@"退出刷新发现"];
            //            [self performSelector:@selector(goBack) withObject:nil afterDelay:0.5f];
        } else{
            setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
            setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
                if (ishavePW) {
                    _isHavePayPassworld = YES;
                }
            };
            [self customPushViewController:setPaymentPassWorldView customNum:1];
        }
    }else if (buttonIndex != 0 && alertView == certificationAlert){
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_accinfoDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
    
    if (buttonIndex != 0 && alertView == alertTel) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_customServiceDict[@"service_hotline1"]?_customServiceDict[@"service_hotline1"]:@"-"]]];//@"tel://4006865850"]];
    }
    
    if (buttonIndex != 0 && alertView == autoBidAlert) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_accinfoDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
        
    }
}
@end
