//
//  HomeViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "SDRefresh.h"
#import "HomeHeaderView.h"
#import "PropagandaView.h"
#import "GuidanceManager.h"
#import "HomeTableViewCell.h"
#import "AdvertiseInfoBean.h"
#import "HomeViewController.h"
#import "ChangeViewController.h"
#import "NewDiscoveryViewController.h"
#import "ProductdetailsViewController.h"
#import "RechargeRecordViewController.h"
#import "HomeNotifyAndAdressAlertView.h"
#import "setPaymentPassWorldViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "Masonry.h"

//test
#import "shareView.h"
#import "BindingBankCardViewController.h"
#import "CreditRechargeViewController.h"
#import "AppDelegate.h"
#import "ChanLingViewController.h"
#import "HomeCollectionViewCell.h"

#define GuidingPlayedState_UserDefaults_Key   @"GuidingPlayedState"


#define screenWidth [[UIScreen mainScreen] bounds].size.width // 屏幕宽度的宏定义

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,HomeNotifyAndAdressAlertViewDelegate,PropagandaViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSString *refreshType;         //通知刷新来源
@property (nonatomic, retain) NSMutableArray *adArray;     //广告数据，成员
@property (nonatomic, copy) NSDictionary *earningsDict;    //本月收益累计收益
@property (nonatomic, copy) NSDictionary *homeDict;        //提现充值账单
@property (nonatomic, copy) NSDictionary *NotifictionDict;
@property (nonatomic, copy) NSDictionary *NewExclusiveData;//新手专享数据
@property (nonatomic, copy) NSDictionary *oldExclusiveData;
@property (nonatomic, copy) NSDictionary *UserInformationDict;
@property (nonatomic, copy) NSString * changeMoneyRate;
@property (nonatomic, copy) NSString * enveloperMoneyStr;  //红包金额
@property (nonatomic, strong) UIAlertView * changeMoneyAlert;
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) NSArray * propagandaArray;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong) HomeHeaderView *homeHeaderView;
@property (nonatomic, strong) NewDiscoveryViewController *discoveryViewController;
@property (strong, nonatomic) HomeNotifyAndAdressAlertView *NotificationView;
@property (strong, nonatomic) PropagandaView * propagandaView;

@property (weak, nonatomic) IBOutlet UIView *HomeNavagationView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSString *leiJiStr;
@property (nonatomic, strong) NSString *zongStr;
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UILabel *labS;
@property (nonatomic, strong) NSString *chanStr;

@property (nonatomic, strong) NSString *bidStrOne;
@property (nonatomic, strong) NSString *bidStrTwo;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSMutableArray *biaoArray;
@property (nonatomic, strong) NSString *sele;

@property (nonatomic,strong)UICollectionView *footCollectView;

@end

@implementation HomeViewController
static NSString *cellCollectID = @"cellCollectID";

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dismissPopupController];
    [self talkingDatatrackPageEnd:@"首页"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"首页"];
    [self hideMDErrorShowView:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sele = @"0";
    _biaoArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self createTableView];
    [self addTableViewHeaderView];
    
    //刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshHomeData:) name:RefreshHomeView object:nil];
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isChangeMessageBtnImage:) name:HideDiscoveryviewRedDot object:nil];
    //禁用messageBtn
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBtnObserver:) name:DisableMessageBtn object:nil];
    
    //开启监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self errorPrompt:3.0 promptStr:@"亲，没有网络哦！"];
        } else {
            if ([self.adArray count] == 0) {
                [self loadCSviewData];
            }
            if ([self isBlankString:getObjectFromUserDefaults(UID)] || [self isBlankString:getObjectFromUserDefaults(SID)]) {
                
                [self hongbaoLabelDownloadData];
                [_weakRefreshHeader endRefreshing];
                
            }else{
                [self loadNewExclusiveDataOen];
            }
        }
    }];
    
    //广告数据初始化
    self.adArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self leijiChengjiao];
    //[self changMoeny];
    [self setupHeader];
    [self loadNewExclusiveDataOen];
}


//通知方法
- (void)freshHomeData:(NSNotification*)notify
{
    [_weakRefreshHeader beginRefreshing];/*改变刷新文字及图标*/
    
    _refreshType = [notify object];
    
    if ([_refreshType isEqualToString:@"手势完成后加载系统通知"]) {
        //请求是否有通知消息
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadNotifictionData];
        });
    }else{
        
        [self loadNotifictionData];
        
        [self loadCSviewData];
        
        [self loadNewExclusiveDataOen];
        
    }
}

