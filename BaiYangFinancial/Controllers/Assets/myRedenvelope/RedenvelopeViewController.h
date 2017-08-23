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
#import "RedenveListViewController.h"


typedef NS_ENUM(NSInteger, RedBfrom) {
    redRef = 0,
    redFrom
};


@interface RedenvelopeViewController : BaseViewController<CustomUINavBarDelegate,QCSlideSwitchViewDelegate>
@property (nonatomic, strong) RedenveListViewController *vc1;
@property (nonatomic, strong) RedenveListViewController *vc2;
@property (nonatomic, strong) RedenveListViewController *vc3;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic, assign)RedBfrom redBao;//判断从哪进来的



@end
