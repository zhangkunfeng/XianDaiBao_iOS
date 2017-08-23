//
//  RecordListViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "RecordListViewController.h"
#import "RecordTableViewCell.h"
#import "SDRefresh.h"
#import "WDCancelWithdrawView.h"
#import "AllRecordTableViewCell.h"

@interface RecordListViewController ()

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter; //上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, copy) NSMutableArray *accinfoArray;
@property (nonatomic, copy) NSIndexPath *indexPathRow;

@end

@implementation RecordListViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
    //移除错误界面
    [self hideMDErrorShowView:self];
    [AFNetworkTool cancelAllHTTPOperations];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self forbiddenSideBack];
    [self talkingDatatrackPageBegin:self.title];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self resetSideBack];
    //请求数据页数为1
    _pageIndexNum = 1;
    //初始化数组
    _accinfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    _tableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) style:UITableViewStylePlain];

    _tableViewList.showsVerticalScrollIndicator = NO;
    _tableViewList.tableFooterView = [[UIView alloc] init];
    _tableViewList.scrollsToTop = NO;
    _tableViewList.delegate = self;
    _tableViewList.dataSource = self;
    _tableViewList.backgroundColor = [self colorFromHexRGB:@"F2F2F2"];
    [self.view addSubview:_tableViewList];

    [self setupHeader];
    [self setupFooter];
}

#pragma mark - Action
- (void)cancelButtonAction:(id)sender {
    [[WDCancelWithdrawView shareCanceWithdrawView] showCancelWithdrawViewWithsureButtonTapped:^{
        [self cancelWithdraw];
    }];
}

#pragma mark - HTTP(加载充值/记录数据)
- (void)cancelWithdraw {
    [self showWithDataRequestStatus:@"取消中"];
    NSDictionary *parameters = @{ @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"id": _accinfoArray[self.indexPathRow.row][@"id"] };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@account/cancelWithdraw", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            RecordTableViewCell *cell = [self.tableViewList cellForRowAtIndexPath:self.indexPathRow];
            cell.tradeState.text = @"已撤销";
            cell.cancelButton.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:SendToMyAssets object:nil];
        } else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf cancelWithdraw];
        } withFailureBlock:^{
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf cancelWithdraw];
                } withFailureBlock:^{
                    
                }];
        }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            
        } else {
            [self errorPrompt:3.0f promptStr:responseObject[@"msg"]];
        }
    }
        fail:^{
            [self dismissWithDataRequestStatus];
            [self errorPrompt:3.0f promptStr:errorPromptString];
        }];
}

- (void)loadRecordData {
    NSString *requestStr = @"";
    if ([self.title isEqualToString:@"全部记录"]) {
        requestStr = @"user/flowList";
    }else if ([self.title isEqualToString:@"充值记录"]){
        requestStr = @"account/rechargeRecord";
    }else {
        requestStr = @"account/myWithdrawRecord";
    }
    NSDictionary *parameters = @{
        @"uid": getObjectFromUserDefaults(UID),
        @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
        @"sid": getObjectFromUserDefaults(SID),
        @"pageSize" : @"10",
        @"pageIndex": [NSString stringWithFormat:@"%zd", _pageIndexNum],
    };
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, requestStr] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadRecordData];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
                //移除错误界面
                [self hideMDErrorShowView:self];
                if (_pageIndexNum == 1) {
                    [_weakRefreshHeader endRefreshing];
                    if (_accinfoArray.count > 0) {
                        [_accinfoArray removeAllObjects];
                    }
                } else {
                    [self.refreshFooter endRefreshing];
                }
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
                    //移除错误界面
                    [self hideMDErrorShowView:self];
                    [_tableViewList reloadData];
                } else {
                    [_weakRefreshHeader endRefreshing];
                    [self dismissWithDataRequestStatus];
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:[NSString stringWithFormat:@"暂无%@", self.title] MDErrorShowViewType:NoData];
                }
            } else {
                [_weakRefreshHeader endRefreshing];
                 [self dismissWithDataRequestStatus];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
        fail:^{
            [_weakRefreshHeader endRefreshing];
            [self dismissWithDataRequestStatus];
            [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108)];
        }];
}