- (void)messageBtnObserver:(NSNotification *)notify
{
    NSString * notifyStr = [notify object];
    if ([notifyStr isEqualToString:@"禁用"]) {
        self.messageBtn.enabled = NO;
    }else{
        self.messageBtn.enabled = YES;
    }
}

- (void)isChangeMessageBtnImage:(NSNotification*)notify
{
    [self.messageBtn setImage:[UIImage imageNamed:@"home_message_have"] forState:UIControlStateNormal];
}

- (void)createTableView
{
    
    _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-49) style:UITableViewStylePlain];
    _homeTableView.backgroundColor = [UIColor clearColor];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_homeTableView];
    [self.view bringSubviewToFront:_HomeNavagationView];
}

-(UICollectionView *)footCollectView{
    
    if (!_footCollectView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 2;
        //设置滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        if (iPhone5||iPhone4) {
             layout.itemSize = CGSizeMake(screenWidth - 40, 240);
            _footCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, screenWidth, 240) collectionViewLayout:layout];
            _footCollectView.pagingEnabled = YES;

        }else{
             layout.itemSize = CGSizeMake(screenWidth - 50, 245);
        _footCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 25, screenWidth, 245) collectionViewLayout:layout];
            _footCollectView.pagingEnabled = YES;
        }
        
        _footCollectView.backgroundColor = [UIColor colorWithHex:@"F6F6F6"];
        
        _footCollectView.showsHorizontalScrollIndicator = NO;
       // [_footCollectView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:cellCollectID];
        [_footCollectView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellCollectID];
        _footCollectView.delegate = self;
        _footCollectView.dataSource = self;
    }
    return _footCollectView;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (iPhone5||iPhone4) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return UIEdgeInsetsMake(0, 25, 0, 25);
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat offSetX = targetContentOffset->x; //偏移量
    
    CGFloat itemWidth = screenWidth -60;   //itemSizem 的宽
    
    //itemSizem的宽度+行间距 = 页码的宽度
    
    NSInteger pageWidth = itemWidth + 30;
    
    //根据偏移量计算 第几页
    
    NSInteger pageNum = (offSetX+pageWidth/2)/pageWidth;
    
    //根据显示的第几页,从而改变偏移量
    
//    targetContentOffset->x = pageNum*pageWidth;
    
