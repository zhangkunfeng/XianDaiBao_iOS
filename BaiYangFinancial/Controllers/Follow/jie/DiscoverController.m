//
//  DiscoverController.m
//  BaiYangFinancial
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "DiscoverController.h"
#import "DiscoverHeadView.h"
#import "DiscoverTableViewCell.h"
#import "weidaiActivityTableViewCell.h"
#import "FriendViewController.h"
#import "FollowViewController.h"
#import "Masonry.h"
#import "ChooseEnveloperTypeViewController.h"
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CheckNewMessageViewController.h"
#import "NewDiscoveryViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "ChongZhiViewController.h"
#import "WeidaiActivityTableCell.h"
typedef NS_ENUM(NSInteger, ButtonJumpType) {
    RecentlyState = 0,//充值 已注
    WithdrawState,    //提现 已注
    ChangeMoneyState, //零钱包
    AutoBidState,     //自动投标
    yaoqing,
    hongbao,
    haoyou,
};

@interface DiscoverController ()<UITableViewDelegate, UITableViewDataSource, DiscoverHeadViewDelegate>{
long style;
}
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic,strong)DiscoverHeadView *headView;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, copy) NSDictionary * UserInformationDict;

@property (nonatomic, strong) UIAlertView * envelopeAlert;
@property (nonatomic, strong) UIAlertView * envelopeAlert1;
@property (nonatomic, assign) NSInteger pageIndexNum; //请求数据页数
@property (nonatomic, strong) NSMutableArray *discoveryMutabArray;
@property (nonatomic, copy)   NSString * notifyStr;
@property (nonatomic, strong) NewDiscoveryViewController *discoveryViewController;
@property (nonatomic, strong)NSString *styler;
@end

@implementation DiscoverController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   //[self isUserLogin];
    [self getMyDiscoveryListData];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _discoveryMutabArray = [[NSMutableArray alloc]initWithCapacity:0];
    _styler = @"0";
    _pageIndexNum = 1;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewRefreshDiscoveryViewData:) name:RefreshDiscoveryView object:nil];
    [self configUI];
    [self setupHeader];
    [self setupFooter];


}


- (void)NewRefreshDiscoveryViewData:(NSNotification*)notify
{[_weakRefreshHeader beginRefreshing];

    _notifyStr = [notify object];
    //[self isUserLogin];
}


- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self getMyDiscoveryListData];
        });
    };
}
- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresht)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresht {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getMyDiscoveryListData];
        [self.refreshFooter endRefreshing];
    });
}


- (void)configUI {
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhoneWidth, 64)];
    nav.backgroundColor = [UIColor colorWithHex:@"05CBF3"];
    
    [self.view addSubview:nav];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"发现";
    titleLab.textColor = [UIColor whiteColor];
    [nav addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nav);
        make.centerY.equalTo(nav).offset(10);
    }];
    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    [nav addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_offset(-15);
        make.centerY.equalTo(nav).offset(10);
    }];
    [message addTarget:self action:@selector(message1:) forControlEvents:(UIControlEventTouchUpInside)];
    [message setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    self.headView = [[NSBundle mainBundle] loadNibNamed:@"DiscoverHeadView" owner:nil options:nil].firstObject;
    self.headView.delegate = self;
    [self.view addSubview: self.headView];
    self.view.backgroundColor = [UIColor colorWithHex:@"f7f7f7"];
    self.headView.frame = CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64);
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iPhoneWidth, self.headView.bounds.size.height - 126) style:UITableViewStylePlain];
    _tableView.backgroundColor =[UIColor colorWithHex:@"EFEFEF"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.headView.scrollView addSubview:_tableView];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"WeidaiActivityTableCell" bundle:nil] forCellReuseIdentifier:@"activitycell"];
    _tableView.tableFooterView = [UIView new];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
}

- (void)message1:(UIButton *)sender{
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
    //[sender setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [self customPushViewController:_discoveryViewController customNum:0];
#endif

}

- (void)meFriend {
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) {//无为真
        VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verfication.pushviewNumber = 666;
        [self customPushViewController:verfication customNum:0];
        
    }else {
//        ChongZhiViewController *vc = [[ChongZhiViewController alloc]initWithNibName:@"ChongZhiViewController" bundle:nil];
//        [self customPushViewController:vc customNum:0];
        [self loadJudgeTradingPasswordAndCardData:haoyou];
    }
}

