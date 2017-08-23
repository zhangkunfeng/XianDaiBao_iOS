//
//  BorrowingRecordViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/7.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailPageNavigationView.h"
#import "BorrowingListViewController.h"
#import "QCSlideSwitchView.h"

@interface BorrowingRecordViewController : BaseViewController<DetailPageNavigationViewDelegate,QCSlideSwitchViewDelegate>

@property (nonatomic, strong) BorrowingListViewController *vc1;
@property (nonatomic, strong) BorrowingListViewController *vc2;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;

@end
