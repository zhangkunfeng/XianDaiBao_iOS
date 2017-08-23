//
//  WithdrawViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "VerificationiPhoneCodeViewController.h"
#import "WithDrawDetailsViewController.h"
#import "WithdrawViewController.h"
#import "bankCardPublicView.h"
#import "payView.h"
//#import "XRPayPassWorldView.h"
#import "TransWithdrawMoney.h"
#import "ForgetPassWdViewController.h"

@interface WithdrawViewController () <PayViewDelegate,UITextFieldDelegate,TransWithdrawMoneyDelegate/*,XRPayPassWorldViewDelegate *//*改换*/>{
    payView *payview; //验证交易密码
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;//背景UIScrollView
@property (weak, nonatomic) IBOutlet UIView *bankCardView;           //银行卡界面
@property (weak, nonatomic) IBOutlet UILabel *availablecashLable;    //可提现金
@property (weak, nonatomic) IBOutlet UILabel *WithDrawFeeLable;      //提现手续费
@property (weak, nonatomic) IBOutlet UILabel *ComeMoneyLable;        //实际到账
@property (weak, nonatomic) IBOutlet UITextField *withdrawMoneyTF;   //输入提现金额
@property (weak, nonatomic) IBOutlet UILabel *WithDrawCountLable;    //剩余提现次数
@property (weak, nonatomic) IBOutlet UIView *iPhoneNumberView;       //客服热线 改  安全picc
@property (weak, nonatomic) IBOutlet UIButton *transWithdrawBtn;     //转可提现金额btn

@property (strong, nonatomic) TransWithdrawMoney * transWithdrawMoneyView; //转可提现view

- (IBAction)transWithdrawBtnClicked:(id)sender;
- (IBAction)SubmitButtonAction:(id)sender;
- (IBAction)WithdrawTimeButtonAction:(id)sender;//提现时间按钮点击方法
@end

@implementation WithdrawViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  //[self dismissWeidaiLoadAnimationView:self];
    [self hideMDErrorShowView:self];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.withdrawMoneyTF resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    _withdrawMoneyTF.returnKeyType = UIReturnKeyDone;
    [self returnTextBord];
    
    CustomMadeNavigationControllerView *WithdrawView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"提现" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:WithdrawView];

    !(iPhone4||iPhone5)?[_withdrawMoneyTF becomeFirstResponder]:0;
    
//    [self addSafetyViewToSubview:self.iPhoneNumberView];//后加  picc
    //获取提现次数和手续费
    [self getWithdrawInfo];

    //添加银行卡界面
    [self setViewallControlStyle];
    [self.withdrawMoneyTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)returnTextBord
{
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)getWithdrawInfo {
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID)
    };
    //加载中...
    [self showWeidaiLoadAnimationView:self];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/sumWithDraw", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getWithdrawInfo];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([self isLegalObject:responseObject[@"count"]]) {
                    if ([responseObject[@"count"] integerValue] >= 3) {
                        self.WithDrawCountLable.text = @"0";
                    } else {
                        self.WithDrawCountLable.text = [NSString stringWithFormat:@"%zd", 3 - [responseObject[@"count"] integerValue]];
                    }
                } else {
                    self.WithDrawCountLable.text = @"0";
                }

                if ([self isLegalObject:responseObject[@"fee"]]) {
                    if ([responseObject[@"fee"] integerValue] == 3) {
                        self.WithDrawFeeLable.text = @"2.00";
                    } else {
                        self.WithDrawFeeLable.text = [NSString stringWithFormat:@"%.02f", [responseObject[@"fee"] doubleValue]];
                    }
                } else {
                    self.WithDrawFeeLable.text = @"0.00";
                }
                //提现金额 相减
                
                if (![responseObject[@"availAmount"] isKindOfClass:[NSNull class]]) {
//                    self.availablecashLable.text = [NSString stringWithFormat:@"%.2f", [responseObject[@"availAmount"] doubleValue]];
                        self.availablecashLable.text = [Number3for1 formatAmount:responseObject[@"availAmount"]];
                } else {
                    if (self.availablecashString.length > 0) {
//                        self.availablecashLable.text = self.availablecashString;
                        self.availablecashLable.text = [Number3for1 formatAmount:self.availablecashString];
                    }
                }
                [self dismissWeidaiLoadAnimationView:self];
            } else {
                [self dismissWeidaiLoadAnimationView:self];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
        fail:^{
            [self dismissWeidaiLoadAnimationView:self];
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
        }];
}

