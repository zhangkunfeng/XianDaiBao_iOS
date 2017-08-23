//
//  MDAssetsViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/11/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "MDAssetsViewController.h"
#import "MyAssetsBottomView.h"
#import "VerificationiPhoneNumberViewController.h"
#import "WDFinancialPlannerViewController.h"
#import "Masonry.h"
//#import "MyInviteHongBaoViewController.h"
#import "BYInviteEnvelopeViewController.h"
#import "BindingBankCardViewController.h"
#import "RechargeMyAssetsViewController.h"
#import "WithdrawViewController.h"
#import "setPaymentPassWorldViewController.h"
#import "CreditRechargeViewController.h"
#import "PaySelectedView.h"
#import "SettingViewController.h"
#import "BorrowingRecordViewController.h"
#import "RedenvelopeViewController.h"
#import "NewDiscoveryViewController.h"
#import "ChangeViewController.h"
#import "ChanLingViewController.h"
#import "RecentlyBidViewController.h"
#import "RechargeRecordViewController.h"
#import "DiscoverController.h"
#import "DiscoverControllerOne.h"

@interface MDAssetsViewController () <UITableViewDataSource, UITableViewDelegate, MyAssetsButtonViewDelegate,PaySelectedViewDelegate>
{
    NSArray * _imageArray;
    NSArray * _titleArray;
    NSMutableArray * payNameArray;

    UIAlertView * _bankAlertView;        //邀请红包
    UIAlertView * _rechargeWithdrawAlert;//充值、提现
    UIAlertView *changeMoneyAlert;
}

@property (nonatomic, assign) BOOL isHavePayPassworld;  //是否有交易密码、
@property (nonatomic, assign) BOOL isShowBorrowingCell; //是否有借款人权限
@property (nonatomic, strong) UITableView *AssetsTableView;
@property (nonatomic, copy) NSDictionary *accinfoDict; //请求存储字典
@property (nonatomic, copy) NSDictionary *UserInformationDict;
@property (nonatomic, copy) NSDictionary *customServiceDict;

@property (nonatomic,weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong) PaySelectedView * paySelectedView;//选择支付方式视图
@property (nonatomic, strong) MyAssetsBottomView *bottomView;
@property (nonatomic, strong) MyAssetsBottomViewFooter *footerView;

@property (weak, nonatomic) IBOutlet UIView *NavgationView;
@property (weak, nonatomic) IBOutlet UILabel *NavgationLabel;
@property (weak, nonatomic) IBOutlet UIView *chargeWithDrawView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (nonatomic, strong) NewDiscoveryViewController *discoveryViewController;
@property (nonatomic, strong)NSString *sstr;
@property (nonatomic, strong)UIView *footView;
- (IBAction)chargeBtnClicked:(id)sender;
- (IBAction)withdrawBtnClicked:(id)sender;
- (IBAction)settingBtnClicked:(id)sender;
- (IBAction)helpCenterBtnClicked:(id)sender;
@end

@implementation MDAssetsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self isUserLogin];
    [self gif];
}

//解决APP界面卡死Bug
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

