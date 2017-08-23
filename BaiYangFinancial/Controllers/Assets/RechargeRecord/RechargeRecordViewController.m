//
//  RechargeRecordViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "RechargeRecordViewController.h"

@interface RechargeRecordViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic)         CGPoint                      contentOffset;                  // default CGPointZero

@end

@implementation RechargeRecordViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }

}


- (void)viewDidLoad {
    [super viewDidLoad];

    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"资金明细" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];

    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.backgroundColor = AppViewBackGroundColor;
    self.slideSwitchView.tabItemNormalColor = [self colorFromHexRGB:@"3A3A3A"];
    self.slideSwitchView.tabItemSelectedColor = AppMianColor;

    self.vc1 = [[RecordListViewController alloc] init];
    self.vc1.title = @"全部记录";
    self.vc1.RecordVc = self;
    
    self.vc2 = [[RecordListViewController alloc] init];
    self.vc2.title = @"充值记录";
    self.vc2.RecordVc = self;

    self.vc3 = [[RecordListViewController alloc] init];
    self.vc3.title = @"提现记录";
    self.vc3.RecordVc = self;
    if (self.vc1) {
        [self resetSideBack];
    }else{
        [self forbiddenSideBack];
    }
    [self.slideSwitchView buildUI];
//    [self.slideSwitchView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//    [_bigScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    // you can set the best you can do it ;
    return 3;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    if (number == 0) {
        return self.vc1;
    }else if (number == 1){
        return self.vc2;
    }else {
        return self.vc3;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number {
    RecordListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    }else if (number == 1) {
        vc = self.vc2;
    }else {
        vc = self.vc3;
    }
    [vc viewDidCurrentView];
}

- (void)goBack {
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