- (void)viewDidCurrentView {
    if ([_accinfoArray count] == 0) {
        [_weakRefreshHeader beginRefreshing];
    } else {
        [_tableViewList setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _accinfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *accinfoDict = [_accinfoArray objectAtIndex:indexPath.row];

    if ([self.title isEqualToString:@"全部记录"]) {
        AllRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AllRecordTableViewCell allRecordTableViewCellID]];
        if (!cell) {
            cell = [AllRecordTableViewCell allRecordTableViewCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleNameLab.text = [NSString stringWithFormat:@"%@",[self isLegalObject:accinfoDict[@"tradeSubName"]]?accinfoDict[@"tradeSubName"]:@"-"];
        
        cell.timeLab.text = [NSString stringWithFormat:@"%@",[self isLegalObject:accinfoDict[@"operateTime"]]?accinfoDict[@"operateTime"]:@"-"];
        
        if ([self isLegalObject:accinfoDict[@"amount"]]) {
            NSString * moneyStr = [Number3for1 formatAmount:accinfoDict[@"amount"]];
            cell.moneyLab.text = [accinfoDict[@"amount"] floatValue]>0?[NSString stringWithFormat:@"%@%@",@"+",moneyStr]:moneyStr;
            cell.moneyLab.textColor =[UIColor colorWithHexString:[moneyStr floatValue]>0?@"ED702E":@"333333"];
        }else{
            cell.moneyLab.text = @"-";
            cell.moneyLab.textColor = [UIColor blackColor];
        }
        
        return cell;
        
    }else{
        static NSString *Identifier = @"cell";
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.title isEqualToString:@"充值记录"]) {
            if ([self isLegalObject:accinfoDict[@"amount"]]) {
                //            cell.amount.text = [NSString stringWithFormat:@"%.2f元", [accinfoDict[@"amount"] doubleValue]];
                cell.amount.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:accinfoDict[@"amount"]]];
            } else {
                cell.amount.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"tradeState"]]) {
                cell.tradeState.text = accinfoDict[@"tradeState"];
                if ([cell.tradeState.text isEqualToString:@"处理中"]) {
                    cell.tradeState.textColor = RGB(159, 159, 159);
                }
                if ([cell.tradeState.text isEqualToString:@"成功"]) {
                    cell.tradeState.textColor = RGB(94, 202, 178);
                }
            } else {
                cell.tradeState.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"operateTimeShow"]]) {
                cell.operateTime.text = accinfoDict[@"operateTimeShow"];
            } else {
                cell.operateTime.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"submitTimeShow"]]) {
                cell.submittime.text = accinfoDict[@"submitTimeShow"];
            } else {
                cell.submittime.text = @"";
            }
        } else {
            if ([accinfoDict[@"isCanRevoke"] integerValue] == 1) {
                self.indexPathRow = indexPath;
                cell.cancelButton.hidden = NO;
                [cell.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if ([self isLegalObject:accinfoDict[@"amount"]]) {
                //            cell.amount.text = [NSString stringWithFormat:@"%.2f元", [accinfoDict[@"amount"] doubleValue]];
                cell.amount.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:accinfoDict[@"amount"]]];
                
            } else {
                cell.amount.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"tradeState"]]) {
                cell.tradeState.text = accinfoDict[@"tradeState"];
                if ([cell.tradeState.text isEqualToString:@"处理中"]) {
                    cell.tradeState.textColor = RGB(159, 159, 159);
                }
                if ([cell.tradeState.text isEqualToString:@"成功"]) {
                    cell.tradeState.textColor = RGB(94, 202, 178);
                }
                
            } else {
                cell.tradeState.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"operateTime"]]) {
                cell.operateTime.text = accinfoDict[@"operateTime"];
            } else {
                cell.operateTime.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"submitTime"]]) {
                cell.submittime.text = accinfoDict[@"submitTime"];
            } else {
                cell.submittime.text = @"";
            }
        }
        [self setCellSeperatorToLeft:cell];
        return cell;
    }
    
    return nil;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.title isEqualToString:@"全部记录"]?65:70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.tableViewList];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadRecordData];
        });
    };
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableViewList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadRecordData];
        [self.refreshFooter endRefreshing];
    });
}
@end
