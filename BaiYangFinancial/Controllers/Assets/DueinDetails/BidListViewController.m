//
//  BidListViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/8.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BidListViewController.h"
#import "SDRefresh.h"
#import "WaitingSubTableViewCell.h"

@interface BidListViewController ()

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, copy) NSMutableArray *accinfoArray;

@end

@implementation BidListViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
    //移除错误界面
    [self hideMDErrorShowView:self];
    //停止所有请求
    [AFNetworkTool cancelAllHTTPOperations];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //请求数据页数为1
    _pageIndexNum = 1;
    //初始化数组
    _accinfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    _tableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, iPhoneWidth, iPhoneHeight - 108) style:UITableViewStyleGrouped];
    _tableViewList.showsVerticalScrollIndicator = NO;
    _tableViewList.sectionHeaderHeight = 0;
    _tableViewList.sectionFooterHeight = 0;
    _tableViewList.scrollsToTop = NO;
    _tableViewList.delegate = self;
    _tableViewList.dataSource = self;
    _tableViewList.backgroundColor = [self colorFromHexRGB:@"F2F2F2"];
    [self.view addSubview:_tableViewList];

    [self setupHeader];
    [self setupFooter];
}
#pragma mark - 加载待收明细和已收明细的数据
- (void)loadDueinDetailsData {
    NSDictionary *parameters = nil;
    NSString *cate = @"";
    if ([self.title isEqualToString:@"待收明细"]) {
        cate = @"2";
    } else {
        cate = @"1";
    }
    parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                    @"sid": getObjectFromUserDefaults(SID),
                    @"at":  getObjectFromUserDefaults(ACCESSTOKEN),
                    @"cate": cate,
                    @"pageSize": @"20",
                    @"pageIndex": [NSString stringWithFormat:@"%zd", _pageIndexNum]
    };
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/recDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadDueinDetailsData];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadDueinDetailsData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
                [_weakRefreshHeader endRefreshing];
                if (_pageIndexNum == 1 && [_accinfoArray count] > 0) {
                    [_accinfoArray removeAllObjects];
                }
                if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSArray *array = responseObject[@"data"];
                    if (_pageIndexNum > 1) {
                        if ([array count] == 0) {
                            [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@", self.title]];
                        }
                    }
                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                        for (id info in array) {
                            [_accinfoArray addObject:info];
                        }
                    }
                    if ([_accinfoArray count] > 0) {
                        [_tableViewList reloadData];
                    } else {
                        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                    }

                } else {
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                }
            } else {
                [self dismissWithDataRequestStatus];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
                [_weakRefreshHeader endRefreshing];
            }
        }
    }
        fail:^{
            [self dismissWithDataRequestStatus];
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:errorPromptString MDErrorShowViewType:NoData];
            [_weakRefreshHeader endRefreshing];
            [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108 - 50)];

        }];
}
- (void)viewDidCurrentView {
    if ([_accinfoArray count] == 0) {
        [_weakRefreshHeader beginRefreshing];
    } else {
        [_tableViewList setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *accinfoDict = [_accinfoArray objectAtIndex:section];
    NSArray *array = [accinfoDict objectForKey:@"receiveCashVOList"];
    return [array count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _accinfoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"cell";
    WaitingSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WaitingSubTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *accinfoDict = [_accinfoArray objectAtIndex:indexPath.section];
    NSArray *array = [accinfoDict objectForKey:@"receiveCashVOList"];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    cell.recoverPeriod.text = cell.textLabel.text;
    cell.recoverPeriod.text = [NSString stringWithFormat:@"(%@/%@)", [dict objectForKey:@"recoverPeriod"], [dict objectForKey:@"borroePeriod"]];
    cell.bidNameLab.text = [dict objectForKey:@"bidName"];
    NSString *recoverPeriod = [NSString stringWithFormat:@"%@", [dict objectForKey:@"recoverPeriod"]];
    //-1 表示末
    if ([recoverPeriod isEqualToString:@"-1"]) {
        if ([self isLegalObject:dict[@"borroePeriod"]]) {
//            cell.recoverPeriod.text = [NSString stringWithFormat:@"(末/%@)", [dict objectForKey:@"borroePeriod"]];
            cell.recoverPeriod.text = @"末期本金";
        } else {
            cell.recoverPeriod.text = @"";
        }
    }
    if ([self.title isEqualToString:@"待收明细"]) {
        if ([self isLegalObject:dict[@"recoverAmonut"]]) {
            //待收明细
//            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"recoverAmonut"] doubleValue]];
            cell.priceLabel.text = [Number3for1 formatAmount:[dict objectForKey:@"recoverAmonut"]];
        } else {
            cell.priceLabel.text = @"";
        }
    } else {
        if ([self isLegalObject:dict[@"recoveredAmonut"]]) {
            //已收明细
//            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [dict[@"recoveredAmonut"] doubleValue]];
            cell.priceLabel.text = [Number3for1 formatAmount:dict[@"recoveredAmonut"]];
        } else {
            cell.priceLabel.text = @"";
        }
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.bottomLine.hidden = NO;
    //分割线顶格
    [self setCellSeperatorToLeft:cell];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}
//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
//section尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *accinfoDict = [_accinfoArray objectAtIndex:section];
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.backgroundColor = [UIColor whiteColor];
    timeLable.text = [NSString stringWithFormat:@"  日期  %@", [accinfoDict objectForKey:@"time"]];
    timeLable.textColor = [UIColor colorWithRed:58 / 255.0 green:58 / 255.0 blue:58 / 255.0 alpha:1.0];
    timeLable.textAlignment = NSTextAlignmentLeft;
    timeLable.font = [UIFont systemFontOfSize:12];
    timeLable.backgroundColor = [UIColor colorWithHexString:@"98bef9"];
    return timeLable;
}
//section尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    ;
    [self.view addSubview:view];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_tableViewList];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadDueinDetailsData];
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
        [self loadDueinDetailsData];
        [self.refreshFooter endRefreshing];
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