-(void)gif{

    _bottomView.gifImg.image = [UIImage imageNamed:@"ff1.png"];
    
    
    //添加_花
    NSMutableArray *imageArray1 = [NSMutableArray array];
    for (int i = 1; i <= 2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ff%d.png",i]];
        [imageArray1 addObject:image];
    }
    //UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 420, 70, 70)];
    //设置动画数组
    _bottomView.gifImg.animationImages = imageArray1;
    //设置动画间隔
    _bottomView.gifImg.animationDuration = 2;
    //设置循环次数
    _bottomView.gifImg.animationRepeatCount = 0;
    //开始动画
    [_bottomView.gifImg startAnimating];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; //选中的这个keyPath就是缩放
    scaleAnimation.fromValue = [NSNumber numberWithDouble:0.5]; //一开始时是0.5的大小
    scaleAnimation.toValue = [NSNumber numberWithDouble:1];  //结束时是1.5的大小

    scaleAnimation.duration = 1; //设置时间
    scaleAnimation.repeatCount = MAXFLOAT; //重复次数
    [_bottomView.gifImg.layer addAnimation:scaleAnimation forKey:@"CQScale"]; //添
 
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self isUserLogin];
    //[self resetSideBack];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshselfView:) name:SendToMyAssets object:nil];
        
    _imageArray = @[  @[@"borrowing_icon",
                      @"help",
                      @"about",
                      @"set"]
                    ];
    
    _titleArray = @[
                    @[@"借款记录",
                      @"帮助中心",
                      @"关于贤钱宝",
                      @"账户设置"]
                    ];
    
    self.chargeBtn.layer.cornerRadius = self.chargeBtn.frame.size.height/2;
    self.withdrawBtn.layer.cornerRadius = self.withdrawBtn.frame.size.height/2;
   
    
    _AssetsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-49-64) style:UITableViewStylePlain];
    _AssetsTableView.backgroundColor = [UIColor clearColor];
    _AssetsTableView.delegate = self;
    _AssetsTableView.dataSource = self;
    [self.view addSubview:_AssetsTableView];
    
    _AssetsTableView.tableFooterView = [UIView new];
    //_AssetsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 2)];
    //_AssetsTableView.tableFooterView.backgroundColor = [UIColor colorWithHex:@"F6F6F6"];
    if (!_bottomView) {
        _bottomView = [[MyAssetsBottomView alloc] initWithViewFram:CGRectMake(0, 0, iPhoneWidth, 384) viewController:self theDelegate:self];
        //        _bottomView.delegate = self;
    }
    
    
    [_bottomView.tixianBtn addTarget:self action:@selector(withdrawBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView.chongzhiBtn addTarget:self action:@selector(chargeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView.tixianBtn.layer setBorderWidth:1.0];
    [_bottomView.tixianBtn.layer setBorderColor:[UIColor colorWithHex:@"05CBF3"].CGColor];//边框颜色
    [self gif];
//    if (_accinfoDict) {
//        [_bottomView setMDAssetsView:_accinfoDict];
//    }
    
    
    
                    _AssetsTableView.tableHeaderView = _bottomView;
    
    [self setupHeader];
}

#pragma mark - 下拉加载
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_AssetsTableView];
    _weakRefreshHeader = refreshHeader;
    [_weakRefreshHeader settingTextIndicatorColorIsChange:YES];
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _activityIndicatorView.hidden = NO;
            [_activityIndicatorView startAnimating];
            [self loadBorrowingDataForShowBorrowingCell];
            [self loadMyassetsData];
            [self loadCustomerServiceData];
            [_weakRefreshHeader endRefreshing];
        });
    };
}
#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;//只要滚动了就会触发
{
    if (scrollView.contentOffset.y > 45){
        [UIView animateWithDuration:1.0f animations:^{
            self.NavgationLabel.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:1.0f animations:^{
            self.NavgationLabel.alpha = 0;
        }];
    }
}

#pragma mark 判断是否登录
- (void)isUserLogin {

//    _noLoginBackgroundView.hidden = YES;
//    [self.view sendSubviewToBack:_noLoginBackgroundView];
//    _activityIndicatorView.hidden = NO;
//    [_activityIndicatorView startAnimating];
//    [self loadMyassetsData];
    
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) {//无为真
        VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verfication.pushviewNumber = 1234;
        [self customPushViewController:verfication customNum:0];
    } else {
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        [self loadBorrowingDataForShowBorrowingCell];
        [self loadMyassetsData];
        [self loadCustomerServiceData];
    }
}

#pragma mark - 去登陆
- (void)gotoVerificationiPhoneNumberViewController:(id)sender { //应该不走
    VerificationiPhoneNumberViewController *verifcationiPhone = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
    [self customPushViewController:verifcationiPhone customNum:0];
}

#pragma mark - 刷新数据
- (void)RefreshselfView:(NSNotification *)notification {
    [_AssetsTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self isUserLogin];
}