//    NSLog(@"%.1f",targetContentOffset->x);
    if (pageNum < [self.footCollectView numberOfItemsInSection:0]) {
        [self.footCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageNum inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_oldExclusiveData == nil || _oldExclusiveData == NULL || [_oldExclusiveData isEqual:@""] || [_oldExclusiveData isEqual:@"NULL"] ) {
            return _biaoArray.count;
        }
        return _biaoArray.count + 1;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (_oldExclusiveData == nil|| _oldExclusiveData == NULL || [_oldExclusiveData isEqual:@""] || [_oldExclusiveData isEqual:@"NULL"]) {
        
        if (indexPath.item == 0 || indexPath.item == 1) {
            NSDictionary *weidaiDict = nil;
            if (indexPath.item   < _biaoArray.count) {
                weidaiDict = [_biaoArray objectAtIndex:indexPath.item];
            }
            
            //        [self changeMoneyTapDelegate];
            ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
            ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[weidaiDict objectForKey:@"bid"] integerValue]];
            ProductdetailsView.bidNameString = weidaiDict[@"title"];
            [self customPushViewController:ProductdetailsView customNum:0];
        }
    }else{
        if (indexPath.item == 1 || indexPath.item == 2) {
            NSDictionary *weidaiDict = nil;
            if (indexPath.item - 1  < _biaoArray.count) {
                weidaiDict = [_biaoArray objectAtIndex:indexPath.item - 1];
            }
            
            ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
            ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[weidaiDict objectForKey:@"bid"] integerValue]];
            ProductdetailsView.bidNameString = weidaiDict[@"title"];
            [self customPushViewController:ProductdetailsView customNum:0];
            
        }
        
        if (indexPath.item == 0) {
            ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
            ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[_oldExclusiveData objectForKey:@"bid"] integerValue]];
            ProductdetailsView.bidNameString = _oldExclusiveData[@"title"];
            [self customPushViewController:ProductdetailsView customNum:0];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellCollectID forIndexPath: indexPath];
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    UIButton *deviceImageButton = cell.buyBttn;
    [deviceImageButton addTarget:self action:@selector(deviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    if (iPhone5) {
        cell.TITLE.font = [UIFont fontWithName:@".PingFangSC-Regular" size:13];
        cell.nianHuaLab.font = [UIFont fontWithName:@".PingFangSC-Regular" size:35];
        cell.dataLab.font = [UIFont fontWithName:@".PingFangSC-Regular" size:35];
    }
    if (_oldExclusiveData == nil) {
        cell.typeImage .hidden = YES;
        NSLog(@"%ld",(long)indexPath.item);
        if (indexPath.item == 0 || indexPath.item == 1) {
            NSDictionary *weidaiDict = nil;
            //NSDictionary *weidaiDict1 = nil;
            if (indexPath.item   < _biaoArray.count) {
                weidaiDict = [_biaoArray objectAtIndex:indexPath.item ];
            }
            if ([weidaiDict[@"period_time_unit"] isEqualToString:@"0"]) {
                cell.tianLab.text = @"天";
            }else{
                cell.tianLab.text = @"月";
            }

            cell.TITLE.text =[NSString stringWithFormat:@"%@", weidaiDict[@"title"]];
            cell.dataLab.text = [NSString stringWithFormat:@"%@",weidaiDict[@"borrow_period"]];
            cell.nianHuaLab.text = [NSString stringWithFormat:@"%.1f",[weidaiDict[@"borrow_apr"] doubleValue]];
            
//            cell.tianLab.text = @"";
        }
    }else{
        
        NSLog(@"%ld",(long)indexPath.item);
        NSLog(@"%@", _oldExclusiveData);
        
        if (indexPath.item == 0) {
            cell.TITLE.text = _oldExclusiveData[@"title"];
            cell.dataLab.text = [NSString stringWithFormat:@"%@",_oldExclusiveData[@"borrow_period"]];
            if ([_oldExclusiveData[@"period_time_unit"] isEqualToString:@"0"]) {
                cell.tianLab.text = @"天";
            }else{
            cell.tianLab.text = @"月";
            }
            cell.typeImage.hidden = NO;
            //标的利率
            if (![_oldExclusiveData[@"borrow_apr"] isKindOfClass:[NSNull class]]) {
                NSString * bidRateString = [NSString stringWithFormat:@"%.1f", [_oldExclusiveData[@"borrow_apr"] doubleValue]];
                cell.nianHuaLab.text = bidRateString;
            }
            [cell setFinishAction:^{
                ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
                ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[_oldExclusiveData objectForKey:@"bid"] integerValue]];
                ProductdetailsView.bidNameString = _oldExclusiveData[@"title"];
                [self customPushViewController:ProductdetailsView customNum:0];
                
            }];
        }
        
        if (indexPath.item == 1 || indexPath.item == 2) {

            cell.typeImage.hidden = YES;
            if (_biaoArray.count <= 0) {
                cell.TITLE.text = @"";
                cell.dataLab.text = @"";
                cell.nianHuaLab.text = @"";
            
            }else{
                NSDictionary *weidaiDict = nil;
                //NSDictionary *weidaiDict1 = nil;
                if (indexPath.item - 1  < _biaoArray.count) {
                    weidaiDict = [_biaoArray objectAtIndex:indexPath.item - 1];
                }
                if ([weidaiDict[@"period_time_unit"] isEqualToString:@"0"]) {
                    cell.tianLab.text = @"天";
                }else{
                    cell.tianLab.text = @"月";
                }

                cell.TITLE.text =[NSString stringWithFormat:@"%@", weidaiDict[@"title"]];
                cell.dataLab.text = [NSString stringWithFormat:@"%@",weidaiDict[@"borrow_period"]];
                cell.nianHuaLab.text = [NSString stringWithFormat:@"%.1f",[weidaiDict[@"borrow_apr"] doubleValue]];
                cell.typeImage.hidden = YES;
            }
        }
    }
       return cell;
}

- (void)addTableViewHeaderView
{
    if (!_homeHeaderView) {
        if (iPhone6_) {//headerView_topView 116
            _homeHeaderView = [[HomeHeaderView alloc] initWithViewFram:CGRectMake(0, 0, iPhoneWidth, 350) viewController:self];
        }else if(iPhone5){
            _homeHeaderView = [[HomeHeaderView alloc] initWithViewFram:CGRectMake(0, 0, iPhoneWidth, 280) viewController:self];
        }else{
         _homeHeaderView = [[HomeHeaderView alloc] initWithViewFram:CGRectMake(0, 0, iPhoneWidth, 310) viewController:self];
        }
    }
    self.homeTableView.tableHeaderView = _homeHeaderView;
    [_homeHeaderView setAdViewDataWithArray:self.adArray];
    if (iPhone5) {
        UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, iPhoneHeight - _homeHeaderView.frame.size.height)];
        [footV addSubview:self.footCollectView];
        
        _homeTableView.tableFooterView = footV;
    }else{
        UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, iPhoneHeight - _homeHeaderView.frame.size.height )];
        //footV.backgroundColor = [UIColor colorWithHex:@"F6F6F6"];
        
        [footV addSubview:self.footCollectView];
        
        _homeTableView.tableFooterView = footV;
    }
}