- (void)setViewallControlStyle {
    //添加银行卡界面
    NSString *bankCardIcon = @"bankcardStyle_image.png";
    NSString *bankName = @"银行";
    NSString *bankCardNumber = @"***** **** **** ****";
    NSString *bankStyle = @"储蓄卡";
    if (![_userinfoDict[@"bank"] isKindOfClass:[NSNull class]]) {
        bankName = _userinfoDict[@"bank"];
    }
    
    if (![_userinfoDict[@"bankNo"] isKindOfClass:[NSNull class]]) {
        bankCardIcon = _userinfoDict[@"bankNo"];
    }

    if (![self isBlankString:_userinfoDict[@"accountHidden"]]) {
        bankCardNumber = _userinfoDict[@"accountHidden"];
    }

    bankCardPublicView *bankCardView = [[bankCardPublicView alloc] initWithsetBank:bankCardIcon bankCardName:bankName bankCardNumber:bankCardNumber bankCardStyle:bankStyle];
    [self.bankCardView addSubview:bankCardView];

//    [self addCustomServicesiPhoneNumberView:self.iPhoneNumberView viewController:self];
}
#pragma mark - 返回代理事件的处理
- (void)goBack {
    [self customPopViewController:0];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _withdrawMoneyTF) {
        
        if ([textField.text isEqualToString:@""] || [_withdrawMoneyTF.text isEqualToString:@""]) {
            self.ComeMoneyLable.text = @"0.00";
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
   NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([tempStr doubleValue] > [[Number3for1 forDelegateChar:self.availablecashLable.text] doubleValue]) {
        textField.enabled = NO;
        textField.text = self.availablecashLable.text;
        tempStr = [Number3for1 forDelegateChar:self.availablecashLable.text];
        [self errorPrompt:3.0 promptStr:@"输入金额超出可提现金额"];
    }
    self.ComeMoneyLable.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f" ,([tempStr doubleValue] - [self.WithDrawFeeLable.text doubleValue])]];
    
    textField.enabled = YES;
    
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        self.ComeMoneyLable.text = @"0.00";
   
        //判断是不是删除键
        return YES;
    }
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    // showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    //showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        //showMsg(@"最多两位小数");
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //showMsg(@"数据格式有误");
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"] && ![string isEqualToString:@"."]) {
        return NO;
    }else if (string.length < 1 && [string isEqual:@"."]){
        
        return NO;
    }else if ([string isEqual:@".."]){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   //上面都有参数
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_withdrawMoneyTF resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.enabled = YES;
    return YES;
}

#pragma mark - 屏幕上弹
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat toTopHeight;
         if(iPhone5) toTopHeight = -86.0f;
//    else if(iPhone6) toTopHeight = -35.0f;
    else if(iPhone4) toTopHeight = -175.0f;
    else toTopHeight = 0.0f;
 
    //键盘高度216
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, toTopHeight, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}
#pragma mark -屏幕恢复
- ( void )textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}

#pragma mark - 转可提现金额View视图
- (IBAction)transWithdrawBtnClicked:(id)sender {
    [self loadTransWithdrowData];
 }

#pragma mark - TransWithdrawMoneyDelegate
- (void)sureTappend:(NSString *)transWithdrawMoenyStr{
    
//    [self getEncryptionString];/*移除支付视图在下级页面处理[self cancelTappend]   不走秘钥*/
    [self sureTransWithdrawMoneyAfter:transWithdrawMoenyStr];
}

- (void)cancelTappend{
    [self dismissPopupController];
}

/*  参数
 *  widthdrawMoney 不用传0  用时传金额
 *  setp  传 1 获取提现信息  2 修改信息
 */
#pragma mark - 转可提现金额视图确定后操作
- (void)sureTransWithdrawMoneyAfter:(NSString *)transWithdrawMoneyString{
    
    NSDictionary *parameters = @{@"withdrawMoney": transWithdrawMoneyString,
                                 @"step"         : @"2",
                                 @"payPassword"  : @"IOS",
                                 @"uid"          : getObjectFromUserDefaults(UID),
                                 @"at"           : getObjectFromUserDefaults(ACCESSTOKEN)};
    
   [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@account/changeWithdraw",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"%@",responseObject);
                [self showWithSuccessWithStatus:@"转提现操作成功!"];
                [self cancelTappend];//取消转提现视图
                [self getWithdrawInfo];//刷新视图
               
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTransWithdrawMoneyAfter:transWithdrawMoneyString];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTransWithdrawMoneyAfter:transWithdrawMoneyString];
                } withFailureBlock:^{
                    
                }];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}

/*
 {
	r = 1,
	disAvalCash = 2060.01, 不保兑金额
	availablecash = 0,  保兑金额
	factorage = 0.005,  费率
	msg = 成功！
 }
*/

