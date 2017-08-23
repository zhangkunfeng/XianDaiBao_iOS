//
//  RechargeMyAssetsViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef NS_ENUM(NSInteger, RechargeStyle) {
    FuyouPay = 0,
    LianlianPay,
};

@interface RechargeMyAssetsViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>

@property (nonatomic, assign)RechargeStyle rechargeType;
@property (nonatomic, copy)NSDictionary *UserInformationDict; //上个界面传下来的用户信息
@property (nonatomic, retain)NSString *AvailableBalanceString;//可用金额
@property (nonatomic, copy)NSString *chargeUrl;               //充值接口地址

@end
