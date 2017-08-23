//
//  NewDiscoveryListViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/29.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "NewDiscoveryListViewController.h"
#import "SDRefresh.h"
#import "SystemMessageTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "VerificationiPhoneNumberViewController.h"
#import "weidaiActivityTableViewCell.h"
#import "UITableView+CellHeightCache.h"
#import "WeidaiActivityTableCell.h"
@interface NewDiscoveryListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _textArray;
}
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong) UITableView * discoveryTableView;
@property (nonatomic, assign) NSInteger pageIndexNum; //请求数据页数
@property (nonatomic, copy)   NSString * notifyStr;

@end

@implementation NewDiscoveryListViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HideMainviewRedDot object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据的初始化
    currentClickIndex = -1;
    _pageIndexNum = 1;
    _discoveryMutabArray = [[NSMutableArray alloc] initWithCapacity:0];
    _discoveryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    _discoveryTableView.backgroundColor = [UIColor orangeColor];
    _discoveryTableView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    _discoveryTableView.estimatedRowHeight = 97;
    _discoveryTableView.delegate = self;
    _discoveryTableView.dataSource = self;
    _discoveryTableView.tableFooterView = [[UIView alloc] init]; //去掉多余的cell分割线
    _discoveryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_discoveryTableView];
    [_discoveryTableView registerNib:[UINib nibWithNibName:@"WeidaiActivityTableCell" bundle:nil] forCellReuseIdentifier:@"activitycell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewRefreshDiscoveryViewData:) name:RefreshDiscoveryView object:nil];
    
    [self setupHeader];
    [self setupFooter];
    
    [self selfDidCurrentView];//进入判断
}
//通知方法
- (void)NewRefreshDiscoveryViewData:(NSNotification*)notify
{
     _notifyStr = [notify object];
    /*addData,NORefrash*/
    [self getMyDiscoveryListData];
}

#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_discoveryTableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self getMyDiscoveryListData];
        });
    };
}

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_discoveryTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getMyDiscoveryListData];
        [self.refreshFooter endRefreshing];
    });
}

#pragma mark - 获取站内信列表
- (void)getMyDiscoveryListData {
    if (self.type == Discovery_activity) {
        NSDictionary *parameters = @{ @"page": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                                      @"rows": @"10",
                                      @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                      };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/xrtzDynamicList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (responseObject) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf getMyDiscoveryListData];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self hideMDErrorShowView:self];
                    
                    if (_pageIndexNum == 1 && [_discoveryMutabArray count] > 0) {
                        [_discoveryMutabArray removeAllObjects];
                    }
                    [_weakRefreshHeader endRefreshing];
                    NSArray *array = responseObject[@"data"];
                    if (_pageIndexNum > 1) {
                        if ([array count] == 0) {
//                            [weakSelf errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",@"动态"]];
                       }
                    }
                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                        for (id info in array) {
                            [_discoveryMutabArray addObject:info];
                        }
                    }
                    if ([_discoveryMutabArray count] > 0) {
//                        [weakSelf hideMDErrorShowView:self];
                        [_discoveryTableView reloadData];
                    } else {
                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:@"暂无贤钱宝动态数据" MDErrorShowViewType:NoData];
                    }
                } else {
                    [_weakRefreshHeader endRefreshing];
                    [weakSelf showMDErrorShowViewForError:weakSelf MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
                }
            }
        }
                                  fail:^{
                                      [_weakRefreshHeader endRefreshing];
                                      if ([_discoveryMutabArray count] > 0) {
                                          [weakSelf showErrorViewinMain];
                                      } else {
                                          [weakSelf initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64)];
                                      }
                                  }];
    } else { //系统消息
        if ([self isBlankString:getObjectFromUserDefaults(UID)]) {
            [_weakRefreshHeader endRefreshing];
            
            if ([_notifyStr isEqualToString:@"退出刷新发现"]) {
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:@"点击登录" MDErrorShowViewType:againRequestData];
                return;
            }
            
            VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
            verfication.pushviewNumber = 1001;
            verfication.isbackRefresh = ^(BOOL isbackRefresh) {
                if (isbackRefresh) {
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:@"点击登录" MDErrorShowViewType:againRequestData];
                }
            };
            [self customPushViewController:verfication customNum:0];
        } else {
            NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                          @"sid": getObjectFromUserDefaults(SID),
                                          @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                          @"pageIndex": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                                          @"pageSize": @"10"
                                          };
            WS(weakSelf);
            [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/smsList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
                if (![self isBlankString:responseObject[@"r"]]) {
                    if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                            [weakSelf getMyDiscoveryListData];
                        } withFailureBlock:^{
                            
                        }];
                    } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                        [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                            [weakSelf getMyDiscoveryListData];
                        } withFailureBlock:^{
                            
                        }];
                    } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                        [self hideMDErrorShowView:self];
                        
                        if ([_discoveryMutabArray count] > 0 && _pageIndexNum == 1) {
                            [_discoveryMutabArray removeAllObjects];
                        }
                        [_weakRefreshHeader endRefreshing];
                        NSArray *array = responseObject[@"data"];
                        if (_pageIndexNum > 1) {
                            if ([array count] == 0) {
//                                [weakSelf errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@", @"消息"]];
                            }
                        }
                        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                            for (id info in array) {
                                [_discoveryMutabArray addObject:info];
                            }
                        }
                        
                        if ([_discoveryMutabArray count] > 0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:HideMainviewRedDot object:nil];