- (void)hideactivityIndicatorView {
    _activityIndicatorView.hidden = YES;
    [_activityIndicatorView stopAnimating];
}

#pragma mark - 加载数据
- (void)loadMyassetsData {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at" : getObjectFromUserDefaults(ACCESSTOKEN),};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/acInformaction", GeneralWebsiteT] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadMyassetsData];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadMyassetsData];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self performSelector:@selector(hideactivityIndicatorView) withObject:nil afterDelay:0.5f];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _accinfoDict = nil;
                    _accinfoDict = [responseObject[@"item"] copy];
                    _sstr = _accinfoDict[@"waitTotalMouth"];
                    if (_accinfoDict != nil) {
                        [_bottomView setMDAssetsView:_accinfoDict];
                        [_AssetsTableView reloadData];
                    }
                }
            } else {
                [self performSelector:@selector(hideactivityIndicatorView) withObject:nil afterDelay:0.5f];
            }
        }
    }
        fail:^{
            [self performSelector:@selector(hideactivityIndicatorView) withObject:nil afterDelay:0.5f];
            [self showErrorViewinMain];
        }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _titleArray[section];
    return _isShowBorrowingCell?arr.count:arr.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableViewID = @"aboutBaiYangFinancialTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewID];
        
    }
    if (indexPath.row == _titleArray.count-2){
        cell.separatorInset = UIEdgeInsetsMake(0, iPhoneWidth, 0, 0);
    
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.AssetsTableView setSeparatorColor:[UIColor colorWithHex:@"E1E1E1"]];
    NSArray *img = _imageArray[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:img[_isShowBorrowingCell?indexPath.row:indexPath.row+1]];
    NSArray *title = _titleArray[indexPath.section];
    cell.textLabel.text = title[_isShowBorrowingCell?indexPath.row:indexPath.row+1];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    cell.textLabel.textColor = [UIColor colorWithHex:@"222222"];
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;//371+7.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    //帮助中心
                    [self jumpToWebview:HelpCenterURL webViewTitle:@"帮助中心"];

