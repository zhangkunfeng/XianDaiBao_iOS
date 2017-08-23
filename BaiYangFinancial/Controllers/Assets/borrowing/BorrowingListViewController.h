//
//  BorrowingListViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@class BorrowingRecordViewController;
typedef NS_ENUM(NSInteger, BorrowingStyle) {
    BorrowingWaitingState = 0,       //待还款
    BorrowingAlreadyState,           //已还款
};

@interface BorrowingListViewController : BaseViewController

@property (nonatomic,assign)NSInteger pageIndexNum;//请求数据页数

@property (nonatomic, strong)BorrowingRecordViewController *redenveVC;

- (void)viewDidCurrentView;

@end
