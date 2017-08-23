//
//  TransferButtonViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "TransferButtonViewController.h"
#import "DebtListViewController.h"
#import "Masonry.h"
#import "XRPayPassWorldView.h"
#import "ForgetPassWdViewController.h"
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 50  //每一个输入框的高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width

@interface TransferButtonViewController ()<UITextFieldDelegate,XRPayPassWorldViewDelegate>

@property (nonatomic ,strong) NSDictionary *infoDict;
@property (nonatomic ,strong) NSString *wwww;

@property (strong, nonatomic)XRPayPassWorldView *payPassWorldView;
//{
//NSDictionary *_infoDict;
//UITextField *textField;
//NSMutableArray *dotArray; //用于存放黑色的点点
//NSString *payPassStr;
//UIView *passwordView;
//}
@end

@implementation TransferButtonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
    [AFNetworkTool cancelAllHTTPOperations];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.payPassWorldView.textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"债权转让" showBackButton:YES showRightButton:YES rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
//    [self setTheGradientWithView:self.BigView];

    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self loadTransferInfo];
}
#pragma mark - 点击屏幕空白区域收起键盘
- (void)keybordDown:(id)sender
{
    [self.view endEditing:YES];
}
#pragma mark - 加载转让详情界面的数据
- (void)loadTransferInfo{
    NSDictionary *parameters =@{@"uid":    getObjectFromUserDefaults(UID),
                                @"at" :    getObjectFromUserDefaults(ACCESSTOKEN),
                                @"bid":    _transferbidID };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getTransferBidDeatil",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadTransferInfo];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self hideMDErrorShowView:self];
                if (![responseObject[@"item" ] isKindOfClass:[NSNull class]]) {
                    _infoDict = [[responseObject objectForKey:@"item"] copy];
                    [self setValue];
                    [self transferPrice];
                    [self waitPrice];
                    [self principalPrice];
                    [self interestPrice];
                    [self endPrice];
//                    [self shouxufei];
//                    [self zhijiefei];
                }
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self initWithWDprojectErrorview:nil contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
    }];
}

- (void)againLoadingData
{
    [self loadTransferInfo];
}

//传值-标名/年化利率/剩余期数/待收日期(暂无)/折价率
- (void)setValue{
    
    //折价率     （项目总额-转让价格）/ 总额
    if ([self isLegalObject:_infoDict[@"transferPrice"]]) {
        self.discountRateLab.text = [NSString stringWithFormat:@"%.1f",([_infoDict[@"recoverCapital"]  floatValue] - [_infoDict[@"transferPrice"] floatValue])/[_infoDict[@"recoverCapital"]  floatValue] * 100];
    }
    
   
    
    //剩余期数
    if ([self isLegalObject:_infoDict[@"restPeriods"]]) {
       self.recoverPeriod.text=[NSString stringWithFormat:@"%@",_infoDict[@"restPeriods"]];
    }else{
        self.recoverPeriod.text = @"";
    }
     //标的状态 及 承接按钮
    if ([self isLegalObject:_infoDict[@"recoverTimeShow"]]) {
      self.recoverTimeShow.text=[NSString stringWithFormat:@"%@",_infoDict[@"recoverTimeShow"]];
    }else{
        self.recoverTimeShow.text = @"";
    }
    
    //利率
    if ([self isLegalObject:_infoDict[@"borrowAnnualYield"]]) {
       self.borrowAnnualYield.text=[NSString stringWithFormat:@"%.1f",[_infoDict[@"borrowAnnualYield"] doubleValue]];
    }else{
        self.borrowAnnualYield.text = @"";
    }
    
    //标题
    if ([self isLegalObject:_infoDict[@"bidName"]]) {
        self.bidName.text=[NSString stringWithFormat:@"%@",_infoDict[@"bidName"]];
    }else{
        self.bidName.text = @"";
    }
    //折价费
    if ([self isLegalObject:_infoDict[@"recoverCapital"]]) {
        self.countRateLab.text=[NSString stringWithFormat:@"-%.2f元",[_infoDict[@"recoverCapital"] doubleValue]/1000 *2];
    }else{
        self.countRateLab.text = @"";
    }
    //手续费
    if ([self isLegalObject:_infoDict[@"recoverCapital"]]) {
        self.shouXunLab.text=[NSString stringWithFormat:@"-%.2f元",[_infoDict[@"recoverCapital"] doubleValue]/1000 *3];
    }else{
        self.shouXunLab.text = @"";
    }

   
}
#pragma mark - 确定转让出去传值给后台的数据
- (void)loadEnsureTransferInfo{
    /*
    NSString *pswString = @"";
    if ([self isBlankString:self.transferPSW.text]) {
        pswString = @"";
    }else{
        pswString = self.transferPSW.text;
    }
    */
    NSDictionary *parameters =@{ @"uid":    getObjectFromUserDefaults(UID),
                                @"at" :    getObjectFromUserDefaults(ACCESSTOKEN),
                                @"bid":    [[_infoDict objectForKey:@"id"] stringValue],
                                @"amonut": [[_infoDict objectForKey:@"recoverAmonut"] stringValue],
                                @"capital":[[_infoDict objectForKey:@"recoverCapital"] stringValue],
                                @"interest":[[_infoDict objectForKey:@"recoverInterest"] stringValue],
                                @"restPeriod":[[_infoDict objectForKey:@"restPeriods"] stringValue],
                                 @"passWord":_wwww,/*[NetManager TripleDES:_wwww encryptOrDecrypt:kCCEncrypt key:K3DESKey],*/
                                @"payPassword": /*[NetManager TripleDES:pswString encryptOrDecrypt:kCCEncrypt key:K3DESKey]  转让的时候不需要支付密码*/ @""
                                };
    [self showWithDataRequestStatus:@"转让中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/releaseTranBid",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadEnsureTransferInfo];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self showWithSuccessWithStatus:@"转让成功"];
                
                [self dismissPopupController];
                [self.payPassWorldView clearUpPassword];
                
                if (self.isbackRefresh) {
                    self.isbackRefresh(YES);
                }
                [self performSelector:@selector(goBack) withObject:nil afterDelay:3.0f];
            }else{
                [self.payPassWorldView clearUpPassword];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                NSLog(@"%@",responseObject[@"msg"]);
            }
        }
    } fail:^{
        [self.payPassWorldView clearUpPassword];
        [self errorPrompt:3.0 promptStr:errorPromptString];
        [self initWithWDprojectErrorview:nil contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64 - 50)];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [self loadEnsureTransferInfo];
        //[self payPassWord];
    }
}


