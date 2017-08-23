//
//  WDInviteUsersViewController.m
//  weidaitest
//
//  Created by yaoqi on 16/3/16.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import "CustomMadeNavigationControllerView.h"
#import "Masonry.h"
#import "WDInviteUsersModel.h"
#import "WDInviteUsersTableViewCell.h"
#import "WDInviteUsersViewController.h"

static NSString *const cellReuseIdentifier = @"WDInviteUsersTableViewCell";

@interface WDInviteUsersViewController () <UITableViewDataSource, UITableViewDelegate, CustomUINavBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) WDInviteUsersModel *invitateFriendsModel;

@property (nonatomic, strong) SDRefreshHeaderView *refreshHeader;

@property (strong, nonatomic) SDRefreshFooterView *refreshFooterView;

@property (strong, nonatomic) NSMutableArray<recommendFriendsListModel *> *dataArray;

@property (assign, nonatomic) NSInteger pageIndexNum;

@end

@implementation WDInviteUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppViewBackGroundColor;

//    CustomMadeNavigationControllerView *UsersView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"我邀请的用户" showBackButton:YES showRightButton:YES rightButtonTitle:@"规则" target:self];
    CustomMadeNavigationControllerView *UsersView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"我邀请的好友" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:UsersView];

    self.dataArray = [NSMutableArray array];
    self.pageIndexNum = 1;
    [self getData];

    self.myTableView.rowHeight = 80.f;
    self.myTableView.tableFooterView = [[UIView alloc] init];
    [self.myTableView registerNib:[UINib nibWithNibName:cellReuseIdentifier bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];

    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.myTableView];
    self.refreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pageIndexNum = 1;
            if (self.invitateFriendsModel) {
                [self.invitateFriendsModel.recommendFriendsList removeAllObjects];
            }
            [self getData];
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
        [self getData];
        [_refreshFooterView endRefreshing];
    });
}

#pragma mark - getData
- (void)getData {
    [self showWithDataRequestStatus:@"正在加载数据"];
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"page": [NSString stringWithFormat:@"%zd", self.pageIndexNum],
                                  @"rows": @"10",
    };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/myTj", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        [self.refreshHeader endRefreshing];
        [self dismissWithDataRequestStatus];
        if (responseObject) {
            self.invitateFriendsModel = [[WDInviteUsersModel alloc] initWithDictionary:responseObject];
            if (self.invitateFriendsModel.r_status == WDModelSuccess) {
                if (self.pageIndexNum == 1) {
                    self.dataArray = self.invitateFriendsModel.recommendFriendsList;
                } else {
                    for (int i = 0; i < [self.invitateFriendsModel.recommendFriendsList count]; i++) {
                        [self.dataArray addObject:[self.invitateFriendsModel.recommendFriendsList objectAtIndex:i]];
                    }
                }
                [self.myTableView reloadData];
            } else if (self.invitateFriendsModel.r_status == WDModelTokenExpire) {
               [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                   [weakSelf getData];
        } withFailureBlock:^{
            
        }];
            } else if (self.invitateFriendsModel.r_status == WDModelSidExpire) {[[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getData];
                } withFailureBlock:^{
                    
                }];
                
            } else {
                [self errorPrompt:3.0 promptStr:self.invitateFriendsModel.msg];
            }
        }
    }
        fail:^{
            [self.refreshHeader endRefreshing];
            [self errorPrompt:3.0 promptStr:errorPromptString];
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
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
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
    [totalRecommendedLabel setText:@"累计推荐"];
    [totalRecommendedLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [totalRecommendedLabel sizeToFit];
    [whiteView addSubview:totalRecommendedLabel];
    [totalRecommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(40);
        make.centerY.equalTo(whiteView.mas_centerY).offset(-5);
    }];

    UILabel *totalRecommendedCountLabel = [[UILabel alloc] init];
    [totalRecommendedCountLabel setText:[NSString stringWithFormat:@"%zd人", [self.invitateFriendsModel.recommendCount integerValue]]];
    [totalRecommendedCountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [totalRecommendedCountLabel sizeToFit];
    [totalRecommendedCountLabel setTextColor:AppTextColor];
    [whiteView addSubview:totalRecommendedCountLabel];
    [totalRecommendedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalRecommendedLabel.mas_trailing).offset(10);
        make.centerY.equalTo(totalRecommendedLabel.mas_centerY);
    }];

    UILabel *effectiveFriendsLabel = [[UILabel alloc] init];
    [effectiveFriendsLabel setText:@"有效好友"];
    [effectiveFriendsLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [effectiveFriendsLabel sizeToFit];
    [whiteView addSubview:effectiveFriendsLabel];

    UILabel *effectiveFriendsCountLabel = [[UILabel alloc] init];
    [effectiveFriendsCountLabel setText:[NSString stringWithFormat:@"%zd人", [self.invitateFriendsModel.successrecommenCount integerValue]]];
    [effectiveFriendsCountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [effectiveFriendsCountLabel sizeToFit];
    [effectiveFriendsCountLabel setTextColor:AppTextColor];
    [whiteView addSubview:effectiveFriendsCountLabel];

    [effectiveFriendsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(whiteView.mas_trailing).offset(-40);
        make.centerY.equalTo(effectiveFriendsLabel.mas_centerY);
    }];

    [effectiveFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(effectiveFriendsCountLabel.mas_leading).offset(-10);
        make.centerY.equalTo(whiteView.mas_centerY).offset(-5);
    }];

    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = RGB(240, 242, 246);
    [whiteView addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView.mas_bottom).offset(0);
        make.width.mas_equalTo(iPhoneWidth);
        make.height.mas_equalTo(10);
    }];
    
