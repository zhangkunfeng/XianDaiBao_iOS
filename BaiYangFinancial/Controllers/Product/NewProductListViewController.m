//
//  NewProductListViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "Masonry.h"
#import "SDRefresh.h"
#import "SDImageCache.h"
#import "startAdImagModel.h"
#import "AutoBidViewController.h"
#import "TransferViewController.h"
#import "NewProductTableViewCell.h"
#import "OtherFinancialHeaderView.h"
#import "ShortFinancialHeaderView.h"
#import "NewProductListViewController.h"
#import "ProductdetailsViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "SwitchHeaderView.h"
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"

@interface NewProductListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    int  index;
    BOOL IsOpen;
    NSDictionary *_accinfoDict;
    UISwitch *_switchBtn;
    NSInteger setSwitchOpen;
    UIAlertView * alertTel;
//    UIAlertView *exitAlert;
    UIAlertView *certificationAlert;//实名认证
    NSArray * _titleArray;
    CGFloat _scrollHeight;//调节scrollV高度
    
    NSTimer * _timer;
    UIAlertView * changeMoneyAlert; //零钱包
    UIAlertView * autoBidAlert;//自动投标

    NSString *MonthMin;
    NSString *MonthMax;
    NSString *AmountMin;
}

@property (nonatomic, strong) UITableView *tableViewList; //理财产品列表
@property (nonatomic, strong) NSMutableArray *productMutableArray; //存放数据的数组
@property (nonatomic, strong) NSDictionary *NewExclusiveData;//新手专享数据
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, assign) NSInteger pageIndexNum; //请求数据页数
@property (nonatomic, assign) NSInteger assignmentBidNumber; //转让标的的数量
@property (nonatomic, assign) float bcrRecoverPeriod;//剩余期数
@property (nonatomic, strong) OtherFinancialHeaderView *otherFinancialHV;//
@property (nonatomic, strong) ShortFinancialHeaderView *shortFinancialHV;//
@property (nonatomic, copy) NSString * emptyFooterStr;
@property (nonatomic, strong) SwitchHeaderView *headerView;
@property (nonatomic, assign) BOOL isHavePayPassworld; //是否有交易密码
@property (nonatomic, copy) NSDictionary *accinfoDict;          //资产数据
@property (nonatomic, copy) NSDictionary *UserInformationDict;  //用户信息字典
@property (nonatomic, assign)NSString *isOpenswith;

@end

@implementation NewProductListViewController

#pragma mark - Life Cycle
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self hideMDErrorShowView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setToubiaoSwith];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self loadSettingData];
    //初始化productMutableArray
    MonthMin = @"0";
    MonthMax = @"0";
    AmountMin = @"0";
    _productMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    _NewExclusiveData = [NSDictionary dictionary];
    
    //初始化请求数据页数
    _pageIndexNum = 1;

    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    
    _tableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64) style:UITableViewStyleGrouped];
    //    _tableViewList.backgroundColor = [UIColor orangeColor];
    _tableViewList.backgroundColor = [UIColor clearColor];
    _tableViewList.delegate = self;
    _tableViewList.dataSource = self;
    _tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewList.tableFooterView = [UIView new];
    [self.view addSubview:_tableViewList];
    NSLog(@"%@",self.view);
    
    if (self.type == ProductStyle_shortBid) {
        [self addTableViewHeaderView];/*新手专享数据添加到cell数据请求完成之后请求并添加*/
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshNewProductListData:) name:RefreshProductList object:nil];
    
    [self setupHeader];
    [self setupFooter];
   
//    if (_productMutableArray.count == 0) {
//        [_weakRefreshHeader beginRefreshing];
//    }
    
    [self viewDidCurrentProductView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelSingleTap:)];
    [_headerView.tapView addGestureRecognizer:singleTap];
}

- (void)handelSingleTap:(UIGestureRecognizer *)gesture {
    
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) { //为空
        VerificationiPhoneNumberViewController *VerificationiPhoneNumberView = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        VerificationiPhoneNumberView.pushviewNumber = 666;
        [self customPushViewController:VerificationiPhoneNumberView customNum:0];
    }
    
