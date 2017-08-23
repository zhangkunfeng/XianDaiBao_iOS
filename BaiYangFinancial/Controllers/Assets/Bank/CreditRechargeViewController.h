//
//  CreditRechargeViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/3/24.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface CreditRechargeViewController : BaseViewController <CustomUINavBarDelegate,UITextFieldDelegate>
@property (nonatomic, copy)NSDictionary *UserInformationDict;//上个界面传下来的用户信息
@property (nonatomic, copy)NSString * chargeUrlStr;

@end
