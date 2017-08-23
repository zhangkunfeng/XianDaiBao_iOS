//
//  InvestedUserViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/3.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "InvestedUserTableViewCell.h"
#import "InvestedUserViewController.h"
#import "SDRefresh.h"
#import "investedUserModel.h"
#import "YiRefreshHeader.h"

@interface InvestedUserViewController ()

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;

@property (nonatomic, strong) YiRefreshHeader *yiRefreshHeader;

@end

@implementation InvestedUserViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"已投资用户"];
    [self hideMDErrorShowView:self];
    [self dismissWeidaiLoadAnimationView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"已投资用户"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    _pageIndexNum = 1;

//    [self setupHeaderRefresh];//实现下拉释放
//    [self setupHeader];
    [self setupFooter];
    
    _bidTenderListArray = [[NSMutableArray alloc] initWithCapacity:0];
    _langYaTopListArray = [[NSMutableArray alloc] initWithCapacity:0];

    self._tableview.tableFooterView = [[UIView alloc] init];
}

- (void)setBidTenderNumForLoadInvestUserViewController:(NSString *)bidTenderNum
{
    
}

-(void)setBidTenderNum:(NSString *)bidTenderNum{
    if (_bidTenderNum != bidTenderNum) {
        _bidTenderNum = bidTenderNum;
    }
    if ([_bidTenderNum integerValue] > 0) {
        [self loadLangyaBangData];
        [self getbidTenderList:_pageIndexNum];
    } else {
        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, Screen_Width, Screen_Height-64) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
    }
}


#pragma mark - YiRefreshHeader
- (void)setupHeaderRefresh
{
    // YiRefreshHeader  头部刷新按钮的使用
    _yiRefreshHeader=[[YiRefreshHeader alloc] init];
    _yiRefreshHeader.scrollView = self._tableview;
    [_yiRefreshHeader header];
    typeof(_yiRefreshHeader) __weak weakRefreshHeader = _yiRefreshHeader;
    _yiRefreshHeader.beginRefreshingBlock=^(){
        typeof(weakRefreshHeader) __strong strongRefreshHeader = weakRefreshHeader;
        [[NSNotificationCenter defaultCenter] postNotificationName:changeDetailContentScrollView object:nil];
        [strongRefreshHeader endRefreshing];
    };
    //    // 是否在进入该界面的时候就开始进入刷新状态
    //    [_refreshHeader beginRefreshing];
}

#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self._tableview];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadLangyaBangData];
            [self getbidTenderList:_pageIndexNum];
        });
    };
    // 进入页面自动加载一次数据
    //    [refreshHeader beginRefreshing];
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self._tableview];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getbidTenderList:_pageIndexNum];
    });
}

- (void)loadLangyaBangData
{
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"bid": _bid,};
    
    WS(weakSelf);//GeneralWebsite
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getLangYaBang",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadLangyaBangData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([self isLegalObject:responseObject[@"data"]] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *array = responseObject[@"data"];
                    NSLog(@"*******************************\n array = %@",array);

                    if (_langYaTopListArray.count > 0) {
                        [_langYaTopListArray removeAllObjects];
                    }
                    
                    if ([array count] > 0) {
                        if ([self isLegalObject:array]) {
                            for (NSDictionary *dict in array) {
                                investedUserModel *investedModel = [[investedUserModel alloc] initWithinvestedDict:dict];
                                [_langYaTopListArray addObject:investedModel];
                            }
                        }
                    }
                }
                if (_langYaTopListArray.count > 0) {
                    [self._tableview reloadData];
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }else{
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}


#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _langYaTopListArray.count;
    }
    return [_bidTenderListArray count];
}

//@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
//@property (weak, nonatomic) IBOutlet UILabel *currentTenderAmountLable;
//@property (weak, nonatomic) IBOutlet UILabel *InterestRateLable;
//@property (weak, nonatomic) IBOutlet UILabel *tenderTimeLable;
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"cell";
    InvestedUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InvestedUserTableViewCell" owner:self options:nil] lastObject];
    }
    cell.InterestRateLable.text = _InterestRate;//利率  移除

    if (indexPath.section == 0) {
        if ([_langYaTopListArray count] > 0) {
            investedUserModel *investedModel = _langYaTopListArray[indexPath.row];
            cell.investedModel = investedModel;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.investRankingImageView.image = [UIImage imageNamed:@"detail_invest_gold"];
                break;
            case 1:
                cell.investRankingImageView.image = [UIImage imageNamed:@"detail_invest_silver"];
                break;
            case 2:
                cell.investRankingImageView.image = [UIImage imageNamed:@"detail_invest_copper"];
                break;
            default:
                break;
        }
        
    }else{
        if ([_bidTenderListArray count] > 0) {
            investedUserModel *investedModel = _bidTenderListArray[indexPath.row];
            cell.investedModel = investedModel;
        }
        
        cell.investRankingImageViewLeading.constant = 0;
        cell.investRankingImageViewWidth.constant = 0;
        cell.investRankingImageViewHeight.constant = 0;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getbidTenderList:(NSInteger)pageIndexNum {
    
    NSString *bidString = @"";
    NSString *urlString = @"";
    if (self.isOptimizationBid) {
        bidString = @"apId";
        urlString = @"bidap/tenderBidList";
    } else {
        bidString = @"bid";
        urlString = @"bid/tenderBidList";
    }
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  bidString: _bid,
                                  @"page": [NSString stringWithFormat:@"%zd", pageIndexNum],
                                  @"pageSize": @"10"
    };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, urlString] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getbidTenderList:pageIndexNum];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {

                if ([self isLegalObject:responseObject[@"item"]] && [responseObject[@"item"] isKindOfClass:[NSArray class]]) {
                    if (_pageIndexNum == 1) {
                        [_weakRefreshHeader endRefreshing];
                        [_bidTenderListArray removeAllObjects];
                    } else {
                        [self.refreshFooter endRefreshing];
                    }
                    NSArray *array = responseObject[@"item"];
                    if (_pageIndexNum > 1) {
                        if ([array count] == 0) {
                            [self errorPrompt:3.0 promptStr:@"没有更多投资记录"];
                        }
                    }
                    if ([array count] > 0) {
                        if ([self isLegalObject:array]) {
                            for (NSDictionary *dict in array) {
                                investedUserModel *investedModel = [[investedUserModel alloc] initWithinvestedDict:dict];
                                [_bidTenderListArray addObject:investedModel];
                            }
                        }
                    }
                    if ([_bidTenderListArray count] > 0) {
                        [self hideMDErrorShowView:self];
                        [self._tableview reloadData];
                    }
                } else {
                    [_weakRefreshHeader endRefreshing];
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"点击刷新" MDErrorShowViewType:againRequestData];
                }
            } else {
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
        fail:^{
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
        }];
    self.view.userInteractionEnabled = YES;
}

- (void)againLoadingData {
    self.view.userInteractionEnabled = NO;
    [_weakRefreshHeader beginRefreshing];
}

- (IBAction)dismiss:(id)sender {
    [self customPopViewController:0];
}

@end