-(void)redBo{
    
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) {//无为真
        VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verfication.pushviewNumber = 666;
        [self customPushViewController:verfication customNum:0];
        
    }else{
        [self loadJudgeTradingPasswordAndCardData:hongbao];
    }
    
    
    
}
#pragma mark - 判断设置交易密码
- (void)loadJudgeTradingPasswordAndCardData:(ButtonJumpType)JumpType{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData:JumpType];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData:JumpType];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
                
                if (JumpType == hongbao) {
                    //是否设置交易密码
                    if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDict[@"pay"] integerValue] == 1) {
                        
                        //是否绑卡
                        if ([_UserInformationDict[@"status"] integerValue] == 2) {
                            _envelopeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"好友红包需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                            [_envelopeAlert show];
                        } else {
                            ChooseEnveloperTypeViewController * chooseEnveloperTypeVC = [[ChooseEnveloperTypeViewController alloc] init];
                            [self customPushViewController:chooseEnveloperTypeVC customNum:0];
                        }
                        
                    }else{
                        [self setPaymentPassWordController];
                    }
                }else if (JumpType == haoyou){
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        _envelopeAlert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"好友功能需要实名认证，请认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
                        [_envelopeAlert1 show];
                    } else {
                        FollowViewController *vc = [[FollowViewController alloc] initWithNibName:@"FollowViewController" bundle:nil];
                        //    FriendViewController *vc = [FriendViewController new];
                        [self customPushViewController:vc customNum:0];

                    }
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView == _envelopeAlert || alertView == _envelopeAlert1) && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}


- (void)getMyDiscoveryListData {
        NSDictionary *parameters = @{ @"page": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                                      @"rows": @"10",
                                      @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"status":@"0"
                                      };
    WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/xrtzDynamicList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (responseObject) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf getMyDiscoveryListData];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self hideMDErrorShowView:self];
                    [_tableView reloadData];
                    if (_pageIndexNum == 1 && [_discoveryMutabArray count] > 0) {
                        [_discoveryMutabArray removeAllObjects];
                    }
                    [_weakRefreshHeader endRefreshing];
                    NSArray *array = responseObject[@"data"];
                    if (_pageIndexNum > 1) {
                        if ([array count] == 0) {
                            [weakSelf errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",@"动态"]];
                        }
                    }
                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                        for (id info in array) {
                            [_discoveryMutabArray addObject:info];
                        }
                    }
                    if ([_discoveryMutabArray count] > 0) {
                        //                        [weakSelf hideMDErrorShowView:self];
                        [_tableView reloadData];
                    } else {
                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, _headView.friendView.frame.size.height + 64, iPhoneWidth, iPhoneHeight - _headView.friendView.frame.size.height - 64) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                    }
                } else {
                    [_weakRefreshHeader endRefreshing];
                    [weakSelf showMDErrorShowViewForError:weakSelf MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
                }
            }
        }
                                  fail:^{
                                      [_weakRefreshHeader endRefreshing];
                                      if ([_discoveryMutabArray count] > 0) {
                                          [weakSelf showErrorViewinMain];
                                      } else {
                                          [weakSelf initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64)];
                                      }
                                  }];
    }



- (void)reload {
    NSLog(@"刷新数据");
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_discoveryMutabArray count] > 0) {
        return [_discoveryMutabArray count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSDictionary *weidaiDict = nil;
    if ([_discoveryMutabArray count] > 0) {
        weidaiDict = [_discoveryMutabArray objectAtIndex:indexPath.row];
    }
    
//    weidaiActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[weidaiActivityTableViewCell weidaiActivityTableViewCell_id]];
//    
//    if (cell == nil) {
//        cell = [weidaiActivityTableViewCell initWithweidaiActivityTableViewCell];
//        
//    } else {
//        //删除cell的所有子视图
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    WeidaiActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activitycell"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([weidaiDict[@"status"] integerValue] == 2) {
//        cell.forGoLab.text = @"已结束";
        cell.timeLable.hidden = YES;
        cell.titleImg.image = [UIImage imageNamed:@"ended"];
    }else if ([weidaiDict[@"status"] integerValue] == 1){
        cell.timeLable.hidden = NO;
//        cell.forGoLab.text = @"进行中";
        cell.titleImg.image = [UIImage imageNamed:@"ongoing"];
    }
    
    cell.titleLable.text = [self isLegalObject:weidaiDict[@"title"]] ? weidaiDict[@"title"] : @"";
    NSString *str = [weidaiDict[@"createTime"] substringToIndex:10];
    NSString *startTimeStr = [str stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *str1 = [weidaiDict[@"endTime"] substringToIndex:11];
    NSString *endTimeStr = [str1 stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    cell.timeLable.text = [self isLegalObject:[NSString stringWithFormat:@"%@.%@",startTimeStr,endTimeStr]] ? [NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr] : @"";
   
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.timeLable.bounds byRoundingCorners:UIRectCornerTopLeft
                              | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cell.timeLable.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.timeLable.layer.mask = maskLayer;

    
    if ([self isLegalObject:weidaiDict[@"path"]]) {
        [cell.ContentimageView setImageWithURL:[NSURL URLWithString:weidaiDict[@"path"]] placeholderImage:[UIImage imageNamed:@"weidaiactivity_ default"]];
//        cell.NewsLabel.text = @"热力新闻";
    }
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [weidaiActivityTableViewCell weidaiActivityTableViewCellHeight];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_discoveryMutabArray count] > 0) {
        NSDictionary *weidaiDict = [_discoveryMutabArray objectAtIndex:indexPath.row];
        if (![self isBlankString:weidaiDict[@"urlLink"]] && ![self isBlankString:weidaiDict[@"title"]]) {
            [self jumpToWebview:weidaiDict[@"urlLink"] webViewTitle:weidaiDict[@"title"]];
        }
    }
}
@end
