//
//  DebtListViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "RedenveListViewController.h"
#import "SDRefresh.h"
#import "XYErrorView.h"
#import "RedenvelopeTableViewCell.h"
#import "myRedenvelopeModel.h"

@interface RedenveListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *AvailableArray;
    NSMutableArray *UsedArray;
    NSMutableArray *OverdueArray;
    long style;
}
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;//上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, copy) NSMutableArray *accinfoArray;

@end

@implementation RedenveListViewController

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
//    self._tableViewList.backgroundColor = [self colorFromHexRGB:@"F2F2F2"];
    self._tableViewList.backgroundColor = [UIColor clearColor];
    self._tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self._tableViewList];
    
    [self setupHeader];
    [self setupFooter];
}
#pragma mark - 加载我的红包数据
- (void)loadRedenvelopeData{
    NSDictionary *parameters = nil;

    if ([self.title isEqualToString:@"可用红包"]) {
        style = 2;
    }else if ([self.title isEqualToString:@"已用红包"]){
        style = 1;
    }else{// 过期红包
        style= 0;
    }

    WS(weakSelf);
    [self showWithDataRequestStatus:@"获取红包中..."];
    parameters = @{
                   @"uid":getObjectFromUserDefaults(UID),
                   @"at" :getObjectFromUserDefaults(ACCESSTOKEN),
                   @"status": [NSString stringWithFormat:@"%zd", style],
                   @"page": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                   @"rows": @"20"
                   };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/userRedCenter",GeneralWebsite] parameters:parameters success:^(id responseObject) {

        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadRedenvelopeData];
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
                    for (int i = 0; i < [array count]; i++) {
                        myRedenvelopeModel *model = [[myRedenvelopeModel alloc] initWithmyRedenvelopeModel:[array objectAtIndex:i]];
                        [_accinfoArray addObject:model];
                    }
                }
                    if ([_accinfoArray count] > 0) {
                        //移除错误界面
                        [weakSelf hideMDErrorShowView:self];
                        [weakSelf._tableViewList reloadData];
                    }else{
                        NSString * redenvelistNullStr = [NSString stringWithFormat:@"你还没有%@",self.title];
                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:redenvelistNullStr MDErrorShowViewType:NoRedenveLope];
                    }
                } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadRedenvelopeData];
                    } withFailureBlock:^{
                        
                    }];
                }else{
                    [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                    [_weakRefreshHeader endRefreshing];
                }
            }
        } fail:^{
            [weakSelf dismissWithDataRequestStatus];
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
         RedenvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RedenvelopeTableViewCell initWithRedenvelopeTableViewCellID]];
         if (cell == nil) {
             cell = [RedenvelopeTableViewCell initWithRedenvelopeTableViewCell];
         } /*else {
             //删除cell的所有子视图
             while ([cell.contentView.subviews lastObject] != nil) {
                 [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
             }
         }*/
        myRedenvelopeModel *model;
        if (_accinfoArray.count > 0) {
            model = [_accinfoArray objectAtIndex:indexPath.row];
        }
         if ([self.title isEqualToString:@"可用红包"]) {
             cell.SymbolLable.textColor = [self colorFromHexRGB:@"FA6522"];
             cell.userMoneyLable.textColor = [self colorFromHexRGB:@"FA6522"];
            
         } else if ([self.title isEqualToString:@"已用红包"]) {
             cell.contentImageview.hidden = NO;
             cell.contentImageview.image = [UIImage imageNamed:@"hasBeenUsed_image"];
         } else {
             cell.contentImageview.hidden = NO;
             cell.contentImageview.image = [UIImage imageNamed:@"outOfDate_image"];
         }
         cell.RedenvelopeName.text = model.RedenvelopeTitle;
         cell.overdueTimeLable.text = model.RedenvelopeTime;
         //    cell.minAmountLable.text = model.RedenvelopeMinAount;
         cell.userMoneyLable.text = model.RedenvelopeMoney;
         cell.deadlineLable.text = model.minDeadline;
         cell.minAmountLable.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:model.RedenvelopeMinAount]];
        // cell.belielLable.text = [NSString stringWithFormat:@"抵扣比例：%.1f%@", model.RedenvelopeMaxRatio, @"%"];//无效
    if ([model.RedenvelopeEndTime intValue] > 0 ) {
        cell.endTimeLabel.text = [NSString stringWithFormat:@"%@天",model.RedenvelopeEndTime];//有效天数
    }else {
        cell.endTimeLabel.text = @"已过";//已过有效期
    }
    
    
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return [RedenvelopeTableViewCell initWithRedenvelopeTableViewCellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
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
            [self loadRedenvelopeData];
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
        [self loadRedenvelopeData];
        [self.refreshFooter endRefreshing];

    });
}

@end