//设置转让价格
- (void)transferPrice
{
    if ([self isLegalObject:_infoDict[@"comeToHand"]]) {
        self.transferPriceLab.text = [Number3for1 formatAmount:_infoDict[@"comeToHand"]];
    }else{
        self.transferPriceLab.text = @"";
    }

}
//设置折价费
- (void)zhijiefei
{
    if ([self isLegalObject:_infoDict[@"recoverCapital"]]) {
        self.countRateLab.text=[NSString stringWithFormat:@"-%.2f",[_infoDict[@"recoverCapital"] doubleValue]/1000 *2];
    }else{
        self.countRateLab.text = @"";
    }
    
}
//设置手续费
- (void)shouxufei
{
    if ([self isLegalObject:_infoDict[@"recoverCapital"]]) {
        self.shouXunLab.text=[NSString stringWithFormat:@"-%.2f",[_infoDict[@"recoverCapital"] doubleValue]/1000 *3];
    }else{
        self.shouXunLab.text = @"";
    }
    
}


//设置待收总额
- (void)waitPrice
{
//    NSLog(@"%@",_infoDict);
    if ([self isLegalObject:_infoDict[@"recoverInterest"]]) {
        self.waitPriceLab.text = [Number3for1 formatAmount:_infoDict[@"recoverInterest"]];
    }else{
        self.waitPriceLab.text = @"";
    }
}
//设置待收本金
- (void)principalPrice
{
    if ([self isLegalObject:_infoDict[@"recoverCapital"]]) {
        self.principalLab.text= [Number3for1 formatAmount:_infoDict[@"recoverCapital"]];
    }else{
        self.principalLab.text = @"";
    }
}
//设置待收利息
- (void)interestPrice
{
    if ([self isLegalObject:_infoDict[@"recoverInterest"]]) {
        self.interestLab.text= [Number3for1 formatAmount:_infoDict[@"recoverInterest"]];
    }else{
        self.interestLab.text = @"";
    }
}
//设置最终到手
- (void)endPrice
{
    if ([self isLegalObject:_infoDict[@"comeToHand"]]) {
        self.endPriceLab.text = [NSString stringWithFormat:@"%@",[Number3for1 formatAmount:_infoDict[@"comeToHand"]]];//已添加元了
    }else{
        self.endPriceLab.text = @"";
    }
}

//最终到手的弹出框
- (IBAction)endAmount:(id)sender {
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"最终到手包括" message:@"最终到手=待收本金-0.3%手续费-0.2%折价" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}
//返回上一界面
- (void)goBack{
    [self customPopViewController:0];
}

//加载标的转让规则链接
- (IBAction)TransferRulesButton:(id)sender {
    [self jumpToWebview:AssignmentDetailsURL webViewTitle:@"债权转让规则"];
}

- (IBAction)sureBtnClicked:(id)sender {

    self.payPassWorldView.textField.text = @"";
    [self.payPassWorldView clearUpPassword];
    self.payPassWorldView.bottomDistance.constant = iPhone6_?220:iPhone5?125:216;

    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPassWorldView];
}


- (XRPayPassWorldView *)payPassWorldView{
    if (!_payPassWorldView) {
        _payPassWorldView = [[XRPayPassWorldView alloc] init];
        _payPassWorldView.delegate = self;
    }
    [_payPassWorldView.textField becomeFirstResponder];
    
    return _payPassWorldView;
}

- (void)cancelTappend{
    [self dismissPopupController];
}

- (void)sureTappend{//账户余额够输入支付密码代理
    [self.payPassWorldView.textField resignFirstResponder];
    if ([self isBlankString:self.payPassWorldView.textField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入支付密码"];
    } else {
        
        _wwww = self.payPassWorldView.textField.text;
//        [self dismissPopupController];
//        [self.payPassWorldView clearUpPassword];
        
        //转让请求
        [self loadEnsureTransferInfo];

        
//    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"是否确定转让" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alertView show];
  }
}
- (void)forgetPassWorldTappend{
    
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
        VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
        //VerificationCode.timeout = GetCodeMaxTime;
        VerificationCode.isFindPassworld = 2;
        VerificationCode.initalClassName = NSStringFromClass([self class]);
        
        [self customPushViewController:VerificationCode customNum:0];
    });
    
}

@end
