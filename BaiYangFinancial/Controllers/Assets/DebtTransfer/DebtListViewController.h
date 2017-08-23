//
//  DebtListViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

@class DebtTransferViewController;

@interface DebtListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)NSInteger pageIndexNum;//请求数据页数

@property (nonatomic, strong)DebtTransferViewController *debtVc;

@property (nonatomic, strong)UITableView *_tableViewList;
- (void)viewDidCurrentView;

@end