#pragma HomeHeaderView - headerDict
/**
 *  首页获取资产本月收益累计收益setAdViewDataWithArray接口
 */
- (void)loadHomeHeaderViewinfo {
    if (![self isBlankString:getObjectFromUserDefaults(ACCESSTOKEN)] ) {
        WS(weakSelf);
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"uid": getObjectFromUserDefaults(UID) };
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyEarning", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadHomeHeaderViewinfo];
                }withFailureBlock:^{
                                                                         
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [_weakRefreshHeader endRefreshing];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _earningsDict = [responseObject[@"item"] copy];
                    NSLog(@"本月收益累计收益 = %@",_earningsDict);
                    if (_earningsDict != nil) {
                        [_homeHeaderView setTheMonthAssetsEarningsDataWithDictionary:_earningsDict];
                    }
                }
            } else {
                [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }fail:^{
          [_weakRefreshHeader endRefreshing];
          [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
            
        }];
    } else {
        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
            
        }withFailureBlock:^{
                                                                 
        }];
    }
}

- (void)loadNotifictionData {
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getImportantNotice?at=%@", GeneralWebsite, getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        WS(weakSelf);
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadNotifictionData];
                }withFailureBlock:^{
                                                                         
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if (_NotifictionDict) {
                    _NotifictionDict = nil;
                }
                _NotifictionDict = [(NSDictionary *) responseObject[@"item"] copy];
                if ([self isLegalObject:_NotifictionDict]) {
                    [self isShowNotificationView];
                }
                //                [self loadPropagandaImagesData];
            }else{
                [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }fail:^{
        [_weakRefreshHeader endRefreshing];
        [self errorPrompt:3.0f promptStr:errorPromptString];
    }];
}

- (void)isShowNotificationView {
#if 1
    if ([self isLegalObject:_NotifictionDict] && ![getObjectFromUserDefaults(NotificationUserDefaults) isEqualToString:_NotifictionDict[@"updateTimeStr"]]) {
        //通知view
        if (!_NotificationView) {
            _NotificationView = [[HomeNotifyAndAdressAlertView alloc] initWithHomeNotifyAndAdressAlertViewDelegate:self];
            [_NotificationView setNotificaitonViewConstant];
            [_NotificationView setHomePageNotificationDetailsView:_NotifictionDict];
        }
        [self showPopupWithStyle:CNPPopupStyleCentered popupView:_NotificationView];
    }else{
        
    }
    
    
#elif 0 //Test
    //通知view
    if (!_NotificationView) {
        _NotificationView = [[HomeNotifyAndAdressAlertView alloc] initWithHomeNotifyAndAdressAlertViewDelegate:self];
        [_NotificationView setNotificaitonViewConstant];
        [_NotificationView setHomePageNotificationDetailsView:_NotifictionDict];
    }
    [self showPopupWithStyle:CNPPopupStyleCentered popupView:_NotificationView];
#endif
}

- (BOOL)needShowGuidancePage
{
    if ([self guidancePlayedStateString].length != 0)
    {
        NSString * versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        if ([[self guidancePlayedStateString] isEqualToString:versionString])
        {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (NSString *)guidancePlayedStateString
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    //    NSString * state = [NSString stringWithObject:[userDefault valueForKey:GuidingPlayedState_UserDefaults_Key]];
    NSString *state = [userDefault valueForKey:GuidingPlayedState_UserDefaults_Key];
    return state;
}

- (void)loadNewExclusiveDataOen
{
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID)};
    
    
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getOneRecommendedBidDetailByType", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        WS(weakSelf);
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadNewExclusiveDataOen];
                }withFailureBlock:^{
                                                                         
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self hideMDErrorShowView:self];
                [_weakRefreshHeader endRefreshing];
                NSArray *array = responseObject[@"data"];
                NSLog(@"%@",array);
                if (![array isEqual:[NSNull null]]) {
                    _biaoArray = [NSMutableArray arrayWithArray:array];
                }

                NSLog(@"%@",responseObject[@"item"]);
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _oldExclusiveData = [responseObject[@"item"] copy];
                    NSLog(@"%@",_oldExclusiveData);
                }else{
                    _oldExclusiveData = nil;
                }
                if (_oldExclusiveData || _biaoArray.count>0) {
                    [self.footCollectView reloadData];
                }

            }else{
                [_weakRefreshHeader endRefreshing];
//                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                [self hideMDErrorShowView:self];
                NSLog(@"%@",responseObject[@"msg"]);
            }
        }
    }fail:^{
        [_weakRefreshHeader endRefreshing];
       [self errorPrompt:3.0f promptStr:errorPromptString];
    }];
}


