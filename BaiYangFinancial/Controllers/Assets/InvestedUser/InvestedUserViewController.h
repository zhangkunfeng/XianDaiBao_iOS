//
//  InvestedUserViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/3.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
@class ProductdetailsViewController;
@interface InvestedUserViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_tableview;//列表
@property (nonatomic, retain)NSString *bid;//标id
@property (nonatomic,assign)NSInteger pageIndexNum;//请求数据页数

@property (nonatomic, copy)NSMutableArray *bidTenderListArray;  //上级界面传过来的标的列表
@property (nonatomic, copy)NSMutableArray *langYaTopListArray;

@property (nonatomic, retain)NSString *InterestRate;//利率

@property (nonatomic, assign)BOOL isOptimizationBid;//是否优选标的

@property (nonatomic, strong)ProductdetailsViewController *productdetail;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, strong)NSString *bidTenderNum;

@end
