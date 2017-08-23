//
//  DiscoverController.m
//  BaiYangFinancial
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "DiscoverControllerOne.h"
#import "DiscoverHeadViewOne.h"
#import "DiscoverTableViewCell.h"
#import "FriendViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "VerificationiPhoneNumberViewController.h"
#import "IsDingqiViewController.h"

@interface DiscoverControllerOne ()<UITableViewDelegate, UITableViewDataSource,CustomUINavBarDelegate>

@property (nonatomic,strong)DiscoverHeadViewOne *headView;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndexNum; //请求数据页数
@property (nonatomic, strong) NSMutableArray *discoveryMutabArray;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong)NSString *styler;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDictionary *earningsDict;
@end

@implementation DiscoverControllerOne
-(void)goBack{
    [self customPopViewController:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"我的定期"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"我的定期"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self resetSideBack];
    [self loadHomeHeaderViewinfo];
    CustomMadeNavigationControllerView *NavigationControllerView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"我的定期" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:NavigationControllerView];

    _discoveryMutabArray = [[NSMutableArray alloc]initWithCapacity:0];
    _styler = @"1";
    _pageIndexNum = 1;
    [self configUI];
    [self setupHeader];
    [self setupFooter];
    [self isUserLogin];
    [self getMyDiscoveryListDataD];
    [_headView.allBtn addTarget:self action:@selector(allDq:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.endBtn addTarget:self action:@selector(allDq:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)allDq:(UIButton *)sender{
    
    if (sender.tag == 12121) {
        _styler = @"1";
        _pageIndexNum = 1;
        [self getMyDiscoveryListDataD];
    }else if (sender.tag == 12122){
        _styler = @"2";
        _pageIndexNum = 1;
        [self getMyDiscoveryListDataD];
    }
}

- (void)getMyDiscoveryListDataD {
    NSLog(@"%ld",(long)_pageIndexNum);
    NSDictionary *parameters = @{ @"pageIndex": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"type":_styler };
    NSLog(@"%@",parameters);
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/myRegularBidList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getMyDiscoveryListDataD];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self hideMDErrorShowView:self];

                if (_pageIndexNum == 1 && [_discoveryMutabArray count] > 0) {
                    [_discoveryMutabArray removeAllObjects];
                }
                [_weakRefreshHeader endRefreshing];
                NSArray *array = responseObject[@"data"];
                NSLog(@"%@",array);
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                        [weakSelf errorPrompt:3.0 promptStr:@"没有更多数据"];
                    }
                }
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (id info in array) {
                        [_discoveryMutabArray addObject:info];
                    }
                }
                if ([_discoveryMutabArray count] > 0) {
                    [weakSelf hideMDErrorShowView:self];
                    [_tableView reloadData];
                } else {
                    [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 219.5 + 64, iPhoneWidth, iPhoneHeight - 219.5 - 64) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
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

#pragma mark 判断是否登录
- (void)isUserLogin {
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) {//无为真
        VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verfication.pushviewNumber = 1234;
        [self customPushViewController:verfication customNum:0];
    }else{
        
        /*addData,NORefrash*/
        [self getMyDiscoveryListDataD];
    }
}
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self getMyDiscoveryListDataD];
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
        [self getMyDiscoveryListDataD];
        [self.refreshFooter endRefreshing];
    });
}