//累计收益
-(void)leijiChengjiao{
    
    NSDictionary *parmeters = @{@"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/mobileCount",GeneralWebsite] parameters:parmeters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            NSLog(@"%@",responseObject);
            
            if ([responseObject[@"all"]doubleValue] < 10000) {
                _homeHeaderView.leijiChenBtn.text = [NSString stringWithFormat:@"%.2f元",[responseObject[@"all"] doubleValue]];
            }else{
             _homeHeaderView.leijiChenBtn.text = [Number3for1 forNumMoeny:[NSString stringWithFormat:@"%.2f",[responseObject[@"all"] doubleValue]]];
            }
           
            if ([responseObject[@"earning"] doubleValue] < 10000) {
                _homeHeaderView.leijiShouyiBtn.text = [NSString stringWithFormat:@"%.2f元",[responseObject[@"earning"] doubleValue]];
            }else{
            _homeHeaderView.leijiShouyiBtn.text = [Number3for1 forNumMoeny:[NSString stringWithFormat:@"%.2f",[responseObject[@"earning"]doubleValue]]];
            }
            
        }
        
    } fail:^{
        
    }];
}
//零钱包
-(void)changMoeny{
    if (![self isBlankString:getObjectFromUserDefaults(ACCESSTOKEN)]) {
        WS(weakSelf);
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getCoin", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf changMoeny];
                }withFailureBlock:^{
                                                                         
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [_weakRefreshHeader endRefreshing];
                NSLog(@"%@",responseObject);
                _chanStr = [NSString stringWithFormat:@"%@",responseObject[@"item"]];
            } else {
                [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }fail:^{
          [_weakRefreshHeader endRefreshing];
          [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
       }];
    } else {
        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
            
        }withFailureBlock:^{
        
        }];
    }
}

#pragma HomeTableView - homeInfo
/**
 *  提现充值月账单
 */
- (void)loadHomeCellInfo {
    if (![self isBlankString:getObjectFromUserDefaults(ACCESSTOKEN)]) {
        WS(weakSelf);
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"uid": getObjectFromUserDefaults(UID) };
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getHomeBill", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    
                    [weakSelf loadHomeCellInfo];
                    
                }withFailureBlock:^{
                
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [_weakRefreshHeader endRefreshing];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _homeDict = [responseObject[@"item"] copy];
                    NSLog(@"提现充值月账单 = %@",_homeDict);
                }
                
            } else {
                [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }fail:^{
          [_weakRefreshHeader endRefreshing];
          [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
         }];
    } else {
        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
            
        }withFailureBlock:^{
                                                                 
        }];
    }
}

#pragma mark - HTTP (轮播图)
- (void)loadCSviewData {
    if ([_adArray count] == 0) {
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"type": @"3"};
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/queryList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadCSviewData];
                    }
                                                                         withFailureBlock:^{
                                                                             
                                                                         }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    if ([self.adArray count] > 0) {
                        [self.adArray removeAllObjects];
                    }
                    NSArray *AdvArr = [(NSArray *) responseObject[@"data"] copy];
                    if ([AdvArr count] > 0) {
                        for (int i = 0; i < [AdvArr count]; i++) {
                            AdvertiseInfoBean *advertise = [[AdvertiseInfoBean alloc] initWithDictionary:[AdvArr objectAtIndex:i]];
                            [self.adArray addObject:advertise];
                        }
                        [_homeHeaderView setAdViewDataWithArray:self.adArray];
                        //                        [self.homeTableView reloadData];
                    }
                } else {
                    [_weakRefreshHeader endRefreshing];
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        }
                                  fail:^{
                                      [_weakRefreshHeader endRefreshing];
                                      [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
                                  }];
    }
}

