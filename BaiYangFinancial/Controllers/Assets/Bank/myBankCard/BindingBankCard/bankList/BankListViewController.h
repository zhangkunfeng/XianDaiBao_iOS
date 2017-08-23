//
//  BankListViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/4.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

//
typedef void(^BankListBlock)(NSDictionary *bankListDict);

@interface BankListViewController : BaseViewController<CustomUINavBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy)BankListBlock backBankDict;//回调方法

@property (nonatomic, assign)NSString *bankName;// 上级界面传过来的银行卡名字

@property (weak, nonatomic) IBOutlet UITableView *bankListTableView;


@end