//                    //本月代收
//                    RecentlyBidViewController *RecentlyBidVc = [[RecentlyBidViewController alloc] init];
//                    [self customPushViewController:RecentlyBidVc customNum:0];
                }
                    break;
                case 1:{
                    //零钱包
                   // [self loadSettingData];
                    
                    //关于贤钱宝
                    [self jumpToWebview:PlatformIntroduced webViewTitle:@"关于贤钱宝"];
                
                }
                    break;
                    
                case 2:{
                    //账户设置
                    SettingViewController *settingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                    settingView.exitLogin = ^(BOOL isexit) {
                        if (isexit) {
                            [self exitUserBlock];//代理回controller执行 1.MDAssets 2.Follow
                        }
                    };
                    [self customPushViewController:settingView customNum:0];

                
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                //资产流水
                    
                    RechargeRecordViewController *RechargeRecordView = [[RechargeRecordViewController alloc] init];
                    [self customPushViewController:RechargeRecordView customNum:0];
                }
                    break;
                case 1:
                {
                //我的定期
                    DiscoverControllerOne *isDingVC = [[DiscoverControllerOne alloc]init];
                    [self customPushViewController:isDingVC customNum:0];
                }
                    break;
                case 2:
                {
                //我的红包
                    RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] init];
                    [self customPushViewController:myRedenvelopeView customNum:0];
                }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
               
                    
                }
                    break;
                case 1:
                {
                   
                }
                    break;

                case 2:{
                //账户设置
                    
                }
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
}
- (void)loadSettingData  {
    [self showWithDataRequestStatus:@"加载中..."];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
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
                NSDictionary * dic = [responseObject[@"item"] copy];
                if (dic != nil) {
                    if (![dic[@"pay"] isKindOfClass:[NSNull class]] && [dic[@"pay"] integerValue] == 1) {
                        //                        _isHavePayPassworld = YES;
                        [self getMyBankCardinformation];
                        
                    }else{
                        [self dismissWithDataRequestStatus];
                        [self setPaymentPassWordController];
                    }
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self showErrorViewinMain];
                              }];
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
                
                //零钱包
                if ([_UserInformationDict[@"status"] integerValue] == 2) {
                    changeMoneyAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"零钱计划需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                    [changeMoneyAlert show];
                } else {
                    ChangeViewController * changeVC = [[ChangeViewController alloc] initWithNibName:@"ChangeViewController" bundle:nil];
                    [self customPushViewController:changeVC customNum:0];
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


- (void)exitUserBlock {
    [_AssetsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_bottomView initializeView];
    [self isUserLogin];
}

- (IBAction)settingBtnClicked:(id)sender {
    //账户设置
#if 0
    /**
     之前看到 @maple 分享的一键开启这几个功能的 Url scheme ：
     支付宝扫码  alipayqr://platformapi/startapp?saId=10000007
     支付宝付款码 alipayqr://platformapi/startapp?saId=20000056
     微信扫一扫的 weixin://dl/scan  //已失效
     QQ扫一扫代码 mqq://dl/scan/scan
     //之前配置的白名单，就是需要跳转对方App的key，即对方设置的url
     */
    
    NSArray * arrayUrl = @[@"weixin://",
                           @"alipayqr://platformapi/startapp?saId=10000007",
                           @"alipayqr://platformapi/startapp?saId=20000056"];
    
    NSString * urlStr = arrayUrl[arc4random()%3];
    NSURL * url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"跳转的应用程序未安装" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    
#elif 0
    
    BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
    BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
    BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
        
    };
    BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
    [self customPushViewController:BindingBankCardView customNum:0];
    
#elif 1
    if (!_discoveryViewController) {
        _discoveryViewController = [[NewDiscoveryViewController alloc] initWithNibName:@"NewDiscoveryViewController" bundle:nil];
        _discoveryViewController.isHaveMessage = [_total integerValue]>=1?NO:YES;
    }
    [self.messageBtn setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [self customPushViewController:_discoveryViewController customNum:0];
#endif

    

}

- (IBAction)helpCenterBtnClicked:(id)sender {
    
    SettingViewController *settingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    settingView.exitLogin = ^(BOOL isexit) {
        if (isexit) {
            [self exitUserBlock];//代理回controller执行 1.MDAssets 2.Follow
        }
    };
    [self customPushViewController:settingView customNum:0];
    

//左侧按钮暂留
}

- (IBAction)chargeBtnClicked:(id)sender {
    [self loadJudgeTradingPasswordAndCardData:RechargeState];//判断交易密码是否设置  充值
}

- (IBAction)withdrawBtnClicked:(id)sender {
    [self loadJudgeTradingPasswordAndCardData:WithdrawState];//判断交易密码是否设置  提现
}

#pragma mark - PaySelectedViewDelegate
- (void)cancelTappend{
    [self dismissPopupController];
}
- (void)sureTappend:(UIButton *)btn
{
    [self cancelTappend];
    
    NSString * payCodeStr = payNameArray[btn.tag][@"payCode"];
    if ([payCodeStr isEqualToString:@"lianlian"]
        || [payCodeStr isEqualToString:@"fuyou"]) {
        
        RechargeMyAssetsViewController *RechargeMyAssetsView = [[RechargeMyAssetsViewController alloc]  init];
        RechargeMyAssetsView.UserInformationDict = [_UserInformationDict copy];
        RechargeMyAssetsView.AvailableBalanceString =[NSString stringWithFormat:@"%@",[self isLegalObject:_accinfoDict[@"balance"]]?_accinfoDict[@"balance"]:@"0.00"];
        RechargeMyAssetsView.rechargeType = [payCodeStr isEqualToString:@"lianlian"]?LianlianPay:FuyouPay;
        RechargeMyAssetsView.chargeUrl = payNameArray[btn.tag][@"interfaceName"];
        [self customPushViewController:RechargeMyAssetsView customNum:0];
        
    }else if ([payCodeStr isEqualToString:@"rongzhifu"]) {
        
        CreditRechargeViewController * creditRechargeVC = [[CreditRechargeViewController alloc] initWithNibName:@"CreditRechargeViewController" bundle:nil];
        creditRechargeVC.UserInformationDict = [_UserInformationDict copy];
        creditRechargeVC.chargeUrlStr = payNameArray[btn.tag][@"interfaceName"];
        [self customPushViewController:creditRechargeVC customNum:0];
        
    }
}

#pragma mark - 充值/提现 判断设置交易密码以及绑卡方法
- (void)loadJudgeTradingPasswordAndCardData:(ButtonJumpType)type{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData:type];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData:type];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
                //是否设置交易密码
                if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDict[@"pay"] integerValue] == 1) {

                    //是否绑卡
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        _rechargeWithdrawAlert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@需要绑定银行卡，请绑定",type==RechargeState?@"充值":@"提现"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_rechargeWithdrawAlert show];
                        
                    } else {
                        switch (type) {
                            case RechargeState:
                            {
#if 0 //多支付渠道 富友宝付融支付
//获取支付渠道并跳转
//[self loadGetPayChannel];
#elif 0//测试
/*选择支付渠道下移*/
//[_viewController showPopupWithStyle:CNPPopupStyleCentered popupView:self.paySelectedView];
                                
#elif 1 /*宝付方案*/
                                //充值
                                RechargeMyAssetsViewController *RechargeMyAssetsView = [[RechargeMyAssetsViewController alloc] init];
                                RechargeMyAssetsView.UserInformationDict = [responseObject[@"item"] copy];
                                RechargeMyAssetsView.AvailableBalanceString = [NSString stringWithFormat:@"%@",[self isLegalObject:_accinfoDict[@"balance"]]?_accinfoDict[@"balance"]:@"0.00"];
                                [self customPushViewController:RechargeMyAssetsView customNum:0];
#endif
                            }
                                break;
                            case WithdrawState:
                            {
                                //如果state为3 是在提现审核中，可以去提现不成功不管我卵事
                                WithdrawViewController *withdrawView = [[WithdrawViewController alloc] init];
                                withdrawView.userinfoDict = [_UserInformationDict copy];
                                [self customPushViewController:withdrawView customNum:0];
                            }
                                break;
                            default:
                                break;
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
    if (alertView == _rechargeWithdrawAlert && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
    if (alertView == changeMoneyAlert && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];

    }
}

/**
 *  1.获取所有可使用充值渠道 bank/getPayChannel
 */
#pragma mark - 获取充值渠道接口
- (void)loadGetPayChannel
{
    NSDictionary *parameters = @{ //@"uid": getObjectFromUserDefaults(UID),
                                 @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/getPayChannel", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadGetPayChannel];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"获取所有可使用充值渠道 = %@",responseObject);
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    
                    //测试 充值渠道
                    //                        NSArray * array = @[@"fuyou",@"rongzhifu",@"lianlian"];
                    //                        NSInteger i = arc4random()%3;
                    //                        NSInteger j = arc4random()%3;
                    //                        NSArray * payCodeArray = @[array[i],
                    //                                                   array[j==i?arc4random()%3:j]];
                    
                    payNameArray = [responseObject[@"data"] copy];
                    if (payNameArray.count > 0) {
                        
                        //只有一个支付渠道时
                        if (payNameArray.count==1) {
                            
                            if ([payNameArray[0][@"payCode"] isEqualToString:@"rongzhifu"]) {
                                CreditRechargeViewController * creditRechargeVC = [[CreditRechargeViewController alloc] initWithNibName:@"CreditRechargeViewController" bundle:nil];
                                creditRechargeVC.UserInformationDict = [_UserInformationDict copy];
                                creditRechargeVC.chargeUrlStr = payNameArray[0][@"interfaceName"];
                                [self customPushViewController:creditRechargeVC customNum:0];
                            }
                            else{
                                //充值
                                RechargeMyAssetsViewController *RechargeMyAssetsView = [[RechargeMyAssetsViewController alloc] init];
                                RechargeMyAssetsView.UserInformationDict = [_UserInformationDict copy];
                                RechargeMyAssetsView.AvailableBalanceString =[NSString stringWithFormat:@"%@",[self isLegalObject:_accinfoDict[@"balance"]]?_accinfoDict[@"balance"]:@"0.00"];
                                RechargeMyAssetsView.rechargeType = [payNameArray[0][@"payCode"] isEqualToString:@"fuyou"]?FuyouPay:LianlianPay;
                                RechargeMyAssetsView.chargeUrl = payNameArray[0][@"interfaceName"];
                                [self customPushViewController:RechargeMyAssetsView customNum:0];
                            }
                        }else{ //多个支付渠道时
                            
                            [self.paySelectedView setSelectViewDataArray:payNameArray];
                            [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.paySelectedView];
                        }
                        
                    }else{ //没有数据 一般不会发生
                        RechargeMyAssetsViewController *RechargeMyAssetsView = [[RechargeMyAssetsViewController alloc] init];
                        RechargeMyAssetsView.UserInformationDict = [_UserInformationDict copy];
                        RechargeMyAssetsView.AvailableBalanceString =[NSString stringWithFormat:@"%@",[self isLegalObject:_accinfoDict[@"balance"]]?_accinfoDict[@"balance"]:@"0.00"];
                        RechargeMyAssetsView.rechargeType = LianlianPay;
                        [self customPushViewController:RechargeMyAssetsView customNum:0];
                    }
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

#pragma mark - 邀请送红包 按钮 请求判断
- (void)isBingBankForHoneBaoViewController
{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    [self showWithDataRequestStatus:@"获取中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/shareUrl", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
//            MyInviteHongBaoViewController * invite = [[MyInviteHongBaoViewController alloc] init];
//            [self customPushViewController:invite customNum:0];
            
            BYInviteEnvelopeViewController * invite = [[BYInviteEnvelopeViewController alloc] init];
            [self customPushViewController:invite customNum:0];
            
        } else if ([responseObject[@"r"] isEqualToString:@"-9"]) {
            [self dismissWithDataRequestStatus];
            _bankAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邀请好友理财需要实名认证,请实名认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
            [_bankAlertView show];
        }else if([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf isBingBankForHoneBaoViewController];
            } withFailureBlock:^{
                
            }];
        }else if([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf isBingBankForHoneBaoViewController];
            } withFailureBlock:^{
                
            }];
        }else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self showErrorViewinMain];
                              }];
}

