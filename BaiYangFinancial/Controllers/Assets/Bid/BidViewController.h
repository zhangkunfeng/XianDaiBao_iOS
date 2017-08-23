//
//  BidViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/22.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface BidViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CustomUINavBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_tableView;

- (void)viewDidCurrentView;

@end