//                            [weakSelf hideMDErrorShowView:self];
                            [_discoveryTableView reloadData];
                        } else {
                            [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:@"暂无系统消息数据" MDErrorShowViewType:NoData];
                        }
                    } else {
                        [_weakRefreshHeader endRefreshing];
                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
                    }
                }
            }
                                      fail:^{
                                          [_weakRefreshHeader endRefreshing];
                                          if ([_discoveryMutabArray count] > 0) {
                                              [weakSelf showErrorViewinMain];
                                          } else {
                                              [weakSelf initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64)];
                                          }
                                      }];
        }
    }
}

//进入判断
- (void)selfDidCurrentView {
    if (self.type == Discovery_message) {
        if (![self isBlankString:getObjectFromUserDefaults(UID)]) {
            [_weakRefreshHeader beginRefreshing];  //代理方法中设置的进入刷新
        } else {
            VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
            verfication.pushviewNumber = 1001;
            verfication.isbackRefresh = ^(BOOL isbackRefresh) {
                if (isbackRefresh) {
                    [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"点击登录" MDErrorShowViewType:againRequestData];
                }
            };
            [self customPushViewController:verfication customNum:0];
            [self hideMDErrorShowView:self];
        }
    } else {
        if ([_discoveryMutabArray count] == 0) {
            [_weakRefreshHeader beginRefreshing];
        } else {
            [_discoveryTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_discoveryMutabArray count] > 0) {
        return [_discoveryMutabArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == Discovery_activity) {
        return [weidaiActivityTableViewCell weidaiActivityTableViewCellHeight];
    } else {
        if (!(_discoveryMutabArray.count > 0)) {
            return 97;
        }
        
        CGFloat cellHeight = [tableView getCellHeightCacheWithCacheKey:_discoveryMutabArray[indexPath.row]/*值作为key*/];
        NSLog(@"从缓存取出来图片高度的-----%f",cellHeight);
        
        if(!cellHeight){
            NSString * textStr = [self isBlankString:_discoveryMutabArray[indexPath.row][@"msgtitle"]]?@" ":_discoveryMutabArray[indexPath.row][@"msgtitle"];
            CGSize lablesize = [self labelAutoCalculateRectWith:textStr FontSize:12.0 MaxSize:CGSizeMake(iPhoneWidth-70, MAXFLOAT)];
            cellHeight = lablesize.height+(100-14.5);
            [tableView setCellHeightCacheWithCellHeight:cellHeight CacheKey:_discoveryMutabArray[indexPath.row]];
        }
        
        return cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *weidaiDict = nil;
    if ([_discoveryMutabArray count] > 0) {
        weidaiDict = [_discoveryMutabArray objectAtIndex:indexPath.row];
    }
    if (self.type == Discovery_activity) {
//        weidaiActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[weidaiActivityTableViewCell weidaiActivityTableViewCell_id]];
//        if (cell == nil) {
//            cell = [weidaiActivityTableViewCell initWithweidaiActivityTableViewCell];
//        } else {
//            //删除cell的所有子视图
//            while ([cell.contentView.subviews lastObject] != nil) {
//                [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
//            }
//        }
        
        WeidaiActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activitycell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = [self isLegalObject:weidaiDict[@"title"]] ? weidaiDict[@"title"] : @"";
        
        cell.timeLable.text = [self isLegalObject:weidaiDict[@"createTime"]] ? weidaiDict[@"createTime"] : @"";
        if ([self isLegalObject:weidaiDict[@"path"]]) {
            [cell.ContentimageView setImageWithURL:[NSURL URLWithString:weidaiDict[@"path"]] placeholderImage:[UIImage imageNamed:@"weidaiactivity_ default"]];
//            cell.NewsLabel.text = @"热力新闻";
        }
        return cell;
    } else {
        SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SystemMessageTableViewCell initWithSystemMessageTableViewCell_ID]];
        if (cell == nil) {
            cell = [SystemMessageTableViewCell initWithSystemMessageTableViewCell];
        } else {
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.systemContentLable.text = [self isLegalObject:weidaiDict[@"msgtitle"]] ? weidaiDict[@"msgtitle"] : @"";
        
        if ([self isLegalObject:weidaiDict[@"createTime"]]) {
            cell.timeLable.text = weidaiDict[@"createTime"];
        }
        
        if (!isOpenCell) {
            if (currentClickIndex == indexPath.row) {
//                [cell.systemMessageImage setImage:[UIImage imageNamed:IMG_SYSTEMMESSAGE_S]];
//                [cell.systemMessageImage setImage:[UIImage imageNamed:IMG_SYSTEMMESSAGE]];
            } else if ([weidaiDict[@"status"] integerValue] == 0) {
//                [cell.systemMessageImage setImage:[UIImage imageNamed:IMG_SYSTEMMESSAGE_S]];
            }
        }
        
        if (isOpenCell == YES && currentClickIndex == indexPath.row) {
//            [cell.systemMessageImage setImage:[UIImage imageNamed:IMG_SYSTEMMESSAGE]];
//            [cell.systemMessageImage setImage:[UIImage imageNamed:IMG_SYSTEMMESSAGE_S]];
            cell.systemContentLable.numberOfLines = 0;
            cell.systemContentLable.lineBreakMode = NSLineBreakByCharWrapping;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.type == Discovery_activity) {
        if ([_discoveryMutabArray count] > 0) {
            NSDictionary *weidaiDict = [_discoveryMutabArray objectAtIndex:indexPath.row];
            if (![self isBlankString:weidaiDict[@"urlLink"]] && ![self isBlankString:weidaiDict[@"title"]]) {
                [self jumpToWebview:weidaiDict[@"urlLink"] webViewTitle:weidaiDict[@"title"]];
            }
        }
    } else {
        CGSize lablesize = [self labelAutoCalculateRectWith:[_discoveryMutabArray objectAtIndex:indexPath.section][@"msgtext"] FontSize:12.0 MaxSize:CGSizeMake(iPhoneWidth * 0.4, MAXFLOAT)];
        if (lablesize.height > 50) {
            if (indexPath.row == currentClickIndex) {
                isOpenCell = !isOpenCell;
            } else {
                isOpenCell = YES;
            }
            currentClickIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - MDErrorShowViewDelegate
- (void)againLoadingData {
    //移除错误界面
    [self hideMDErrorShowView:self];
    [self selfDidCurrentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