//    else if (_isHavePayPassworld == YES){
//        [self getMyBankCardinformation:YES];
//    }
    
    else{
        
        [self dismissWithDataRequestStatus];
//      [self setPaymentPassWordController];
        [self getMyBankCardinformation:YES];
    }
}

- (void)addTableViewHeaderView
{
//    if (self.type == ProductStyle_shortBid) {
        if (!_headerView) {
            _headerView = [[[NSBundle mainBundle] loadNibNamed:@"SwitchHeaderView" owner:self options:nil] objectAtIndex:0];
        }
        self.tableViewList.tableHeaderView = _headerView;
        [self setToubiaoSwith];
        [_headerView.touBiaoSwitch addTarget:self action:@selector(opender:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setToubiaoSwith{
 
    _isOpenswith = getObjectFromUserDefaults(SWITCHOPEN);
    if ([_isOpenswith isEqualToString:@"1"]) {
        [_headerView.touBiaoSwitch setOn:YES];
        _headerView.toubiaoLab.text = @"已开启";
    }else{
        [_headerView.touBiaoSwitch setOn:NO];
        _headerView.toubiaoLab.text = @"未开启";
    }
}

-(void)opender:(UISwitch *)sender{
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) { //为空
        sender.on = NO;
        
        VerificationiPhoneNumberViewController *VerificationiPhoneNumberView = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        VerificationiPhoneNumberView.pushviewNumber = 666;
        [self customPushViewController:VerificationiPhoneNumberView customNum:0];
    }else if (_isHavePayPassworld){
        _isOpenswith = [NSString stringWithFormat:@"%d", sender.on];
        [self getMyBankCardinformation:NO];
    }else{
        [self dismissWithDataRequestStatus];
        [self setPaymentPassWordController];
    }
}
- (void)getMyBankCardinformation:(BOOL)jump{
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
                [weakSelf getMyBankCardinformation:YES];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf getMyBankCardinformation:YES];
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
                    if (jump) {
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
                    }else{
                        [self setAutoBidisOpen];
                    }
                }
            }
            
            /*branchState 为0的话  可以修改支行信息  为1 不可修改支行信息
             *state 为1锁住银行信息  为2已审核可以更改   为3 提现审核中不可修改
             *status 1有卡 2无卡  3替换
             *realStatus 0 身份信息通过  1不通过  2审核中
             */
            
            [self setToubiaoSwith];
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            [self setToubiaoSwith];
        }
    }fail:^{
      [self showErrorViewinMain];
      [self setToubiaoSwith];
    }];
}
#pragma mark - UIAlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0 && alertView == autoBidAlert) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_accinfoDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
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
                    [self setToubiaoSwith];
                } withFailureBlock:^{
                    [self setToubiaoSwith];
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf setAutoBidisOpen];
                    [self setToubiaoSwith];
                } withFailureBlock:^{
                    [self setToubiaoSwith];
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = [responseObject[@"item"] copy];
                    saveObjectToUserDefaults([NSString stringWithFormat:@"%@",dic[@"enabled"]], SWITCHOPEN);
                    [self showWithSuccessWithStatus:@"设置成功"];
                    [self setToubiaoSwith];
                }else{
                    
                }
            } else {
//                [self initWithsetAutoError];
                [self setToubiaoSwith];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }fail:^{
    //                                  [self initWithsetAutoError];
        [self setToubiaoSwith];
    }];
}

