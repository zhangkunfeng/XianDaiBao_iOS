//
//  BorrowingRecordViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/7.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BorrowingRecordViewController.h"

@interface BorrowingRecordViewController ()

@end

#define BorrowingRecordVCText @"借款记录"
@implementation BorrowingRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:BorrowingRecordVCText];
    [self setQLStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:BorrowingRecordVCText];
    //干扰进入日期选择页面状态栏颜色bug，不影响回主页面颜色

//    [self setQLStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DetailPageNavigationView *borrowingRecordView = [[DetailPageNavigationView alloc] initWithDetailPageNavigationViewTitle:BorrowingRecordVCText showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:borrowingRecordView];
    
    self.slideSwitchView.slideSwitchViewDelegate =self;
    self.slideSwitchView.rootScrollView.backgroundColor = [UIColor whiteColor];
    self.slideSwitchView.topScrollView.backgroundColor  = [UIColor whiteColor];
    self.slideSwitchView.tabItemNormalColor = [self colorFromHexRGB:@"333333"];
    self.slideSwitchView.tabItemSelectedColor = [self colorFromHexRGB:@"2896f8"];
    
    self.vc1 = [[BorrowingListViewController alloc] init];
    self.vc1.title = @"待还款";
    self.vc1.redenveVC=self;
    
    self.vc2 = [[BorrowingListViewController alloc] init];
    self.vc2.title = @"已还款";
    self.vc2.redenveVC=self;
    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 2;
}
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    }else{
        return self.vc2;
    }
}
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    BorrowingListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    }else{
        vc = self.vc2;
    }
    [vc viewDidCurrentView];
}
-(void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