#pragma mark - UIAlertViewDelegate
//邀请红包专用alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == _bankAlertView && buttonIndex != 0) {
        NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                      @"sid": getObjectFromUserDefaults(SID),
                                      @"state": @"1",
                                      @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
        [self showWithDataRequestStatus:@"获取信息中..."];
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
                BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
                BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
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
}

#pragma mark - PaySelectedView
-(PaySelectedView *)paySelectedView{
    if (!_paySelectedView) {
        _paySelectedView = [[PaySelectedView alloc] init];
        _paySelectedView.delegate = self;
    }
    return _paySelectedView;
}

- (void)loadCustomerServiceData {
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/queryServiceHotline?at=%@", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _customServiceDict = [responseObject[@"item"] copy];
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  
                              }];
}

/**  借款人测试账号 18151880008  111111
 *   查询借款记录权限
 *   user/getBorrowPower
 *   @param uid
 */
- (void)loadBorrowingDataForShowBorrowingCell
{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at" : getObjectFromUserDefaults(ACCESSTOKEN),};
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getBorrowPower", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            _isShowBorrowingCell = YES;
        } else if([responseObject[@"r"] isEqualToString:@"-1"]){//没有借款人权限
            _isShowBorrowingCell = NO;
//            if (![responseObject[@"msg"] isEqualToString:@"没有借款人权限"]) {
//                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
//            }
        }else{
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

@end