- (void)initWithsetAutoError {
    if ([_isOpenswith isEqualToString:@"1"]) {
        _isOpenswith = @"0";
        [self.headerView.touBiaoSwitch setOn:NO];
        _headerView.toubiaoLab.text = @"未开启";
        [self.view layoutIfNeeded];
    } else {
        _isOpenswith = @"1";
        [self.headerView.touBiaoSwitch setOn:YES];
        _headerView.toubiaoLab.text = @"已开启";
        [self.view layoutIfNeeded];
    }
}
- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            _isHavePayPassworld = YES;
        }
        [self getMyBankCardinformation:YES];
    };
    [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [self customPushViewController:setPaymentPassWorldView customNum:1];
}
- (void)viewDidCurrentProductView {
    if ([_productMutableArray count] == 0) {
        [_weakRefreshHeader beginRefreshing];
    } else {
        [_tableViewList setContentOffset:CGPointMake(0, 0) animated:NO];
        if (self.type == ProductStyle_shortBid) {
            [self performSelector:@selector(getProductListData) withObject:self afterDelay:1.0f];
        }
    }
}

//通知方法
- (void)RefreshNewProductListData:(NSNotification*)notify
{
    [self setToubiaoSwith];
    [self getProductListData];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if ([_weakRefreshHeader isManuallyRefreshing]) {
        
    }else
        [_weakRefreshHeader beginRefreshing];
//    [self getDescImageViewData];
    [self setToubiaoSwith];
    [self getProductListData];
}

#pragma mark - HTTP
//加载数据(正在热销的标)
- (void)getProductListData {
    
    NSString *requestStr = @"";
    NSDictionary *parameters = nil;
    if (self.type == ProductStyle_shortBid) {
//        [self loadNewExclusiveData];//加载新手专享数据
        requestStr = @"phone/underwayBidListMore";
        parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                        @"pageIndex":[NSString stringWithFormat:@"%ld",(long)_pageIndexNum],
                        @"month": @"2",
                        @"bidType": @"0",
                        @"pageSize": @"10"};
    }else if(self.type == ProductStyle_longBid){
        requestStr = @"phone/transferBidList";
        parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                        @"pageIndex": [NSString stringWithFormat:@"%ld",(long)_pageIndexNum],
                        @"month": @"3",
                        @"bidType": @"0",
                        @"pageSize": @"10"};
    } /*else {
        requestStr = @"phone/transferBidList";
        parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                        @"pageIndex": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                        @"pageSize": @"10"};
    }*/
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, requestStr] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                 [self hideMDErrorShowView:self];
                if (_pageIndexNum == 1) { //先清空数组
                    if ([_productMutableArray count] > 0) {
                        [_productMutableArray removeAllObjects];
                        _emptyFooterStr = @"";
                    }
                    [_weakRefreshHeader endRefreshing];
                } else {
                    [self.refreshFooter endRefreshing];
                }
//                [self addTableViewHeaderView];
                //给列表数组赋值
                NSArray *array = responseObject[@"data"];
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (id info in array) {
                        [_productMutableArray addObject:info];
                    }
                }
                
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                    _emptyFooterStr = [NSString stringWithFormat:@"没有更多%@",self.type == ProductStyle_shortBid ? @"定期标的":@"债转标的"];
                    //  [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",_emptyFooterStr]];//频繁刷新体验不好
                    }
                }
                
                if ([_productMutableArray count] > 0) {
                    if (self.type == ProductStyle_transformBid) {
                        _assignmentBidNumber = [responseObject[@"total"] integerValue];
                        [_tableViewList reloadData];
                    } else {
                        [_tableViewList reloadData];
                    }
                } else {
//                    self.tableViewList.scrollEnabled = NO;
                    [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, _headerView.frame.size.height + 10, iPhoneWidth, iPhoneHeight-64-49) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                    
                }
            } else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getProductListData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:@"0"]) {
                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64-49) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            } else if ([responseObject[@"r"] isEqualToString:@"-1"]) {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            } else {
                [_weakRefreshHeader endRefreshing];
                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64-49) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }fail:^{
          [_weakRefreshHeader endRefreshing];
          if ([_productMutableArray count] > 0) {
              [[AFNetworkReachabilityManager sharedManager] startMonitoring];
              [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                  if (status == AFNetworkReachabilityStatusNotReachable) {
                      [self errorPrompt:3.0 promptStr:@"亲，没有网络哦！"];
                  } else {
                      [self errorPrompt:3.0 promptStr:errorPromptString];
                  }
              }];
          } else {
              [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64-49) contentShowString:errorPromptString MDErrorShowViewType:NoData];
          }
    }];
}

