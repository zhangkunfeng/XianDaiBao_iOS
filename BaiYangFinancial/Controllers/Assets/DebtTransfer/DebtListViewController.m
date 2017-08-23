//
//  DebtListViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "DebtListViewController.h"
#import "DueinTableViewCell.h"
#import "TransferTableViewCell.h"
#import "TransferButtonViewController.h"
#import "SDRefresh.h"

@interface DebtListViewController ()

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;//上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, copy) NSMutableArray *accinfoArray;

@end

@implementation DebtListViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
    //移除错误界面
    [self hideMDErrorShowView:self];
    [AFNetworkTool cancelAllHTTPOperations];
}
- (void)viewWillAppear:(BOOL)animated{
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
    
    self._tableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108 ) style:UITableViewStylePlain];
    self._tableViewList.showsVerticalScrollIndicator = NO;
    self._tableViewList.tableFooterView=[[UIView alloc]init];
    self._tableViewList.scrollsToTop = NO;
    self._tableViewList.delegate = self;
    self._tableViewList.dataSource = self;
    self._tableViewList.backgroundColor = [self colorFromHexRGB:@"F2F2F2"];
    [self.view addSubview:self._tableViewList];
    
    [self setupHeader];
    [self setupFooter];
}

#pragma mark - 加载债权转让数据
- (void)loadDebtTransferData{
    NSString *requestStr = @"";
    NSDictionary *parameters = nil;
    if ([self.title isEqualToString:@"可转让债权"]) {
        requestStr = @"phone/myCollectedBid";
    }else if ([self.title isEqualToString:@"转让债权"]){
        requestStr = @"phone/mySecondhandBidList";
    }else{
        requestStr = @"phone/myUndertakeList";
    }
    parameters = @{
                   @"uid":           getObjectFromUserDefaults(UID),
                   @"at" :           getObjectFromUserDefaults(ACCESSTOKEN),
                   @"pageSize":      @"10",
                   @"pageIndex":     [NSString stringWithFormat:@"%zd",_pageIndexNum],
                   };
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@",GeneralWebsite,requestStr] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadDebtTransferData];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self dismissWithDataRequestStatus];
                [_weakRefreshHeader endRefreshing];
                //移除错误界面
                [weakSelf hideMDErrorShowView:self];
                if (_pageIndexNum == 1 && [_accinfoArray count] > 0) {
                    [_accinfoArray removeAllObjects];
                }
                NSArray *array = responseObject[@"data"];
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                        [weakSelf errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",weakSelf.title]];
                    }
                }
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (id info in array) {
                        [_accinfoArray addObject:info];
                    }
                }
                if ([_accinfoArray count] > 0) {
                    //移除错误界面
                    [weakSelf hideMDErrorShowView:self];
                    [weakSelf._tableViewList reloadData];
                }else{
                    [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:@"暂无数据,点击刷新" MDErrorShowViewType:againRequestData];
                }
            }else{
                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                [_weakRefreshHeader endRefreshing];
            }
        }
    } fail:^{
        [self dismissWithDataRequestStatus];
        [_weakRefreshHeader endRefreshing];
        [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108)];
    }];
}

