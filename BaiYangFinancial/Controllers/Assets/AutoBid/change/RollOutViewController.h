//
//  RollOutViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/1/16.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef void (^rollOutRefreshBlock)(BOOL isRefresh);

@interface RollOutViewController : BaseViewController <CustomUINavBarDelegate>

@property (nonatomic,copy)NSString * changeMoneyBlanceStr;
@property (nonatomic,copy)rollOutRefreshBlock rollOutRefresh;
@property (nonatomic,copy)NSString * bid;

@end