- (void)getDescImageViewData
{
    NSString * typeString = nil;
    NSString * descImageUrlKey = nil;
    NSString * descImagePathKey = nil;
    NSString * descImageTitleKey = nil;
    
    if (self.type == ProductStyle_shortBid) {
        typeString = @"7";
        descImageUrlKey = @"short-descImage.url";//链接
        descImagePathKey = @"short-descImage.path";//图片
        descImageTitleKey = @"short-descImage.title";//标题
    }else if(self.type == ProductStyle_longBid){
        typeString = @"8";
        descImageUrlKey = @"long-descImage.url";
        descImagePathKey = @"long-descImage.path";
        descImageTitleKey = @"long-descImage.title";
    } else {
        typeString = @"9";
        descImageUrlKey = @"transform-descImage.url";
        descImagePathKey = @"transform-descImage.path";
        descImageTitleKey = @"transform-descImage.title";
    }
    
    if (getObjectFromUserDefaults(ACCESSTOKEN)) {
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"type": typeString };
        
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/queryList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"------------------------\n responseObject = %@",responseObject);
                id data = responseObject[@"data"];
                if ([data isKindOfClass:[NSArray class]]) {
                    NSArray *dataArray = (NSArray *) data;
                    if (dataArray.count > 0) {
                        startAdImagModel *adImageModel = [[startAdImagModel alloc] initWithDictionary:[responseObject[@"data"] objectAtIndex:0]];/*Only one*/
                        if (![adImageModel.image isEqualToString:[UserDefaults objectForKey:descImagePathKey]] || ![self isAdImageDownloadComplete:descImagePathKey]) {
                                [[SDImageCache sharedImageCache] removeImageForKey:[UserDefaults objectForKey:descImagePathKey]];
                                if ([UserDefaults objectForKey:descImagePathKey]) {
                                    [UserDefaults removeObjectForKey:descImagePathKey];
                                }
                                UIImage *adImage;
                                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:adImageModel.image]];
                                adImage = [UIImage imageWithData:data];
                                [[SDImageCache sharedImageCache] storeImage:adImage forKey:adImageModel.image];
                                [UserDefaults setObject:adImageModel.title forKey:descImageTitleKey];
                                [UserDefaults setObject:adImageModel.image forKey:descImagePathKey];
                                [UserDefaults setObject:adImageModel.url forKey:descImageUrlKey];
                                [UserDefaults synchronize];
                            }
                        }
                    }
            }
        }fail:^{
                                      
        }];
    }
}

// 判断图片是否下载完成
- (BOOL)isAdImageDownloadComplete:(NSString *)descImagePathKey {
    UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[UserDefaults objectForKey:descImagePathKey]];
    return myCachedImage ? YES : NO;
}

- (void)loadNewExclusiveData
{
    WS(weakSelf);
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID) };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getOneRecommendedBidDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [weakSelf loadNewExclusiveData];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                _NewExclusiveData = [responseObject[@"item"] copy];
                if (_NewExclusiveData) {
                    [_shortFinancialHV setData:_NewExclusiveData];
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }fail:^{
        [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
      }];
}

- (void)gotoSetAutobid:(id)sender {
    //判断是否登录
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) {
        VerificationiPhoneNumberViewController *verificationiPhoneNumber = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verificationiPhoneNumber.pushviewNumber = 10010; //用于记录是设置自动投标进去的
        [self customPushViewController:verificationiPhoneNumber customNum:0];
    } else {
        //查看自动投标详情
        AutoBidViewController *AutobidView = [[AutoBidViewController alloc] initWithNibName:@"AutoBidViewController" bundle:nil];
        AutobidView.backAssetsView = ^(NSDictionary *autoSettingDict) {
            
        };
        [self customPushViewController:AutobidView customNum:0];
    }
}

