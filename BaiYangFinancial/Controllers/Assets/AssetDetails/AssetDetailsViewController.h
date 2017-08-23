//
//  AssetDetailsViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/21.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface AssetDetailsViewController : BaseViewController<CustomUINavBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, copy)NSDictionary *accinfoDict;
@end
