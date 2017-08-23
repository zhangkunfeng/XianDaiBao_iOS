//
//  DebtListViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

@class RedenvelopeViewController;
@class ProductdetailsViewController;//test
typedef NS_ENUM(NSInteger, RedenvelopeStyle) {
    Redenvelope_Overdue = 0,        //过期红包
    Redenvelope_Used,           //已用红包
    Redenvelope_Available    //可用红包
};

@interface RedenveListViewController : BaseViewController

@property (nonatomic,assign)NSInteger pageIndexNum;//请求数据页数

@property (nonatomic, strong)RedenvelopeViewController *redenveVC;
//test
@property (nonatomic, strong)ProductdetailsViewController *productdetail;

@property (nonatomic, strong)UITableView *_tableViewList;
- (void)viewDidCurrentView;

@end
