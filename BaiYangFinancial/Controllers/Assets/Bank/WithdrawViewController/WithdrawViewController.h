//
//  WithdrawViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface WithdrawViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>
@property (nonatomic, copy)NSDictionary *userinfoDict;//上个界面传过来的
@property (nonatomic, retain)NSString *availablecashString;//可提现金

@end
