//
//  RecentlyBidViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/8.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "RecentlyBidViewController.h"
#import "CustomMadeNavigationControllerView.h"
@interface RecentlyBidViewController ()<CustomUINavBarDelegate>

@end

@implementation RecentlyBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self resetSideBack];
    //设置返回按钮
//    [self.gobackButton setImage:[UIImage imageNamed:@"back_ default"] forState:UIControlStateNormal];
//    [self.gobackButton setImage:[UIImage imageNamed:@"back_ Selected"] forState:UIControlStateHighlighted];
    CustomMadeNavigationControllerView *MDInvestRecordView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"待收明细" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:MDInvestRecordView];
    
    self.slideSwitchView.slideSwitchViewDelegate =self;
    self.slideSwitchView.rootScrollView.backgroundColor = [self colorFromHexRGB:@"F2F2F2"];
    self.slideSwitchView.tabItemNormalColor = [self colorFromHexRGB:@"3A3A3A"];
    self.slideSwitchView.tabItemSelectedColor = AppMianColor;
    
    self.vc1 = [[BidListViewController alloc] init];
    self.vc1.title = @"待收明细";
    self.vc1.recentlyVc=self;
    self.vc2 = [[BidListViewController alloc] init];
    self.vc2.title = @"已收明细";
    self.vc2.recentlyVc=self;
    [self.slideSwitchView buildUI];
    
}
//TODO:返回按钮
- (void)goBack {
    [self customPopViewController:0];
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
    } else  {
        return self.vc2;
    }
}
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    BidListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    } else {
        vc = self.vc2;
    }
    [vc viewDidCurrentView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBackAction:(id)sender {
    [self customPopViewController:0];
}
@end