- (void)viewDidCurrentView
{
    if ([_accinfoArray count] == 0) {
        [_weakRefreshHeader beginRefreshing];
    }else{
        [self._tableViewList setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - MDErrorShowViewDelegate
- (void)againLoadingData{
    //移除错误界面
    [self hideMDErrorShowView:self];
    [self performSelector:@selector(viewDidCurrentView) withObject:nil afterDelay:0.3f];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _accinfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Identifier=@"cell";
    NSDictionary *accinfoDict = nil;
    if ([_accinfoArray count] > 0) {
         accinfoDict = [_accinfoArray objectAtIndex:indexPath.row];
    }
    if ([self.title isEqualToString:@"可转让债权"]){
        DueinTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil)
        {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"DueinTableViewCell" owner:self options:nil] lastObject];
        }
        //可转让债权数据
        if ([self isLegalObject:accinfoDict[@"bidName"]]) {
            cell.bidName.text = accinfoDict[@"bidName"];
        }else{
            cell.bidName.text = @"";
        }
        if ([self isLegalObject:accinfoDict[@"recoverTimeShow"]]) {
           cell.recoverTimeShow.text = accinfoDict[@"recoverTimeShow"];
        }else{
            cell.recoverTimeShow.text = @"";
        }
        if ([self isLegalObject:accinfoDict[@"restPeriods"]]) {
           cell.recoverPeriod.text = [NSString stringWithFormat:@"%@期",accinfoDict[@"restPeriods"]];
        }else{
            cell.recoverPeriod.text = @"";
        }
        if ([self isLegalObject:accinfoDict[@"recoverAmonut"]]) {
//            cell.recoverAmonut.text = [NSString stringWithFormat:@"%.2f元",[accinfoDict[@"recoverAmonut"] doubleValue]];
            cell.recoverAmonut.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:accinfoDict[@"recoverAmonut"]]];
        }else{
            cell.recoverAmonut.text = @"";
        }
        [cell.transferBtn addTarget:self action:@selector(tansferBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.transferBtn.tag = indexPath.row;
        [self setCellSeperatorToLeft:cell];
        return cell;

    }else{
        TransferTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil)
        {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"TransferTableViewCell" owner:self options:nil] lastObject];
        }
         //转让债权、承接债权数据
        if ([self.title isEqualToString:@"转让债权"]) {
            if ([self isLegalObject:accinfoDict[@"title"]]) {
                cell.bidName.text=[accinfoDict objectForKey:@"title"];
            }else{
                cell.bidName.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"transferPrice"]]) {
//               cell.transferPrice.text=[NSString stringWithFormat:@"%.2f元",[[accinfoDict objectForKey:@"transferPrice" ] doubleValue]];
                cell.transferPrice.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:[accinfoDict objectForKey:@"transferPrice"]]];
            }else{
                cell.transferPrice.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"recoverCapital"]]) {
               cell.recover_capital.text=[NSString stringWithFormat:@"%.2f元",[[accinfoDict objectForKey:@"recoverCapital" ] doubleValue]];
            }else{
                cell.recover_capital.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"recoverPeriod"]]) {
               cell.recoverPeriod.text=[NSString stringWithFormat:@"%@期",[accinfoDict objectForKey:@"recoverPeriod"]];
            }else{
                cell.recoverPeriod.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"receiveTime"]]) {
                cell.acceptTimeShow.text=[NSString stringWithFormat:@"%@",[accinfoDict objectForKey:@"receiveTime"]];
 
            }else{
                cell.acceptTimeShow.text = @"";
            }
            if (iOS9) {
                cell.timeWidthConstraint.constant = 90;
            }
        }else{
            
            cell.transferOrWaitingMoneyDescLabel.text = @"待收总额:";
            if ([self isLegalObject:accinfoDict[@"title"]]) {
                cell.bidName.text=[accinfoDict objectForKey:@"title"];
            }else{
                cell.bidName.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"transferPrice"]]) {
//               cell.transferPrice.text=[NSString stringWithFormat:@"%.2f元",[[accinfoDict objectForKey:@"transferPrice" ] doubleValue]];
                 cell.transferPrice.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:[accinfoDict objectForKey:@"transferPrice"]]];
            }else{
                cell.transferPrice.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"recoverAmonut"]]) {
//                cell.recover_capital.text=[NSString stringWithFormat:@"%.2f元",[[accinfoDict objectForKey:@"recoverAmonut" ] doubleValue]];
                cell.recover_capital.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:[accinfoDict objectForKey:@"recoverAmonut"]]];
            }else{
                cell.recover_capital.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"recoverPeriod"]]) {
                cell.recoverPeriod.text=[NSString stringWithFormat:@"%@期",[accinfoDict objectForKey:@"recoverPeriod"]];
            }else{
                cell.recoverPeriod.text = @"";
            }
            if ([self isLegalObject:accinfoDict[@"acceptTime"]]) {
               cell.acceptTimeShow.text=[NSString stringWithFormat:@"%@",[accinfoDict objectForKey:@"acceptTime"]];
            }else{
                cell.acceptTimeShow.text = @"";
            }
        }
        [self setCellSeperatorToLeft:cell];
        return cell;
    }
    return nil;
}

//TODO:转让按钮的点击事件
- (void)tansferBtnClick:(UIButton*)btn{
    
//    UIButton *btn = (UIButton *)sender;
    NSDictionary *dict = [_accinfoArray objectAtIndex:btn.tag];
    TransferButtonViewController *transferVc=[[TransferButtonViewController alloc] initWithNibName:@"TransferButtonViewController" bundle:nil];
    transferVc.isbackRefresh = ^(BOOL isRefersh){
        if (isRefersh) {
            [self viewDidCurrentView];
        }
    };
    if ([self isLegalObject:[dict objectForKey:@"bid"]]) {
        transferVc.transferbidID = [NSString stringWithFormat:@"%zd",[[dict objectForKey:@"bid"] integerValue]];
    }else{
        transferVc.transferbidID = @"";
    }
    [self customPushViewController:transferVc customNum:0];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -----  上下拉加载  ------
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self._tableViewList];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadDebtTransferData];
        });
    };
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self._tableViewList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDebtTransferData];
        [self.refreshFooter endRefreshing];

    });
}

@end
