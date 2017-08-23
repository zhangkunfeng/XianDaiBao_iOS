//
//  RechargeRecordViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "QCSlideSwitchView.h"
#import "RecordListViewController.h"

@interface RechargeRecordViewController : BaseViewController<CustomUINavBarDelegate,QCSlideSwitchViewDelegate>

@property (nonatomic, strong) RecordListViewController *vc1;
@property (nonatomic, strong) RecordListViewController *vc2;
@property (nonatomic, strong) RecordListViewController *vc3;

@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;

@end
