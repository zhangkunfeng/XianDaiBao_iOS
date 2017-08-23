//
//  DebtTransferViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "QCSlideSwitchView.h"
#import "DebtListViewController.h"

@interface DebtTransferViewController : BaseViewController<CustomUINavBarDelegate,QCSlideSwitchViewDelegate>
@property (nonatomic, strong) DebtListViewController *vc1;
@property (nonatomic, strong) DebtListViewController *vc2;
@property (nonatomic, strong) DebtListViewController *vc3;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;

@end