#pragma mark - 获取红包金额
- (NSString *)hongbaoLabelDownloadData{
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/getRedPacketAmount?at=%@", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if ([self isLegalObject:responseObject[@"item"]]) {
                NSDictionary * dict = responseObject[@"item"];
                if ([self isLegalObject:dict[@"AMOUNT"]]) {
                    _enveloperMoneyStr = [NSString stringWithFormat:@"%@",dict[@"AMOUNT"]];//红包金额
                    //[_homeTableView reloadData];
                }
            }else{
                _enveloperMoneyStr = @"-";
            }
        }else{
            _enveloperMoneyStr = @"-";
        }
        
    }
     
                              fail:^{
                                  _enveloperMoneyStr = @"-";
                              }];
    return _enveloperMoneyStr;
}

#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_homeTableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadCSviewData];
            [self loadNewExclusiveDataOen];
            [self leijiChengjiao];
        });
    };
}

#pragma mark - HomeNotifyAndAdressAlertViewDelegate
- (void)cancleBtnClicked
{
    if (_NotificationView) {
        //当用户点击叉叉的时候记录下，此条通知不显示
        saveObjectToUserDefaults(_NotifictionDict[@"updateTimeStr"], NotificationUserDefaults);
    }
    [self dismissPopupController];
    
    [self isShowPropagandaView];//宣传view
}

- (void)importAdressBookPage{
}


/**
 *  phone/queryList?type=13  首页零钱包弹窗接口
 */
#pragma mark - 首页零钱包弹窗接口
- (void)loadPropagandaImagesData {
    if (getObjectFromUserDefaults(ACCESSTOKEN)) {/*M7fbfba2e1baba27c446b2f41f3e98480*/
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"type": @"13"
                                      };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/queryList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadPropagandaImagesData];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                id data = responseObject[@"data"];
                if ([data isKindOfClass:[NSArray class]]) {
                    NSArray *dataArray = (NSArray *) data;
                    if (dataArray.count > 0) {
                        _propagandaArray = [NSArray arrayWithArray:dataArray];
                        
                        //                        [self isShowPropagandaView]; // test
                    }
                }
            }
        }
                                  fail:^{
                                      
                                  }];
    }
}


#pragma mark - PropagandaView && PropagandaViewDelegate
- (void)isShowPropagandaView
{
    if ([self isLegalObject:_propagandaArray]) {
        //宣传view
        if (!_propagandaView) {
            _propagandaView = [[PropagandaView alloc] init];
            _propagandaView.delegate = self;
        }
        
        /* NSArray * testArray = @[@{@"path":@"http://qianluwangfile.oss-cn-hangzhou.aliyuncs.com/ad_20170410121520471.png",
         @"title":@"测试11111",
         @"urlLink":@"https://www.baidu.com"},
         @{@"path":@"http://qianluwangfile.oss-cn-hangzhou.aliyuncs.com/ad_20170410121520471.png",
         @"title":@"测试22222",
         @"urlLink":@"http://tieba.baidu.com/f?kw=%C3%C0%C5%AE&fr=ala0&tpl=5"},
         @{@"path":@"http://qianluwangfile.oss-cn-hangzhou.aliyuncs.com/ad_20170410121520471.png",
         @"title":@"测试33333",
         @"urlLink":@"http://baike.baidu.com/link?url=eMz79VsSTq_6L524fCNpD6To2q4uJY4BPYXUQqinVRJ69IkJITP4C3eDCD7W1fiEI2qMZCLaAcf-LqY5vJ5IlJ5RXQOyiFmXP8gave99DthbWxHoorFHK1CrccH0rw5kPZcuY6V6rRbCIrUJyneghmncWZUjV-ycgo5vHM4ARYSYhYvtvxUAK2211n7cvIC7z7iVu_evgH71cVNE32X1hwXX8zM6oZdDrbQA07ldki05LnS2PUug3IiH8Cn16QQO"}];
         [_propagandaView setPropagandaImagesArray:testArray viewController:self]; */
        
        [_propagandaView setPropagandaImagesArray:_propagandaArray viewController:self];
        [self showPopupWithStyle:CNPPopupStyleCentered popupView:_propagandaView];
    }
}


- (void)cancelPropagandaViewBtnClicked
{
    [self dismissPopupController];
}

/**
 *
 */