#pragma mark - 加载前往转可提现金额view数据
- (void)loadTransWithdrowData{
    
    NSDictionary *parameters = @{@"withdrawMoney":   @"0",
                                 @"step"         :   @"1",
                                 @"uid"          :   getObjectFromUserDefaults(UID),
                                 @"at"           :   getObjectFromUserDefaults(ACCESSTOKEN)};
    
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@account/changeWithdraw",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                //                [self cancelTappend];/*移除支付视图<-->*/
                //                [KVNProgress dismiss];/*隐藏提示视图<-->*/
//                NSLog(@"%@",responseObject);
                [self dismissWithDataRequestStatus];
                
                NSString * disAvalCash, * factorage; //不可提现金额  费率
                if ([self isLegalObject:responseObject[@"disAvalCash"]]) {
                    disAvalCash = responseObject[@"disAvalCash"];
                }else{
                    disAvalCash = @"";
                }
                
                if ([self isLegalObject:responseObject[@"factorage"]]) {
                    factorage = responseObject[@"factorage"];
                }else{
                    factorage = @"";
                }
                
                self.transWithdrawMoneyView =[[TransWithdrawMoney alloc] initWithTransWithdrawMoneyViewDisAvalCash:disAvalCash factorage:factorage viewController:self theDelegate:self];
                
                //转可提现金额 View
                [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.transWithdrawMoneyView];
               
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadTransWithdrowData];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadTransWithdrowData];
                } withFailureBlock:^{
                    
                }];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}


- (IBAction)SubmitButtonAction:(id)sender {
    
//    NSLog(@"实际到账 = %f",[[Number3for1 forDelegateChar:self.ComeMoneyLable.text] doubleValue]);
//    NSLog(@"可提现金额 = %f",[[Number3for1 forDelegateChar:self.availablecashLable.text] doubleValue]);
//    NSLog(@"手续费 = %f",[[Number3for1 forDelegateChar:self.WithDrawFeeLable.text] doubleValue]);
    
//    [self.withdrawMoneyTF resignFirstResponder];//收回键盘 xgy注释

    if ([self.withdrawMoneyTF.text doubleValue] == 0) {
        [self errorPrompt:3.0 promptStr:@"请输入提现金额"];
    } else if ([self.withdrawMoneyTF.text doubleValue] < 2) {
        [self errorPrompt:3.0 promptStr:@"提现最低金额2元"];
    } else if ([[Number3for1 forDelegateChar:self.ComeMoneyLable.text] doubleValue] > ([[Number3for1 forDelegateChar:self.availablecashLable.text] doubleValue] - [[Number3for1 forDelegateChar:self.WithDrawFeeLable.text] doubleValue])) {
        
        [self errorPrompt:3.0 promptStr:@"可提金额不足"];
    } else {
        payview = [[payView alloc] initWithpayView:@"提现" howMuchmoney:self.ComeMoneyLable.text theDelegate:self];
        [self showPopupWithStyle:CNPPopupStyleCentered popupView:payview];
        [payview.payPassworldTF becomeFirstResponder];
        [payview.textField becomeFirstResponder];
    }
}

- (IBAction)WithdrawTimeButtonAction:(id)sender {
    [self jumpToWebview:AboutDetailURL webViewTitle:@"提现规则说明"];
}

#pragma mark - PayViewDelegate
- (void)PassworldcancelButtonAction {
    [self dismissPopupController];
}

- (void)PassworldgotoPayButtonAction {
    
    
    //[payview.textField resignFirstResponder];
    if ([self isBlankString:payview.textField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入支付密码"];
    } else {
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"uid": getObjectFromUserDefaults(UID),
                                      @"amount": [NSString stringWithFormat:@"%.2f", [self.withdrawMoneyTF.text doubleValue]],
                                      @"businessType": @"101",
                                      @"payPassword": [NetManager TripleDES:payview.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]
        };
        [self showWithDataRequestStatus:@"提现校验中..."];
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/withDrawOperation", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            [payview clearUpPassword];
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf PassworldgotoPayButtonAction];
                    }
                        withFailureBlock:^{

                        }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self dismissWithDataRequestStatus];
                    [self PassworldcancelButtonAction];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        WithDrawDetailsViewController *withDrawView = [[WithDrawDetailsViewController alloc] init];
                        withDrawView.titleString = @"提现";
                        withDrawView.pushNumber = 1;
                        withDrawView.userInfodict = [_userinfoDict copy];
                        withDrawView.payMonryString = self.withdrawMoneyTF.text;
                        [self customPushViewController:withDrawView customNum:0];
                    });
                   
                } else {
                    [payview clearUpPassword];
                    [self shakeView:payview];
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                    
                }
            }
        }
            fail:^{
                [payview clearUpPassword];
           [self shakeView:payview];
                [self errorPrompt:3.0 promptStr:@"提交失败，请稍后再试"];
               
            }];
    }
}
-(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

- (void)forgetPassworldButtonAction {
    [payview clearUpPassword];
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);
    [self customPushViewController:VerificationCode customNum:0];
}

@end
