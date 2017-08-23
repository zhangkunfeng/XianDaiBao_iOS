//
//  RegSuccessfulController.m
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/3.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "RegSuccessfulController.h"
#import "WDRegisterSuccessPopupView.h"
#import "BindingBankCardViewController.h"
#import "RedenvelopeViewController.h"
@interface RegSuccessfulController ()<WDRegisterSuccessPopupViewDelegate>

@end

@implementation RegSuccessfulController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"注册成功"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"注册成功"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToProductListA:) name:GOTOPRODUCTLIST object:nil];
    WDRegisterSuccessPopupView *registerSuccessPopupView = [[WDRegisterSuccessPopupView alloc] init];
    registerSuccessPopupView.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:registerSuccessPopupView];
    registerSuccessPopupView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.35 animations:^{
        registerSuccessPopupView.transform = CGAffineTransformIdentity;
    }
                     completion:^(BOOL finished) {
                         registerSuccessPopupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                     }];

}
- (void)goToProductListA:(NSNotification *)notification {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:GOTOPRODUCTLIST object:nil];
    WDRegisterSuccessPopupView *registerSuccessPopupView = [[WDRegisterSuccessPopupView alloc] init];
    registerSuccessPopupView.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:registerSuccessPopupView];
    registerSuccessPopupView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.35 animations:^{
        registerSuccessPopupView.transform = CGAffineTransformIdentity;
    }
                     completion:^(BOOL finished) {
                         registerSuccessPopupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                     }];
}
- (void)bindingBankCard
{
    //获取用户信息
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    [self showWithDataRequestStatus:@"获取信息中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
            BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
            BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
                
            };
            BindingBankCardView.UserInformationDict = (NSDictionary *) [responseObject[@"item"] copy];
            [self customPushViewController:BindingBankCardView customNum:0];
        } else {
            [self dismissWithDataRequestStatus];
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (void)lookReddenvelope {
    //我的红包
    RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] init];
    [self customPushViewController:myRedenvelopeView customNum:0];
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
