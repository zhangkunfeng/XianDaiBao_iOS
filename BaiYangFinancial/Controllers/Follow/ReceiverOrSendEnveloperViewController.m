//
//  ReceiverOrSendEnveloperViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ReceiverOrSendEnveloperViewController.h"
#import "ReceiveOrSendEnveloperTableViewCell.h"
#import "SDRefresh.h"

@interface ReceiverOrSendEnveloperViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger pageIndexNum;
@property (nonatomic, strong) UITableView * enveloperListTableView;
@property (nonatomic, strong) NSMutableArray * enveloperListArray;
@property (nonatomic, strong) NSDictionary * enveloperListDict;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation ReceiverOrSendEnveloperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomMadeNavigationControllerView *addressBookView = [[CustomMadeNavigationControllerView alloc] initWithTitle:self.titleStr showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:addressBookView];
        
    _pageIndexNum = 1;
    _enveloperListArray = [NSMutableArray arrayWithCapacity:0];
    _enveloperListDict  = [NSDictionary dictionary];
    
    [self createTabeleView];
    [self setupHeader];
    [self setupFooter];
    if (_enveloperListArray.count == 0) {
        [_weakRefreshHeader beginRefreshing];
    }
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack{
    [self customPopViewController:0];
}

- (void)createTabeleView
{
    _enveloperListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
    _enveloperListTableView.delegate   = self;
    _enveloperListTableView.dataSource = self;
     _enveloperListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _enveloperListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
    //    _followListTableView.separatorColor = UIColorFromRGB(0xe6e6e6);//cell 线颜色
    [self.view addSubview:_enveloperListTableView];
}

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_enveloperListTableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadEnveloperRecordData];
        });
    };
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_enveloperListTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadEnveloperRecordData];
    });
}

/**
 *  收到红包/发送红包 接口
 */
- (void)loadEnveloperRecordData
{
    NSString *requestStr = @"";
    NSString *recSendUid = @"";
    NSString * startStr = [NSString stringWithFormat:@"%zd", self.pageIndexNum];
    if ([self.titleStr isEqualToString:@"收到的红包"]) {
        requestStr = @"user/getRecFriendRedpacket";
        recSendUid = @"receiveUid";
    } else {
        requestStr = @"user/getSendFriendRedpacket";
        recSendUid = @"sendUid";
    }
    
    NSDictionary *parameters = @{@"sid": getObjectFromUserDefaults(SID),
                                 @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
                                 recSendUid: getObjectFromUserDefaults(UID),
                                 @"rows" : @"10",
                                 @"start": startStr};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite,requestStr] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadEnveloperRecordData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            NSLog(@"%@接口返回数据 = %@",self.titleStr,responseObject);
            [self hideMDErrorShowView:self];
            
            if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]] && [self isLegalObject:responseObject[@"item"]]) {
                _enveloperListDict = [responseObject[@"item"] copy];
            }
            
            if (_pageIndexNum == 1) {
                //头部刷新不能放在删除数组之后 否则直接刷新cell 崩溃
                [_weakRefreshHeader endRefreshing];
                if ([_enveloperListArray count] > 0) {
                    [_enveloperListArray removeAllObjects];
                }
            } else {
                [self.refreshFooter endRefreshing];
            }
            
            //给列表数组赋值
            NSArray *array = responseObject[@"data"];
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (id info in array) {
                    [_enveloperListArray addObject:info];
                }
            }
            
            if (_pageIndexNum > 1) {
                if ([array count] == 0) {
                    [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",self.titleStr]];
                }
            }
            
            if (_enveloperListArray.count > 0) {
                [_enveloperListTableView reloadData];
            }else{
                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) contentShowString:[NSString stringWithFormat:@"暂无%@记录",self.titleStr]  MDErrorShowViewType:NoData];
            }
            
        } else {
            [_weakRefreshHeader endRefreshing];
            [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)  contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
        }
    }
     
                              fail:^{
                                  [_weakRefreshHeader endRefreshing];
                                  [weakSelf initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];
                              }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:_enveloperListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReceiveOrSendEnveloperFirstTableViewCell * firstCell = [tableView dequeueReusableCellWithIdentifier:[ReceiveOrSendEnveloperFirstTableViewCell enveloperFirstTableViewCellID]];
        if (!firstCell) {
            firstCell = [ReceiveOrSendEnveloperFirstTableViewCell enveloperFirstTableViewCell];
        }
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        firstCell.titleDescLab.text = [self.titleStr isEqualToString:@"收到的红包"]?@"累计收到":@"累计发出";
        firstCell.enveloperAmoutLab.text = [Number3for1 formatAmount:[self isLegalObject:_enveloperListDict[@"amount"]]?_enveloperListDict[@"amount"]:@"-"];
        firstCell.enveloperNumLab.text = [NSString stringWithFormat:@"%@红包总数%@个",[self.titleStr isEqualToString:@"收到的红包"]?@"收到":@"发出",[self isLegalObject:_enveloperListDict[@"redPacketNum"]]?_enveloperListDict[@"redPacketNum"]:@"-"];
        
        return firstCell;
    }else{
        NSDictionary * dict = _enveloperListArray[indexPath.row];
        ReceiveOrSendEnveloperSecondTableViewCell * secondCell = [tableView dequeueReusableCellWithIdentifier:[ReceiveOrSendEnveloperSecondTableViewCell enveloperSecondTableViewCellID]];
        if (!secondCell) {
            secondCell = [ReceiveOrSendEnveloperSecondTableViewCell enveloperSecondTableViewCell];
        }
        secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        secondCell.titleNameLab.text = [NSString stringWithFormat:@"%@",[self isLegalObject:dict[@"title"]]?dict[@"title"]:@"-"];
        secondCell.timeLab.text = [NSString stringWithFormat:@"%@",[self isLegalObject:dict[@"getTimeStr"]]?dict[@"getTimeStr"]:@"-"];
        
        if ([self isLegalObject:dict[@"amount"]]) {
           secondCell.moneyLab.text =  [NSString stringWithFormat:@"%@元",  [Number3for1 formatAmount:dict[@"amount"]]];
        }else{
            secondCell.moneyLab.text = @"-";
        }
            
        return secondCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0?
    [ReceiveOrSendEnveloperFirstTableViewCell enveloperFirstTableViewCellHeight]:
    [ReceiveOrSendEnveloperSecondTableViewCell enveloperSecondTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