//    UILabel * bottomLineLabel = [[UILabel alloc] init];
//    bottomLineLabel.backgroundColor = [UIColor lightGrayColor];
//    [whiteView addSubview:bottomLineLabel];
//    
//    [bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(whiteView.mas_bottom).offset(0.5);
//        make.width.mas_equalTo(iPhoneWidth);
//        make.height.mas_equalTo(0.5);
//    }];
    
    /*
    UILabel *recommendedListLabel = [[UILabel alloc] init];
    [recommendedListLabel setText:@"推荐列表"];
    [recommendedListLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [recommendedListLabel sizeToFit];
    [recommendedListLabel setTextColor:[UIColor lightGrayColor]];
    [containerView addSubview:recommendedListLabel];
    [recommendedListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_bottom).offset(5);
        make.leading.equalTo(totalRecommendedLabel.mas_leading);
    }];

    UILabel *recommendedListCountLabel = [[UILabel alloc] init];
    [recommendedListCountLabel setText:[NSString stringWithFormat:@"%zd人", [self.invitateFriendsModel.recommendListNumber integerValue]]];
    [recommendedListCountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [recommendedListCountLabel sizeToFit];
    [recommendedListCountLabel setTextColor:[UIColor colorWithRed:229 / 255.0 green:68 / 255.0 blue:68 / 255.0 alpha:1.0]];
    [containerView addSubview:recommendedListCountLabel];
    [recommendedListCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(recommendedListLabel.mas_trailing).offset(10);
        make.centerY.equalTo(recommendedListLabel.mas_centerY);
    }]; */

    return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDInviteUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    recommendFriendsListModel *model;
    if ([self.dataArray count] > 0) {
        model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.phoneLabel.text = model.mobile;
    cell.timeLabel.text = model.registerTime;
    cell.statusLabel.text = model.status;
    cell.statusLabel.textColor = AppTextColor;
    if ([model.status isEqualToString:@"无效邀请人"]) {
        cell.statusLabel.textColor = [self colorFromHexRGB:@"AAAAAA"];
    }
    [self setCellSeperatorToLeft:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