- (void)configUI {
    self.headView = [[NSBundle mainBundle] loadNibNamed:@"DiscoverHeadViewOne" owner:nil options:nil].firstObject;
    
    [self.view addSubview: self.headView];
    self.view.backgroundColor = [UIColor clearColor];
    self.headView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headView.bounds.size.height - 220) style:UITableViewStylePlain];
    [self.headView.scrollView addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       self.tableView.tableFooterView = [[UIView alloc] init]; 
    NSDictionary *weidaiDict = nil;
    if ([_discoveryMutabArray count] > 0) {
        weidaiDict = [_discoveryMutabArray objectAtIndex:indexPath.row];
        NSLog(@"%@",weidaiDict);
    }
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];//[DiscoverTableViewCell weidaiActivityTableViewCell_id]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLab.text = [self isLegalObject:weidaiDict[@"title"]] ? weidaiDict[@"title"] : @"";

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"hangzhou"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSLog(@"%@",weidaiDict[@"refundTime"]);
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[weidaiDict[@"refundTime"] doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    NSLog(@"%@",dateString);
    cell.dataLabOne.text = dateString;
    
//    cell.moenyLab.text = [NSString stringWithFormat:@"%.2f元",[[Number3for1 formatAmount:weidaiDict[@"conllenctionMoney"]] doubleValue]];
    cell.moenyLab.text = [NSString stringWithFormat:@"%.2f元",[weidaiDict[@"conllenctionMoney"] doubleValue]];

    cell.nianHuaLab.text = [NSString stringWithFormat:@"%.1f",[weidaiDict[@"borrowAnnualYield"] doubleValue]];
    
    
    if ([weidaiDict[@"zhuanrStatus"] isEqualToString:@"WAIT_TRANSFER"]) {
        cell.isOrNoLab.text = @"待承接";
        cell.isOrNoLab.hidden = NO;
    }else{
        NSInteger num;
        num = [weidaiDict[@"transfer_status"] integerValue];
        if (num == 1) {
            cell.isOrNoLab.text = @"可转让";
            cell.isOrNoLab.hidden = NO;
        }else if (num == 2) {
            cell.isOrNoLab.text = @"待承接";
            cell.isOrNoLab.hidden = NO;
        }else{
            cell.isOrNoLab.text = @"";
            cell.isOrNoLab.hidden = YES;
        }
    }
    
    
    if ([weidaiDict[@"bidStatus"] isEqualToString:@"REPAYING"]) {
        //还款中
        cell.imgView.image = [UIImage imageNamed:@"payment"];
    }else if ([weidaiDict[@"bidStatus"] isEqualToString:@"CLOSE"]){
        //已结束
        cell.imgView.image = [UIImage imageNamed:@"ending"];
    }else if ([weidaiDict[@"bidStatus"] isEqualToString:@"WAIT_RE_VERIFY"]){
        //已结束
        cell.imgView.image = [UIImage imageNamed:@"manbiao"];
    }else{
        cell.imgView.image = [UIImage imageNamed:@""];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_discoveryMutabArray count] > 0) {
        NSDictionary *weidaiDict = [_discoveryMutabArray objectAtIndex:indexPath.row];
        
        IsDingqiViewController *isDvc = [[IsDingqiViewController alloc]initWithNibName:@"IsDingqiViewController" bundle:nil];
        isDvc.bid = weidaiDict[@"bid"];
        isDvc.bidSubStatus = weidaiDict[@"bidStatus"];
        isDvc.zhaunrang = [weidaiDict[@"transfer_status"] intValue];
        isDvc.useID = weidaiDict[@"tuid"];
        isDvc.zhuanrStatus = weidaiDict[@"zhuanrStatus"];
 
        [self customPushViewController:isDvc customNum:0];
        
    }
}
- (void)loadHomeHeaderViewinfo {
    
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
                    self.headView.yestLab.text = [NSString stringWithFormat:@"%.2f",[_earningsDict[@"waitTotalMouth"] doubleValue]];
                    self.headView.isQianLab.text = [NSString stringWithFormat:@"%@",_earningsDict[@"amount"]];
                    self.headView.leijiLab.text = [NSString stringWithFormat:@"%.2f",[_earningsDict[@"totalEarning"] doubleValue]];
                }
            } else {
                [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }fail:^{
          [_weakRefreshHeader endRefreshing];
          [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
    }];
  {
        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
            
        }withFailureBlock:^{
                                                                 
    }];
    }
}

@end