#pragma mark - MDErrorShowViewDelegate
- (void)againLoadingData{
    [self getProductListData];
    if (_productMutableArray.count > 0) {
        [self hideMDErrorShowView:self];
    }
}

#pragma mark -上下拉加载
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
//    refreshHeader.isEffectedByNavigationController = NO;

    [refreshHeader addToScrollView:_tableViewList];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
//            [self getDescImageViewData];
            [self getProductListData];
        });
    };
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_tableViewList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getProductListData];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productMutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewProductTableViewCell NewProductTableViewCellHeight];
}
//防止上面留白
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CGFloat footerHeight = [self isBlankString:_emptyFooterStr]?0:30;
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, footerHeight)];
    UILabel * footerLabel = [[UILabel alloc] initWithFrame:footerView.frame];
    footerLabel.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    footerLabel.textColor = [UIColor lightGrayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:15.0f];
    footerLabel.text = _emptyFooterStr;
    [footerView addSubview:footerLabel];
//    if (section == _productMutableArray.count-1) {
        return footerView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == _productMutableArray.count-1) {
        return [self isBlankString:_emptyFooterStr]?0:30;
//    }
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NewProductTableViewCell NewProductTableViewID]];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [NewProductTableViewCell NewproductTableViewCell];
    }else {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    [cell setSmalliPhoneConstant];//适配iPhone4|iPhone5
    cell.bidTitleLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.progressView.progress =  0.0f;
    cell.PercentageDesc.text = @"0%";
    
    /*区分*/
    NSDictionary *Dict = nil;
    if ([_productMutableArray count] > 0) {
        Dict = [_productMutableArray objectAtIndex:indexPath.row];
    }

    if (self.type == ProductStyle_shortBid  || self.type == ProductStyle_longBid) {
        //iPhone4 | iPhone5 长标适配
        if (self.type == ProductStyle_longBid && (iPhone4||iPhone5)) {
            cell.borrowDeadlineLable.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
            cell.tenderMinAmountLable.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
            cell.borrowAmountLable.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
            cell.TermInvestmentDesc.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
        }
        
        if (self.type == ProductStyle_longBid) {
            cell.tenderMinAmountLable.hidden = YES;
            cell.undertakeLab.font = [UIFont fontWithName:@".PingFangSC-Regular" size:(iPhone4||iPhone5)?12:15];
            cell.borrowDeadlineLable.font = [UIFont fontWithName:@".PingFangSC-Regular" size:(iPhone4||iPhone5)?12:15];
            cell.chengJieLab.hidden = NO;
            cell.cjDateLab.hidden = NO;
            cell.hengLab.hidden = NO;
            cell.timeImg.hidden = NO;
            cell.TermInvestmentDesc.text = @"";
            if (iPhone4||iPhone5) {
                cell.undertakeLabTrailing.constant = 12;
            }
            if ([Dict[@"bcrStatus"] isEqualToString:@"已转让"]) {
                cell.cjDateLab.hidden = YES;
                //cell.hengLab.hidden = YES;
                cell.timeImg.hidden = YES;
                NSLog(@"%@",Dict[@"bcrStatus"]);
                cell.chengJieLab.text = @"已承接";
                cell.chengJieLab.backgroundColor = [UIColor colorWithHex:@"C9C9C9"];
                 //cell.buyLab.text = @"已转让";
                cell.AnnualyieldDesc.textColor = [UIColor colorWithHex:@"666666"];
                cell.undertakeLab.textColor = [UIColor colorWithHex:@"666666"];
                cell.addBidRateLable.textColor = [UIColor colorWithHex:@"666666"];
                cell.addBidRateLable.layer.borderColor = [UIColor colorWithHex:@"666666"].CGColor;
                cell.addBidRateLable.hidden = YES;
                cell.InvestmentStartDesc.textColor = [UIColor colorWithHex:@"666666"];
                cell.baiFenLab.textColor = [UIColor colorWithHex:@"666666"];
                cell.bidTitleLable.textColor = [UIColor colorWithHex:@"666666"];
                cell.bidRateLable.textColor = [UIColor colorWithHex:@"666666"];
                cell.borrowDeadlineLable.textColor = [UIColor colorWithHex:@"666666"];
                cell.tenderMinAmountLable.textColor = [UIColor colorWithHex:@"666666"];
                cell.undertakeLab.textColor = [UIColor colorWithHex:@"666666"];
                cell.buyLab.backgroundColor = [UIColor lightGrayColor];
               
            }else{
            //cell.buyLab.text = @"立即承接";
            
                cell.borrowDeadlineLable.textColor = [UIColor colorWithHex:@"999999"];
                //cell.hengLab.hidden = NO;
                cell.undertakeLab.textColor = [UIColor colorWithHex:@"222222"];
                cell.chengJieLab.text = @"承接";
            }
            cell.InvestmentStartDesc.hidden = YES;
           // cell.tenderMinAmountLable.text = Dict[@"bcrTransferPrice"];
        }
        
        if ([Dict[@"isRookieNum"] intValue] != 1) {
            cell.typeImg.hidden = YES;
        }
        cell.bidTitleLable.text = [self isLegalObject:Dict[@"title"]] ? Dict[@"title"] : @"";
        cell.bidTitleLable.tag = [Dict[@"id"] integerValue];
        //百分比 || 进度条 || 标的状态
        float BidProgress = 0.0;
        if ([self isLegalObject:Dict[@"borrowedCompletionRate"]]) {
            BidProgress = [Dict[@"borrowedCompletionRate"] floatValue];
            if (BidProgress > 0) {
                //进度条
                cell.progressView.progress = BidProgress / 100;
                  //进度 80%  没设置为0  上边初始化
                NSString *borrowedCompletionRateprogressNumber = [NSString stringWithFormat:@"%.2f", [Dict[@"borrowedCompletionRate"] doubleValue]];
                cell.PercentageDesc.text =  [NSString stringWithFormat:@"已售%@%@",borrowedCompletionRateprogressNumber,@"%"];
                NSLog(@"%@",Dict[@"statusShow"]);

                    //标的状态
                    if (BidProgress < 100) {
//                        cell.lineLabel.hidden = NO;
                        cell.BidStateImageView.hidden = YES;
                        [cell.buyBtn setTitle:[NSString stringWithFormat:@"立即购买"] forState:UIControlStateNormal];
                       
                        [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
                        cell.buyLab.text = @"立即购买";
                        
                    } else {
                        cell.AnnualyieldDesc.textColor = [UIColor colorWithHex:@"666666"];
                        cell.TermInvestmentDesc.textColor = [UIColor colorWithHex:@"666666"];
                        cell.addBidRateLable.textColor = [UIColor colorWithHex:@"666666"];
                        cell.addBidRateLable.layer.borderColor = [UIColor colorWithHex:@"666666"].CGColor;
                        cell.InvestmentStartDesc.textColor = [UIColor colorWithHex:@"666666"];
                        cell.baiFenLab.textColor = [UIColor colorWithHex:@"666666"];
                        cell.bidTitleLable.textColor = [UIColor colorWithHex:@"666666"];
                        cell.bidRateLable.textColor = [UIColor colorWithHex:@"666666"];
                        cell.borrowDeadlineLable.textColor = [UIColor colorWithHex:@"666666"];
                        cell.tenderMinAmountLable.textColor = [UIColor colorWithHex:@"666666"];
                        
                        
//                        cell.lineLabel.hidden = YES;
                        cell.BidStateImageView.hidden = NO;
                        [cell.BidStateImageView setImage:[UIImage imageNamed:@"已售罄.png"]];
                        [cell.buyBtn setTitle:[NSString stringWithFormat:@"已售罄"] forState:UIControlStateNormal];
                        
                        if ([Dict[@"statusShow"] isEqualToString:@"待复审"]) {
                            //添加已满标图标 
                            cell.zhaungtaiImg.image = [UIImage imageNamed:@"manbiao"];
                            cell.tenderMinAmountLable.hidden = YES;
                            cell.InvestmentStartDesc.hidden = YES;
                            
                        }else if ([Dict[@"statusShow"] isEqualToString:@"还款中"]){
                            cell.zhaungtaiImg.image = [UIImage imageNamed:@"payment"];
                            cell.tenderMinAmountLable.hidden = YES;
                            cell.InvestmentStartDesc.hidden = YES;
                        }else if ([Dict[@"statusShow"] isEqualToString:@"已结案"]){
                            
                            cell.zhaungtaiImg.image = [UIImage imageNamed:@"ending"];
                            cell.tenderMinAmountLable.hidden = YES;
                            cell.InvestmentStartDesc.hidden = YES;
                            
                            
                        }else if ([Dict[@"statusShow"] isEqualToString:@""]){
                        
                        
                        }
                       

                    }
                }
            }
//        }
        //标的利率
        if (![Dict[@"borrowAnnualYield"] isKindOfClass:[NSNull class]]) {
            NSString * bidRateString = [NSString stringWithFormat:@"%.1f ", [Dict[@"borrowAnnualYield"] doubleValue]];
            
            [self AttributedString:bidRateString andTextColor:[UIColor colorWithHexString:@"ED702A"] andTextFontSize:15.0f AndRange:bidRateString.length-1 withlength:1 AndLabel:cell.bidRateLable];
        }
        //加送利率
        if ([self isLegalObject:Dict[@"awardAmonut"]]) {

            if ([Dict[@"awardAmonut"] doubleValue] > 0) {
                cell.addBidRateLable.hidden = NO;
                cell.addBidRateLable.text = [NSString stringWithFormat:@"加息%.1f%@", [Dict[@"awardAmonut"] doubleValue] * 100,@"%"];
            } else {
                cell.addBidRateLable.text = @"";
                cell.addBidRateLable.hidden = YES;
            }
        } else {
            cell.addBidRateLable.text = @"";
        }
        
        if (!(cell.addBidRateLable.text.length > 0) && (iPhone4||iPhone5)) {
            cell.lineLeading.constant = 18;
        }
        
        if (cell.addBidRateLable.text.length > 0 && (iPhone4||iPhone5) && self.type == ProductStyle_longBid) {
            cell.investTimeDescLading.constant = 12;
        }
        
        //标的总额
        if ([self isLegalObject:Dict[@"borrowAmount"]]) {
            float acount = [Dict[@"borrowAmount"] floatValue]/10000;
            NSString * borrowAmoutString = acount<1?
            [NSString stringWithFormat:@"%.2f元",[Dict[@"borrowAmount"] floatValue]]
            :[NSString stringWithFormat:@"%.2f万",acount];
            [self AttributedString:borrowAmoutString andTextColor:[UIColor darkGrayColor] andTextFontSize:13.0f AndRange:borrowAmoutString.length-1 withlength:1 AndLabel:cell.borrowAmountLable];
        }
        
        if (ProductStyle_longBid) {
            if ([self isLegalObject:Dict[@"bcrTransferPrice"]]) {
               NSString *  tenderMinAmoutString = [NSString stringWithFormat:@"%.2f", [Dict[@"bcrTransferPrice"] doubleValue]];
                cell.undertakeLab.text = [NSString stringWithFormat:@"承接(元):%@",tenderMinAmoutString];
            }
            
            if ([self isLegalObject:Dict[@"restAmount"]]) {
                 NSString *  tenderMinAmoutString  = [NSString stringWithFormat:@"%.2f", [Dict[@"restAmount"] doubleValue]];
                 cell.borrowDeadlineLable.text = [NSString stringWithFormat:@"债权(元):%@",tenderMinAmoutString];
            }
            
            if ([self isLegalObject:Dict[@"isRookieNum"]]) {//新手
                if ([Dict[@"isRookieNum"] integerValue] == 1) {
                    //默认
                }
            }
        }
        if ([self isLegalObject:Dict[@"tenderMinAmount"]]) {
            
            NSString * tenderMinAmoutString1 = [self forMoenyString:[NSString stringWithFormat:@"%.2f", [Dict[@"borrowAmount"] doubleValue] - [Dict[@"borrowedAmount"] doubleValue]]];
            
            if ([tenderMinAmoutString1 rangeOfString:@"万"].location != NSNotFound ) {
                [self AttributedString:tenderMinAmoutString1 andTextColor:[UIColor colorWithHex:@"222222"] andTextFontSize:14.0f AndRange:tenderMinAmoutString1.length-1 withlength:1 AndLabel:cell.tenderMinAmountLable];
            }else{
                cell.tenderMinAmountLable.text = [Number3for1 formatAmount: tenderMinAmoutString1];
            }
            
            
        }
            if ([self isLegalObject:Dict[@"isRookieNum"]]) {//新手
            if ([Dict[@"isRookieNum"] integerValue] == 1) {
                //默认
            }
        }
        
        // 即使是月标 有的走天数   borrowDeadlineLable
        NSString * borrowDeadlineLableString;
        if ([self isLegalObject:Dict[@"monthDay"]]) {
            if ([Dict[@"monthDay"] integerValue] > 31) {
                
                cell.borrowDeadlineLable.text  = [NSString stringWithFormat:@"%zd天", [Dict[@"monthDay"] integerValue]];
            }else{
                if ([self isLegalObject:Dict[@"periodTimeUnit"]]) {
                    if ([Dict[@"periodTimeUnit"] integerValue] == 1) {
                       cell.borrowDeadlineLable.text = [self isLegalObject:Dict[@"borroePeriod"]] ? [NSString stringWithFormat:@"%zd", [Dict[@"borroePeriod"] integerValue]] : @"";
                        cell.TermInvestmentDesc.text = @"理财期限(月)";

                    } else {
                        cell.borrowDeadlineLable.text = [self isLegalObject:Dict[@"borroePeriod"]] ? [NSString stringWithFormat:@"%zd", [Dict[@"borroePeriod"] integerValue]] : @"";
                    }
                }
            }

        }else{
            cell.cjDateLab.text = [NSString stringWithFormat:@"剩余:%@天",Dict[@"bcrRecoverPeriod"]];
            cell.addBidRateLable.hidden = YES;
        }
        
        return cell;
        
    }    return nil;
}

-(void)buyClick:(UIButton *)btn{
   

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_productMutableArray.count <=0) {
        [self errorPrompt:3.0 promptStr:@"暂无数据"];
        return;
    }

    NSDictionary *dict = nil;
    dict = [_productMutableArray objectAtIndex:indexPath.row];
    if (self.type == ProductStyle_shortBid) {
        ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
        ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[dict objectForKey:@"id"] integerValue]];
        ProductdetailsView.bidNameString = dict[@"title"];
        [self customPushViewController:ProductdetailsView customNum:0];
        //点击过后的标题变灰色
        UILabel *titleLable = (UILabel *) [self.view viewWithTag:[dict[@"id"] integerValue]];
        titleLable.textColor = [UIColor darkGrayColor];
    }else{
        if ([self isBlankString:getObjectFromUserDefaults(UID)] || [self isBlankString:getObjectFromUserDefaults(SID)]) {
            VerificationiPhoneNumberViewController *verificationiPhoneNumber = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
            [self customPushViewController:verificationiPhoneNumber customNum:0];
        } else {
            TransferViewController *transferView = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];
            transferView.transferbid_id = dict[@"id"];
           transferView.debtUid = dict[@"debtUid"];
            [self customPushViewController:transferView customNum:0];
        }
    }
    //    [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)forMoenyString:(NSString *)num{
    float acount = [num floatValue]/10000;
    return acount<1?
    [NSString stringWithFormat:@"%.2f",[num floatValue]]
    :[NSString stringWithFormat:@"%.2f万",acount];
}

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
                    [_tableViewList reloadData];
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }fail:^{
      index++;
      if (index < 3) {
          [self loadSettingData];
      }else{
          [self errorPrompt:3.0 promptStr:errorPromptString];
      }
  }];
}


@end
