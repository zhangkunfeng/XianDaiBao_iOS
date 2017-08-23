//
//  SettingViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailPageNavigationView.h"

typedef void(^exitLoginBlock)(BOOL isexit);

@interface SettingViewController : BaseViewController<DetailPageNavigationViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, copy)NSArray *titleAndimageArray;//存放标题和图片的数组
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (nonatomic, copy)exitLoginBlock exitLogin;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *SettingView;
//@property (weak, nonatomic) IBOutlet UIScrollView *SuperScrollView;

@end
