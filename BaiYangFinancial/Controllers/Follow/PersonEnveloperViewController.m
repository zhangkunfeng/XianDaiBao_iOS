//
//  PersonEnveloperViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/5.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "PersonEnveloperViewController.h"
//#import "EnveloperPayView.h"
#import "XRPayPassWorldView.h"
#import "ChoosePersonViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "ForgetPassWdViewController.h"

//#define PersonEnveloperVCText @"个人红包"
@interface PersonEnveloperViewController ()<UITextFieldDelegate,XRPayPassWorldViewDelegate>

@property (copy,  nonatomic) NSString * friendUid;
@property (strong,nonatomic) XRPayPassWorldView * payPWDView;
@property (weak, nonatomic) IBOutlet UIView *firstGestrueView;
@property (weak, nonatomic) IBOutlet UITextField *editMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *sendMessageTF;
@property (weak, nonatomic) IBOutlet UILabel *slectPersonNameLab;
@property (weak, nonatomic) IBOutlet UILabel *enveloperMoneyLab;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;


- (IBAction)enveloperBtnClicked:(id)sender;

@end

@implementation PersonEnveloperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self resetSideBack];
    CustomMadeNavigationControllerView *personEnveloperVCTextView = [[CustomMadeNavigationControllerView alloc] initWithTitle:self.titleStr showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:personEnveloperVCTextView];
    
    
    UIButton * dobutBtn = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth-47, 20, 44, 44)];
    [dobutBtn setImage:[UIImage imageNamed:@"moneyChange_dobut"] forState:UIControlStateNormal];
    [dobutBtn addTarget:self action:@selector(dobutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [personEnveloperVCTextView addSubview:dobutBtn];
    
    [self.editMoneyTF addTarget:self action:@selector(editMoneyTFChanged) forControlEvents:UIControlEventEditingDidBegin|UIControlEventEditingChanged];
    [self returnTextBord];
    
    [self settingOtherOperation];
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack{
    [self customPopViewController:0];
}

- (void)dobutBtnClicked:(id)sender
{
    [self jumpToWebview:EnveloperRulesURL webViewTitle:@"好友红包规则"];
}

- (void)settingOtherOperation
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstViewTap:)];
    [self.firstGestrueView addGestureRecognizer:tap];
    
    _editMoneyTF.delegate = self;
//    _editMoneyTF.placeholder = [self.titleStr isEqualToString:@"随机红包"]?@"请输入红包金额":@"请输入红包金额";
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

- (void)firstViewTap:(UITapGestureRecognizer *)tap
{
//    NSLog(@"点击了选择联系人view");
    ChoosePersonViewController * chossePersonVC = [[ChoosePersonViewController alloc] init];
    chossePersonVC.selectPersonNameBlock = ^(NSString *bookName,NSString *friendUid){
        self.friendUid = friendUid?friendUid:@"";
        self.slectPersonNameLab.text = bookName?bookName:@"-";
    };
    [self customPushViewController:chossePersonVC customNum:0];
}

- (void)editMoneyTFChanged{
    
    NSString *tempStr = _editMoneyTF.text;
    if ([self.editMoneyTF.text doubleValue] > 50.0) {
        _editMoneyTF.text = @"50.00";
        tempStr = _editMoneyTF.text;
        [self errorPrompt:3.0 promptStr:@"红包最大限额50.00元"];
    }
    self.enveloperMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",[self.editMoneyTF.text floatValue]];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@----%lu----%@",textField.text, (unsigned long)range.length, string);
    BOOL isHaveDian = YES;

    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
//                    [self showError:@"亲，第一个数字不能为小数点"];
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
//                    [self showError:@"亲，您已经输入过小数点了"];
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
//                        [self showError:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            [self showError:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_editMoneyTF resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.enabled = YES;
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)enveloperBtnClicked:(id)sender {
    
    if (!self.friendUid) {
        [self errorPrompt:3.0 promptStr:@"请先选择领取人"];
        return;
    }
    
    if ([self.editMoneyTF.text doubleValue] < 0.01) {
        [self errorPrompt:3.0 promptStr:@"请填写红包金额"];
        return;
    }
    if ([self.editMoneyTF.text doubleValue] >50.00) {
        
        [self errorPrompt:3.0 promptStr:@"红包金额最大50"];
        
        return;
    }else{
        self.enveloperMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",[self.editMoneyTF.text floatValue]];
    }
    
    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPWDView];
}

#pragma mark - payPassworldViewDelegate
- (void)sureTappend{
    [self getEncryptionString];
}
- (void)cancelTappend{
    [self dismissPopupController];
}

- (void)forgetPassWorldTappend{
    [self.payPWDView clearUpPassword];
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);

    [self customPushViewController:VerificationCode customNum:0];
    
}
//获取交易密码加密字  秘钥
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    [weakSelf getEncryptionString];
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self showWithDataRequestStatus:@"处理中..."];
                [weakSelf sendFriendRedPacket];
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
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
/**
 *  发送红包接口  user/sendFriendRedPacket 参数 
 * @param uid 用户id
 * @param friendUid 好友id
 * @param amount 红包金额
 * @param type 1:普通红包 2：随机红包
 * @param title 红包名称 输入框信息
 * @param pwd   密码
 * @param businessType 100：安卓 101：ios
 */
#pragma mark - 发送红包接口
- (void)sendFriendRedPacket{
    
    NSString * title = self.sendMessageTF.text.length>0?
                       self.sendMessageTF.text:@"恭喜发财!";
    NSString * type  = [self.titleStr isEqualToString:@"普通红包"]?@"1":@"2";
    NSString * amount = [self.enveloperMoneyLab.text substringFromIndex:1];
    NSLog(@"%@",amount);
    NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                 @"sid":   getObjectFromUserDefaults(SID),
                                 @"at" :   getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"amount": amount,
                                 @"title" : title,
                                 @"type"  : type,
                                 @"friendUid"   :  self.friendUid,
                                 @"businessType":  @"101",
                                 @"pwd" : [NetManager TripleDES:self.payPWDView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey]};
    
    NSLog(@"发送红包接口参数：\n parameters = %@",parameters);
    
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/sendFriendRedPacket",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        [self.payPWDView clearUpPassword];
        NSLog(@"%@",responseObject);
        WS(weakSelf);
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                
                NSLog(@"发送红包接口后台返回数据 = %@",responseObject);
                [self cancelTappend];
                [self showWithSuccessWithStatus:@"发红包成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self customPopViewController:0];
                });
                
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf sendFriendRedPacket];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf sendFriendRedPacket];
                } withFailureBlock:^{
                    
                }];
            }else{
                 [self.payPWDView clearUpPassword];
                [self shakeView:_payPWDView];

                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                
            }
        }
    } fail:^{
         [self.payPWDView clearUpPassword];
        [self shakeView:_payPWDView];

        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
    
}

#pragma mark - setters && getters
- (XRPayPassWorldView *)payPWDView{
    if (!_payPWDView) {
        _payPWDView = [[XRPayPassWorldView alloc] init];
        _payPWDView.delegate = self;
    }
    [_payPWDView.textField becomeFirstResponder];
    return _payPWDView;
}
@end
