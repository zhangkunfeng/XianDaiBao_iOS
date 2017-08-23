//
//  RecordListViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

@class RechargeRecordViewController;

@interface RecordListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)NSInteger pageIndexNum;

@property (nonatomic, strong) UITableView *tableViewList;

@property (nonatomic, strong)RechargeRecordViewController *RecordVc;

- (void)viewDidCurrentView;

@end
