//
//  MDAssetsViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/11/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ButtonJumpType) {
    RechargeState = 0,//充值
    WithdrawState,    //提现
};

@interface MDAssetsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (nonatomic ,copy) NSString * total;
@end