#pragma mark - 获取 零钱包数据接口 bid/getCoin
- (void)loadChangeMoneyData
{
    NSDictionary *parameters = @{ @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getCoin", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadChangeMoneyData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [_weakRefreshHeader endRefreshing];
                if ([self isLegalObject:responseObject[@"item"]]) {
                    _changeMoneyRate = [NSString stringWithFormat:@"%@", responseObject[@"item"]];
                    [_homeTableView reloadData];//数据不多 多刷新
                }
            } else {
                [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [_weakRefreshHeader endRefreshing];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

#pragma mark - HomeHeaderViewDelegate
- (void)changeMoneyTapDelegate
{
    if ([self isBlankString:getObjectFromUserDefaults(UID)] || [self isBlankString:getObjectFromUserDefaults(SID)]) {
        
        VerificationiPhoneNumberViewController *verificationiPhoneNumber = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verificationiPhoneNumber.pushviewNumber = 888;
        [self customPushViewController:verificationiPhoneNumber customNum:0];
    }else{
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
                _UserInformationDict = [responseObject[@"item"] copy];
                //是否设置交易密码
                if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDict[@"pay"] integerValue] == 1) {
                    
                    //是否绑卡
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        _changeMoneyAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"零钱计划需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_changeMoneyAlert show];
                        
                    } else {
                        ChangeViewController * changeVC = [[ChangeViewController alloc] initWithNibName:@"ChangeViewController" bundle:nil];
                        [self customPushViewController:changeVC customNum:0];
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
    if (alertView == _changeMoneyAlert && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return /*2*/1;
    //    if ([_oldExclusiveData[@"item"] isEqualToString:@"null"] || _oldExclusiveData[@"item"] == nil) {
    //        return 2;
    //    }
    
    
    
//    if (_oldExclusiveData == nil) {
//        return _biaoArray.count;
//    }
//    return _biaoArray.count + 1;

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 8)];
        view.backgroundColor = [UIColor colorWithHex:@"F4F4F4"];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;//section==1?8:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HomeNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[HomeNewTableViewCell HomeNewTableViewCellID]];
//  
//    
//    if (cell == nil) {
//        cell = [HomeNewTableViewCell addHomeNewTableViewCell];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (_oldExclusiveData == nil) {
//        if (indexPath.section == 0 || indexPath.section == 1) {
//            
////            if (_biaoArray.count <= 0) {
////                cell.subTitleLab.text = @"";
////                cell.dateLab.text = @"";
////                cell.moneyLab.text = @"";
////                cell.profitLab.text = @"";
////                cell.setNameLab.text = @"优选推荐";
////                cell.typeImgView.image = [UIImage imageNamed:@"标"];
////                
////            }else{
//            
//                NSDictionary *weidaiDict = nil;
//                //NSDictionary *weidaiDict1 = nil;
//                if (indexPath.section   < _biaoArray.count) {
//                    weidaiDict = [_biaoArray objectAtIndex:indexPath.section ];
//                }
//                cell.subTitleLab.text =[NSString stringWithFormat:@"%@", weidaiDict[@"title"]];
//                cell.dateLab.text = [NSString stringWithFormat:@"%@天",weidaiDict[@"borrow_period"]];
//                cell.moneyLab.text = [NSString stringWithFormat:@"%@元",weidaiDict[@"tender_account_min"]];
//                cell.profitLab.text = weidaiDict[@"borrow_apr"];
//                cell.setNameLab.text = @"优选推荐";
//                cell.typeImgView.image = [UIImage imageNamed:@"标"];
//            
//            //}
//            
//        }
//
//    }else{
//        if (indexPath.section == 0) {
////            if (_biaoArray.count <=0) {
////                cell.subTitleLab.text = @"";
////                cell.dateLab.text = @"";
////                cell.moneyLab.text = @"";
////                cell.profitLab.text = @"";
////                cell.typeImgView.image = [UIImage imageNamed:@"标"];
////                cell.setNameLab.text = @"新手专享";
////                
////                //标的利率
////                if (![_oldExclusiveData[@"borrow_apr"] isKindOfClass:[NSNull class]]) {
////                    NSString * bidRateString = [NSString stringWithFormat:@"%.2f", [_oldExclusiveData[@"borrow_apr"] doubleValue]];
////                    cell.profitLab.text = bidRateString;
////                }
//            
//                
//           // }else{
//                cell.subTitleLab.text = _oldExclusiveData[@"title"];
//                cell.dateLab.text = [NSString stringWithFormat:@"%@天",_oldExclusiveData[@"borrow_period"]];
//                cell.moneyLab.text = [NSString stringWithFormat:@"%@元",_oldExclusiveData[@"tender_account_min"]];
//                cell.profitLab.text = _oldExclusiveData[@"borrow_apr"];
//                cell.typeImgView.image = [UIImage imageNamed:@"标"];
//                cell.setNameLab.text = @"新手专享";
//                
//                //标的利率
//                if (![_oldExclusiveData[@"borrow_apr"] isKindOfClass:[NSNull class]]) {
//                    NSString * bidRateString = [NSString stringWithFormat:@"%.2f", [_oldExclusiveData[@"borrow_apr"] doubleValue]];
//                    cell.profitLab.text = bidRateString;
//                }
//                
//                
//            }
//            
//            
//        //}
//        
//        if (indexPath.section == 1 || indexPath.section == 2) {
//            
//            if (_biaoArray.count <= 0) {
//                cell.subTitleLab.text = @"";
//                cell.dateLab.text = @"";
//                cell.moneyLab.text = @"";
//                cell.profitLab.text = @"";
//                cell.setNameLab.text = @"优选推荐";
//                cell.typeImgView.image = [UIImage imageNamed:@"标"];
//                
//            }else{
//                NSDictionary *weidaiDict = nil;
//                //NSDictionary *weidaiDict1 = nil;
//                if (indexPath.section - 1  < _biaoArray.count) {
//                    weidaiDict = [_biaoArray objectAtIndex:indexPath.section - 1];
//                }
//                cell.subTitleLab.text =[NSString stringWithFormat:@"%@", weidaiDict[@"title"]];
//                cell.dateLab.text = [NSString stringWithFormat:@"%@天",weidaiDict[@"borrow_period"]];
//                cell.moneyLab.text = [NSString stringWithFormat:@"%@元",weidaiDict[@"tender_account_min"]];
//                cell.profitLab.text = weidaiDict[@"borrow_apr"];
//                cell.setNameLab.text = @"优选推荐";
//                cell.typeImgView.image = [UIImage imageNamed:@"标"];
//                
//            }
//        }
//
//    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_oldExclusiveData == nil) {
        
        if (indexPath.section == 0 || indexPath.section == 1) {
            NSDictionary *weidaiDict = nil;
            if (indexPath.section   < _biaoArray.count) {
                weidaiDict = [_biaoArray objectAtIndex:indexPath.section];
            }
            //        [self changeMoneyTapDelegate];
            ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
            ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[weidaiDict objectForKey:@"bid"] integerValue]];
            ProductdetailsView.bidNameString = weidaiDict[@"title"];
            [self customPushViewController:ProductdetailsView customNum:0];
        }
    }else{
        
        if (indexPath.section == 1 || indexPath.section == 2) {
            NSDictionary *weidaiDict = nil;
            if (indexPath.section - 1  < _biaoArray.count) {
                weidaiDict = [_biaoArray objectAtIndex:indexPath.section - 1];
            }
            ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
            ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[weidaiDict objectForKey:@"bid"] integerValue]];
            ProductdetailsView.bidNameString = weidaiDict[@"title"];
            [self customPushViewController:ProductdetailsView customNum:0];
        }
        if (indexPath.section == 0) {
            ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
            ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[_oldExclusiveData objectForKey:@"bid"] integerValue]];
            ProductdetailsView.bidNameString = _oldExclusiveData[@"title"];
            [self customPushViewController:ProductdetailsView customNum:0];
        }
    }
}

#pragma mark - UITableViewCellBtnClicked
- (void)clickedInvestBtnClicked:(UIButton *)btn
{
    ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
    ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[_NewExclusiveData objectForKey:@"bid"] integerValue]];
    ProductdetailsView.bidNameString = _NewExclusiveData[@"title"];
    [self customPushViewController:ProductdetailsView customNum:0];
}

- (void)checkBtnClicked:(UIButton *)btn
{
    //充值提现记录
    RechargeRecordViewController *RechargeRecordView = [[RechargeRecordViewController alloc] init];
    [self customPushViewController:RechargeRecordView customNum:0];
}

//立即领取  NullUID
- (void)ImmediatelyReceiveBtnClicked:(UIButton *)btn
{
    VerificationiPhoneNumberViewController *verificationiPhoneNumber = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
    [self customPushViewController:verificationiPhoneNumber customNum:0];
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;//只要滚动了就会触发
{
    
    if (scrollView.contentOffset.y < 0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    self.titleLabel.alpha = scrollView.contentOffset.y/64;
    _HomeNavagationView.backgroundColor = [UIColor colorWithRed:96/255.0 green:184/255.0 blue:211/255.0 alpha:scrollView.contentOffset.y/64];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)messageBtnClicked:(id)sender {
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

@end
