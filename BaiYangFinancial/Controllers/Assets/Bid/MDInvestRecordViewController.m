//
//  MDInvestRecordViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/2/23.
//  Copyright (c) 2016年 无名小子. All rights reserved.
//

#import "MDInvestRecordViewController.h"
#import "QCSlideSwitchView.h"
#import "CustomMadeNavigationControllerView.h"
#import "BidViewController.h"

@interface MDInvestRecordViewController ()<CustomUINavBarDelegate,QCSlideSwitchViewDelegate>

@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong)BidViewController *vc1;
@property (nonatomic, strong)BidViewController *vc2;

@end

@implementation MDInvestRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CustomMadeNavigationControllerView *MDInvestRecordView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"投资记录" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:MDInvestRecordView];
    
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.topScrollView.frame = CGRectMake(0, 0, 0, 0);
    self.slideSwitchView.rootScrollView.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneHeight + 44);
//    self.slideSwitchView.rootScrollView.backgroundColor = AppViewBackGroundColor;
//    self.slideSwitchView.tabItemNormalColor = [self colorFromHexRGB:@"3A3A3A"];
//    self.slideSwitchView.tabItemSelectedColor = [self colorFromHexRGB:@"27A5EA"];
    
//    self.vc1 = [[BidViewController alloc] init];
//    self.vc1.title = @"全部标的";
//    self.vc1.investRecordView = self;
    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 1;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.vc1;
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    BidViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    }
    [vc viewDidCurrentView];
}


- (void)goBack{
    [self customPopViewController:0];
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
