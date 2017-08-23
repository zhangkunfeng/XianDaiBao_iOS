//
//  DebtTransferViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "DebtTransferViewController.h"

@interface DebtTransferViewController ()

@end

@implementation DebtTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"债权转让" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
    self.slideSwitchView.slideSwitchViewDelegate =self;
    self.slideSwitchView.rootScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.slideSwitchView.tabItemNormalColor = [self colorFromHexRGB:@"3A3A3A"];
    self.slideSwitchView.tabItemSelectedColor = AppMianColor;
    
    self.vc1 = [[DebtListViewController alloc] init];
    self.vc1.title = @"可转让债权";
    self.vc1.debtVc=self;
    
    self.vc2 = [[DebtListViewController alloc] init];
    self.vc2.title = @"转让债权";
    self.vc2.debtVc=self;
    
    self.vc3 = [[DebtListViewController alloc] init];
    self.vc3.title = @"承接债权";
    self.vc3.debtVc=self;
    [self.slideSwitchView buildUI];
}
- (void)goBack{
    [self customPopViewController:0];
}
#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 3;
}
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    }else if(number == 1){
        return self.vc2;
    }else{
        return self.vc3;
    }
}
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    DebtListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    }else if(number == 1){
        vc = self.vc2;
    }else{
        vc = self.vc3;
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

@end
