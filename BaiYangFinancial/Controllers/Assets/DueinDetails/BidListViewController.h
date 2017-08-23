//
//  BidListViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/8.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class RecentlyBidViewController;

@interface BidListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)NSInteger pageIndexNum;//请求数据页数

@property (nonatomic, strong) UITableView *tableViewList;

@property (nonatomic, strong)RecentlyBidViewController *recentlyVc;

- (void)viewDidCurrentView;

@end
