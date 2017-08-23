//
//  WDArdawRecordsViewController.m
//  weidaitest
//
//  Created by yaoqi on 16/3/17.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import "CustomMadeNavigationControllerView.h"
#import "Masonry.h"
#import "WDArdawRecordsTableViewCell.h"
#import "WDArdawRecordsViewController.h"
#import "WDMyFewardModel.h"

static NSString *const cellReuseIdentifier = @"WDArdawRecordsTableViewCell";

@interface WDArdawRecordsViewController () <UITableViewDataSource, UITableViewDelegate, CustomUINavBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, assign) NSInteger pageIndexNum;
@property (nonatomic, strong) WDMyFewardModel *myFewardModel;
@property (nonatomic, strong) NSMutableArray<WDMyFewardDataModel *> *dataArray;
@property (nonatomic, strong) SDRefreshHeaderView *refreshHeader;
@property (strong, nonatomic) SDRefreshFooterView *refreshFooterView;

@end

@implementation WDArdawRecordsViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = AppViewBackGroundColor;

    self.pageIndexNum = 1;
    self.dataArray = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];

//    CustomMadeNavigationControllerView *RecordsView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"理财师奖励记录" showBackButton:YES showRightButton:YES rightButtonTitle:@"规则" target:self];
    CustomMadeNavigationControllerView *RecordsView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"理财师奖励记录" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:RecordsView];

    self.myTableView.rowHeight = 95.f;
    self.myTableView.tableFooterView = [[UIView alloc] init];
    [self.myTableView registerNib:[UINib nibWithNibName:cellReuseIdentifier bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];

    [self queryMyFewardRecords];

    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.myTableView];
    self.refreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pageIndexNum = 1;
            [self.dataArray removeAllObjects];
            [self queryMyFewardRecords];
        });
    };
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.myTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooterView = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryMyFewardRecords];
        [_refreshFooterView endRefreshing];
    });
}

#pragma mark - HTTP
- (void)queryMyFewardRecords {
    [self showWithDataRequestStatus:@"正在加载数据..."];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"page": [NSString stringWithFormat:@"%zd", self.pageIndexNum],
                                  @"rows": @"10",
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/myIncomeRecord", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        [self.refreshHeader endRefreshing];
        [self dismissWithDataRequestStatus];
        self.myFewardModel = [[WDMyFewardModel alloc] initWithDictionary:responseObject];
        if (self.myFewardModel.r_status == WDModelSuccess) {
            if (self.pageIndexNum == 1) {
                self.dataArray = self.myFewardModel.dataArray;
            } else {
                for (int i = 0; i < [self.myFewardModel.dataArray count]; i++) {
                    [self.dataArray addObject:[self.myFewardModel.dataArray objectAtIndex:i]];
                }
            }
            NSLog(@"queryMyFewardRecords===%lu", (unsigned long) self.dataArray.count);
        } else {
            [self errorPrompt:2.0 promptStr:errorPromptString];
        }
        [self.myTableView reloadData];
    }
        fail:^{
            [self.refreshHeader endRefreshing];
            [self errorPrompt:2.0 promptStr:errorPromptString];
        }];
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack {
    [self customPopViewController:0];
}

- (void)doOption {
    [self jumpToWebview:@"http://mp.weixin.qq.com/s?__biz=MjM5ODA2NzU5Mg==&mid=405650171&idx=1&sn=1b750f5c7fd17f48b3e68d14959aa92a#rd" webViewTitle:@"理财师规则"];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //容器视图
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:246 / 255.0 alpha:1.0];

    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];

    UILabel *totalRecommendedLabel = [[UILabel alloc] init];
    [totalRecommendedLabel setText:@"理财师奖励收益"];
    [totalRecommendedLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [totalRecommendedLabel sizeToFit];
    [whiteView addSubview:totalRecommendedLabel];
    [totalRecommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.centerY.equalTo(whiteView.mas_centerY);
    }];

    UILabel *totalRecommendedCountLabel = [[UILabel alloc] init];
    [totalRecommendedCountLabel setText:[NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:[NSString stringWithFormat:@"%.2f", [self.myFewardModel.allAmount doubleValue]]]]];
    [totalRecommendedCountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [totalRecommendedCountLabel sizeToFit];
    [totalRecommendedCountLabel setTextColor:AppTextColor];
    [whiteView addSubview:totalRecommendedCountLabel];
    [totalRecommendedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalRecommendedLabel.mas_trailing).offset(10);
        make.centerY.equalTo(totalRecommendedLabel.mas_centerY);
    }];

    UILabel *recommendedListLabel = [[UILabel alloc] init];
    [recommendedListLabel setText:@"符合返利奖励的收益纪录"];
    [recommendedListLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [recommendedListLabel sizeToFit];
    [recommendedListLabel setTextColor:[UIColor lightGrayColor]];
    [containerView addSubview:recommendedListLabel];
    [recommendedListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_bottom).offset(5);
        make.leading.equalTo(totalRecommendedLabel.mas_leading);
    }];

    UILabel *recommendedListCountLabel = [[UILabel alloc] init];
    [recommendedListCountLabel setText:[NSString stringWithFormat:@"%zd条", [self.myFewardModel.total integerValue]]];
    [recommendedListCountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [recommendedListCountLabel sizeToFit];
    [recommendedListCountLabel setTextColor:AppTextColor];
    [containerView addSubview:recommendedListCountLabel];
    [recommendedListCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(recommendedListLabel.mas_trailing).offset(10);
        make.centerY.equalTo(recommendedListLabel.mas_centerY);
    }];

    return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDArdawRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        WDMyFewardDataModel *myFewardDataModel = self.dataArray[indexPath.row];
        cell.phoneLabel.text = myFewardDataModel.mobile;
        cell.timeLabel.text = [NSString stringWithFormat:@"奖励时间:%@", myFewardDataModel.regTime];
        cell.investmentPriceLabel.text = [NSString stringWithFormat:@"收益%@元",[Number3for1 formatAmount: [NSString stringWithFormat:@"%@",myFewardDataModel.amount]]];
        cell.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", [myFewardDataModel.percent doubleValue] * 100];
        cell.priceLabel.text =[NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:[NSString stringWithFormat:@"%.2f", [myFewardDataModel.amount doubleValue] * [myFewardDataModel.percent doubleValue]]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
