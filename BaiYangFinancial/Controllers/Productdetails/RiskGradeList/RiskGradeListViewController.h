//
//  RiskGradeListViewController.h
//  weidaiwang
//
//  Created by 艾运旺 on 15/9/11.
//  Copyright (c) 2015年 艾运旺. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface RiskGradeListViewController : BaseViewController<CustomUINavBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *RiskGradeTableview;

@end
