//
//  ChangeRecordViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/10.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ChangeRecordViewController.h"
#import "ReceiveOrSendEnveloperTableViewCell.h"

@interface ChangeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger pageIndexNum;
@property (nonatomic, strong) UITableView * changeRecordListTableView;
@property (nonatomic, strong) NSMutableArray * changeRecordListArray;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end
#define ChangeRecordVCTitle @"明细"
@implementation ChangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CustomMadeNavigationControllerView *changeRecordView = [[CustomMadeNavigationControllerView alloc] initWithTitle:ChangeRecordVCTitle showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:changeRecordView];
    
    _pageIndexNum = 1;
    _changeRecordListArray = [NSMutableArray arrayWithCapacity:0];
    [self createTabeleView];
    [self setupHeader];
    [self setupFooter];
    
    if (_changeRecordListArray.count == 0) {
        [_weakRefreshHeader beginRefreshing];
    }
}

- (void)goBack{
    [self customPopViewController:0];
}

- (void)createTabeleView
{
    _changeRecordListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
    _changeRecordListTableView.delegate   = self;
    _changeRecordListTableView.dataSource = self;
    _changeRecordListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _changeRecordListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
    //    _followListTableView.separatorColor = UIColorFromRGB(0xe6e6e6);//cell 线颜色
    [self.view addSubview:_changeRecordListTableView];
}

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_changeRecordListTableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadgetCoinFlowData];
        });
    };
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_changeRecordListTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadgetCoinFlowData];
    });
}

/**
 *  零钱包交易记录接口 bid/getCoinFlow
 */
- (void)loadgetCoinFlowData
{
    NSString * startStr = [NSString stringWithFormat:@"%zd", self.pageIndexNum];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"rows" : @"10",
                                  @"start": startStr};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getCoinFlow", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadgetCoinFlowData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                [_weakRefreshHeader endRefreshing];
                NSLog(@"零钱包交易记录接口 = %@",responseObject);
                
                if (_pageIndexNum == 1) {
                    //头部刷新不能放在删除数组之后 否则直接刷新cell 崩溃
                    [_weakRefreshHeader endRefreshing];
                    if ([_changeRecordListArray count] > 0) {
                        [_changeRecordListArray removeAllObjects];
                    }
                } else {
                    [self.refreshFooter endRefreshing];
                }
                
                //给列表数组赋值
                NSArray *array = responseObject[@"data"];
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (id info in array) {
                        [_changeRecordListArray addObject:info];
                    }
                }
                
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                        [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",ChangeRecordVCTitle]];
                    }
                }
                
                if (_changeRecordListArray.count > 0) {
                    [_changeRecordListTableView reloadData];
                }else{
                    [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) contentShowString:[NSString stringWithFormat:@"暂无%@",ChangeRecordVCTitle]  MDErrorShowViewType:NoData];
                }
                
            } else {
                [_weakRefreshHeader endRefreshing];
                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)  contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
                              fail:^{
                                  [_weakRefreshHeader endRefreshing];
                                  [weakSelf initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];                              }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _changeRecordListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = _changeRecordListArray[indexPath.row];
    ReceiveOrSendEnveloperSecondTableViewCell * secondCell = [tableView dequeueReusableCellWithIdentifier:[ReceiveOrSendEnveloperSecondTableViewCell enveloperSecondTableViewCellID]];
    if (!secondCell) {
        secondCell = [ReceiveOrSendEnveloperSecondTableViewCell enveloperSecondTableViewCell];
    }
    secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
    secondCell.titleNameLab.text = [NSString stringWithFormat:@"%@",[self isLegalObject:dict[@"tradeSubName"]]?dict[@"tradeSubName"]:@"-"];
    secondCell.timeLab.text = [NSString stringWithFormat:@"%@",[self isLegalObject:dict[@"operateTime"]]?dict[@"operateTime"]:@"-"];
    
    if ([self isLegalObject:dict[@"amount"]]) {
        NSString * moneyStr = [Number3for1 formatAmount:dict[@"amount"]];
        secondCell.moneyLab.text = [NSString stringWithFormat:@"%@%@元",[dict[@"amount"] floatValue]>0?@"+":@"",moneyStr];
        
        secondCell.moneyLab.textColor =[UIColor colorWithHexString:[secondCell.titleNameLab.text isEqualToString:@"转出"]?@"333333":@"ED702E"];
    }else{
        secondCell.moneyLab.text = @"-";
        secondCell.moneyLab.textColor = [UIColor blackColor];
    }
    return secondCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ReceiveOrSendEnveloperSecondTableViewCell enveloperSecondTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
