//
//  BidViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/22.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BidRecordTableViewCell.h"
#import "BidViewController.h"
#import "SDRefresh.h"
#import "CustomMadeNavigationControllerView.h"
#import "BidDetailViewController.h"

@interface BidViewController ()

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter; //上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong) NSMutableArray *accinfoArray; //加载投标记录返回的数据为数组
@property (nonatomic, assign) NSInteger pageIndexNum;     //请求数据页数
@end

@implementation BidViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"投资记录"];
    //移除错误界面
    [self hideMDErrorShowView:self];

//    if ([_accinfoArray count] > 0) {
//        [_accinfoArray removeAllObjects];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"投资记录"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomMadeNavigationControllerView *MDInvestRecordView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"投资记录" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:MDInvestRecordView];
    
    //初始化
    _pageIndexNum = 1;
    //初始化数组
    _accinfoArray = [NSMutableArray  array];
    [self setupHeader];
    [self setupFooter];
    
    [self loadBidRecordData];
}

//TODO:返回按钮
- (void)goBack {
    [self customPopViewController:0];
}

- (void)viewDidCurrentView {
    //    [self loadBidRecordData];
    if ([_accinfoArray count] == 0) {
        [_weakRefreshHeader beginRefreshing];
    } else {
        
        [self._tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
/*
 {
	bid = 3249,
	borrowAmount = <null>,
	repayAmonutAll = 4012.48,
	borrowerPeriod = 3个月,
	successTime = 2016-07-19,
	repayInterestAll = 116.85,
	borrowerName = 李彬,
	repaymentStyle = <null>,
	bidName = 白杨第160786期,
	borrowAnnualYield = 12,
	account = 3895.63,
	status = REPAYING
 },
 */
#pragma mark - 加载投标记录的数据
- (void)loadBidRecordData {
    NSDictionary * parameters = @{
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"pageSize": @"10",
                                  @"pageIndex": [NSString stringWithFormat:@"%zd", _pageIndexNum]
                                  };
    
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/recentBidList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadBidRecordData];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadBidRecordData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
//                NSLog(@"投资记录页数据 = %@",responseObject[@"data"]);
                [_weakRefreshHeader endRefreshing];
                if (_pageIndexNum == 1 && [_accinfoArray count] > 0) {
                    [_accinfoArray removeAllObjects];
                } else {
                    [self.refreshFooter endRefreshing];
                }

                NSArray *array = responseObject[@"data"];
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                        [self errorPrompt:3.0 promptStr:@"没有更多投标记录"];
                    }
                }
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (id info in array) {
                        [_accinfoArray addObject:info];
                    }
                }
                if ([_accinfoArray count] > 0) {
                    [self._tableView reloadData];
                } else {
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                }
            } else {
                //隐藏加载动画  似乎没有
                [self dismissWeidaiLoadAnimationView:self];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                [_weakRefreshHeader endRefreshing];
            }
        }
    }
        fail:^{
            [self dismissWithDataRequestStatus];
            //隐藏加载动画  似乎没有
//            [self dismissWeidaiLoadAnimationView:self];
            /*似乎这句没啥用*/
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 108) contentShowString:errorPromptString MDErrorShowViewType:NoData];
            [_weakRefreshHeader endRefreshing];
            [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 108 - 50)];//self本viewcontrller 必须64
        }];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _accinfoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *accinfoDict = nil;
    if ([_accinfoArray count] > 0) {
        accinfoDict = [_accinfoArray objectAtIndex:indexPath.row];
    }
    static NSString *Identifier = @"cell";
    BidRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BidRecordTableViewCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    //投标记录数据
    if ([self isLegalObject:accinfoDict[@"bidName"]]) {
        cell.bidName.text = [accinfoDict objectForKey:@"bidName"];
    } else {
        cell.bidName.text = @"";
    }
    if ([self isLegalObject:accinfoDict[@"repayAmonutAll"]]) {
       NSString * repayAmonutAll = [NSString stringWithFormat:@"%.2f元", [[accinfoDict objectForKey:@"repayAmonutAll"] doubleValue] - [[accinfoDict objectForKey:@"repayInterestAll"] doubleValue]];
        cell.repayAmonutAll.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:repayAmonutAll]];
        
    } else {
        cell.repayAmonutAll.text = @"";
    }
    if ([self isLegalObject:accinfoDict[@"repayInterestAll"]]) {
//        cell.repayInterestAll.text = [NSString stringWithFormat:@"%.2f元", [[accinfoDict objectForKey:@"repayInterestAll"] doubleValue]];
        cell.repayInterestAll.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:[accinfoDict objectForKey:@"repayInterestAll"]]];
    } else {
        cell.repayInterestAll.text = @"0.00元";
    }
    if ([self isLegalObject:accinfoDict[@"borrowAnnualYield"]]) {
        cell.borrowAnnualYield.text = [NSString stringWithFormat:@"%.2f%@", [[accinfoDict objectForKey:@"borrowAnnualYield"] doubleValue], @"%"];
    } else {
        cell.borrowAnnualYield.text = @"";
    }
    if ([self isLegalObject:accinfoDict[@"borrowerPeriod"]]) {
        cell.borrowerPeriod.text = [accinfoDict objectForKey:@"borrowerPeriod"];

    } else {
        cell.borrowerPeriod.text = @"";
    }
    
    if (![self isBlankString:accinfoDict[@"successTime"]]) {
        if ([self isLegalObject:accinfoDict[@"status"]]  && ([accinfoDict[@"status"] isEqualToString:@"REPAYING"] || [accinfoDict[@"status"] isEqualToString:@"CLOSE"])) {
            if ([self isLegalObject:accinfoDict[@"successTime"]]) {
                cell.successTime.text = [accinfoDict objectForKey:@"successTime"];
            } else {
                cell.successTime.text = @"";
            }
            
        }else{
            cell.successTime.text = @"";
        }
    }
    NSLog(@"%@",[accinfoDict objectForKey:@"borrowerPeriod"]);
//    NSLog(@"successTime =  %@",[_accinfoArray objectAtIndex:indexPath.row][@"successTime"]);
    [self setCellSeperatorToLeft:cell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",[_accinfoArray objectAtIndex:indexPath.row][@"status"]);
    if (!([[_accinfoArray objectAtIndex:indexPath.row][@"status"] isEqualToString:@"REPAYING"] || [[_accinfoArray objectAtIndex:indexPath.row][@"status"] isEqualToString:@"CLOSE"])) {
        [self errorPrompt:3.0 promptStr:@"该标暂未生成还款计划"];
//        [KVNProgress showErrorWithStatus:@"该标暂未生成还款计划"];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self dismissWithDataRequestStatus];
//        });
    }else{
        
    BidDetailViewController * bidDetail = [[BidDetailViewController alloc] init];
    bidDetail.bidString = _accinfoArray[indexPath.row][@"bid"];
    [self customPushViewController:bidDetail customNum:0];
        
    }
//
//    BidDetailsViewController * testV = [[BidDetailsViewController alloc] init];
//    testV.bidString = _accinfoArray[indexPath.row][@"bid"];
//    [self customPushViewController:testV customNum:0];
    
//    TestViewController * test = [[TestViewController alloc] init];
//    test.bidString = _accinfoArray[indexPath.row][@"bid"];
//     [self customPushViewController:test customNum:0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;//plain 1头视图
}
#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self._tableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadBidRecordData];
        });
    };
}

- (void)setupFooter {

    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self._tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadBidRecordData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
