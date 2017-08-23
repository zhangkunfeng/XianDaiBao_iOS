//
//  ChoosePersonViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/6.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMadeNavigationControllerView.h"

typedef void (^SelectPersonNameBlock)(NSString *personName,NSString *friendUid);
@interface ChoosePersonViewController : BaseViewController <CustomUINavBarDelegate>

@property (nonatomic, copy)SelectPersonNameBlock selectPersonNameBlock;

@end
