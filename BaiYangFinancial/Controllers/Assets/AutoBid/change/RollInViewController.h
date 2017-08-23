//
//  RollInViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/1/16.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
typedef void (^rollInRefreshBlock) (BOOL isRefresh);
@interface RollInViewController : BaseViewController <CustomUINavBarDelegate>

@property (nonatomic,copy)rollInRefreshBlock rollInRefresh;
@property (nonatomic,copy)NSString * bid;

@end
