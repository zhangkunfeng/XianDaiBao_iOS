//
//  MyBankCardViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/9.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "bankCardPublicView.h"
#import "BindingBankCardViewController.h"

@interface MyBankCardViewController ()
@property (nonatomic, copy)NSDictionary *userInformationDict;//用于保存用户的信息

@end

@implementation MyBankCardViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //隐藏加载动画
//    [self dismissWeidaiLoadAnimationView:self];
    //移除报错界面
    [self hideMDErrorShowView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示加载动画
//    [self showWeidaiLoadAnimationView:self];
    //添加导航栏
    CustomMadeNavigationControllerView *myBankCard = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"银行卡管理" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:myBankCard];
    
    //获取账户的银行和认证信息
    [self getMyBankCardinformation];
    
}

- (void)getMyBankCardinformation{
    NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                 @"sid":   getObjectFromUserDefaults(SID),
                                 @"state": @"1",
                                 @"at":    getObjectFromUserDefaults(ACCESSTOKEN)};
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
           [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
               [weakSelf getMyBankCardinformation];
        } withFailureBlock:^{
            
        }];
        }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getMyBankCardinformation];
                } withFailureBlock:^{
                    
                }];
        }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _userInformationDict = [responseObject[@"item"] copy];
                //去设置界面
                [self setViewallControlStyle:[responseObject[@"item"] copy]];
            }//隐藏加载动画
//            [self dismissWeidaiLoadAnimationView:self];//
        }else{
            //隐藏加载动画
//            [self dismissWeidaiLoadAnimationView:self];//
            // 显示报错界面
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
        }
    } fail:^{
        [self dismissWithDataRequestStatus];
        //隐藏加载动画
//        [self dismissWeidaiLoadAnimationView:self];//
        // 显示报错界面
        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
    }];
}

- (void)setViewallControlStyle:(NSDictionary *)userInfodict{
    NSLog(@"%@",userInfodict);
    //添加银行卡界面
    NSString *bankCardIcon = @"bankcardStyle_image.png";
    NSString *bankName = @"银行";
    NSString *bankCardNumber = @"***** **** **** ****";
    NSString *bankStyle = @"暂无";
    if ((int)userInfodict[@"status"] != 2) {
        bankStyle = @"储蓄卡";
        if (![self isBlankString:userInfodict[@"bankNo"]]) {
            bankCardIcon = userInfodict[@"bankNo"];
        }
        if (![self isBlankString:userInfodict[@"bank"]]) {
            bankName = userInfodict[@"bank"];
        }
        if(![self isBlankString:userInfodict[@"accountHidden"]]){
            bankCardNumber = userInfodict[@"accountHidden"];
        }
    }
    bankCardPublicView *bankCardView = [[bankCardPublicView alloc] initWithsetBank:bankCardIcon bankCardName:bankName bankCardNumber:bankCardNumber bankCardStyle:bankStyle];
    [self.bankCardView addSubview:bankCardView];
    
    
    //通过帮卡的状态隐藏界面
    if ([userInfodict[@"status"] integerValue] != 2) {
        self.addBankCardButton.hidden = YES;
        self.addBankbuttonheightConstranint.constant = 0;
    }
    
    /*branchState 为0的话  可以修改支行信息  为1 不可修改支行信息
     *state 为1锁住银行信息  为2已审核可以更改   为3 提现审核中不可修改
     *status 1有卡 2无卡  3替换
     *realStatus 0 身份信息通过  1不通过  2审核中
     */
}

- (void)goBack{
    [self customPopViewController:0];
}
- (void)didReceiveMemoryWarning { 
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addBankCardButtonAction:(id)sender {
    BindingBankCardViewController *bindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
    bindingBankCardView.UserInformationDict = [_userInformationDict copy];
    bindingBankCardView.bankPayChannel = BankPayFromBindingCard;
    bindingBankCardView.isRefresh = ^(BOOL isRefresh){
        if (isRefresh) {
            [self getMyBankCardinformation];
        }
    };
    [self customPushViewController:bindingBankCardView customNum:0];
}


- (void)dealloc{
    _userInformationDict = nil;
}
@end
