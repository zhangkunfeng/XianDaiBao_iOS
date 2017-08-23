//
//  TradePswViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "TradePswViewController.h"
#import "setPaymentPassWorldViewController.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 50  //每一个输入框的高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width

@interface TradePswViewController ()<UITextFieldDelegate>{
    
    NSString *_oldPassWord;
    NSString *_nePassWord;
    NSString *_aginPassWord;
    
}
@property (nonatomic, assign)BOOL isHavePayPassworld;
@property (weak, nonatomic) IBOutlet UIView *passview;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@property (weak, nonatomic) IBOutlet UILabel *tiShiLab;

@property (nonatomic, strong) NSString *payPassStr;
@property (nonatomic, strong) NSString *firstPassStr;
@property (nonatomic, strong) NSString *againPassStr;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,assign)NSInteger clickBtn;
@property (nonatomic, strong)NSString *oneStr;
@property (nonatomic, strong)NSDictionary *accinfoDict;


@end

@implementation TradePswViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:self.title];
     [self loadSettingData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
    [AFNetworkTool cancelAllHTTPOperations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     [self resetSideBack];

    // Do any additional setup after loading the view from its nib.
    self.clickBtn = 0;
    [self.saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"支付密码修改" showBackButton:YES showRightButton:YES rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
//    [self.oldPassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.NewpassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   // [self.againPassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passview addSubview:self.textField];
    [self initPwdTextField];
}


- (void)loadSettingData {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadSettingData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadSettingData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _accinfoDict = [responseObject[@"item"] copy];
                if (_accinfoDict != nil) {
                    if (![_accinfoDict[@"pay"] isKindOfClass:[NSNull class]] && [_accinfoDict[@"pay"] integerValue] == 1) {
                        _isHavePayPassworld = YES;
                    }else{
                    
                        [self setPaymentPassWordController];
                    }
                    
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                [self errorPrompt:3.0 promptStr:errorPromptString];
                                  
                              }];
}

- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            _isHavePayPassworld = YES;
        }
    };
    [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [self customPushViewController:setPaymentPassWorldView customNum:1];
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (kUIScreenWidth - 32) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), 1, K_Field_Height)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.passview addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.passview addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange111:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange111:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕走这里");
        //！！！！！！！！！！！！！！！！！！！！！！！！！！
        //这里给一个全局的值保存这个6位数字的值就行
        
//        if (_payPassStr.length <= kDotCount) {
//            _payPassStr = textField.text;
//        }else if (_firstPassStr.length <= kDotCount) {
//            _firstPassStr = textField.text;
//        }else {
//            _againPassStr = textField.text;
//        }\
        
    }
}




#pragma mark - init
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 5, kUIScreenWidth - 32, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange111:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    } else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"]) {
        return NO;
    } else {
        return YES;
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}
//TODO:返回按钮
- (void)goBack{
    [self customPopViewController:0];
}



-(void)saveBtn:(UIButton *)sender{
    
    if (self.clickBtn == 0) {
        //第一次点击的时候操作
        if (self.textField.text.length !=6) {
             [self errorPrompt:3.0 promptStr:@"请输入6位数密码"];
            return;
        }else{
        _oldPassWord = self.textField.text;
        self.tiShiLab.text = @"请输入新密码";
            [_saveBtn setTitle:@"新密码" forState:UIControlStateNormal];
        self.clickBtn = 1;
        [self clearUpPassword];
        }
    }else if (self.clickBtn == 1){
        //第二次点击的时候操作
        if (self.textField.text.length != 6) {
            [self errorPrompt:3.0 promptStr:@"请输入6位数新密码"];
            return;
        }else{
        _nePassWord = self.textField.text;
        self.tiShiLab.text = @"请确认新密码";
             [_saveBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.clickBtn = 2;
            [self clearUpPassword];}
    }else{
        //第三次点击的时候操作
        if (self.textField.text.length != 6 || ![self.textField.text isEqualToString:_nePassWord]) {
            [self errorPrompt:3.0 promptStr:@"两次密码输入不同"];
        }else{
        _aginPassWord = self.textField.text;
            _saveBtn.userInteractionEnabled = NO;
            self.clickBtn = 0;
            [self setPayPassworld];
        }
    }
    
    
}



- (void)setPayPassworld{
    NSDictionary *parameters = @{@"uid":          getObjectFromUserDefaults(UID),
                                 @"sid":          getObjectFromUserDefaults(SID),
                                 @"at":           getObjectFromUserDefaults(ACCESSTOKEN)
                                 };
    //加载动画
    WS(weakSelf);
    [self showWithDataRequestStatus:@"设置密码中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf setPayPassworld];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf setPayPassworld];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                if (![responseObject[@"sedpassed"] isKindOfClass:[NSNull class]]) {
                    _sedpassedString = responseObject[@"sedpassed"];
                    [self setNewpayPassworld];
                }else{
                    [self dismissWithDataRequestStatus];
                }
            }else{
                [self dismissWithDataRequestStatus];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self dismissWithDataRequestStatus];
    }];
}

//TODO:点击屏幕让键盘下去
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 修改交易密码
- (void)setNewpayPassworld{
    NSDictionary *parameters = @{@"uid":          getObjectFromUserDefaults(UID),
                                 @"sid":          getObjectFromUserDefaults(SID),
                                 @"at":           getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"newPay":     /*  [WDEncrypt md5FromString:self.NewpassworldTF.text]*/  [NetManager TripleDES:_nePassWord encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 @"oldPwd":     /*  [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@",[WDEncrypt md5FromString:self.oldPassworldTF.text],_sedpassedString]]  */[NetManager TripleDES:_oldPassWord encryptOrDecrypt:kCCEncrypt key:K3DESKey]
                                 };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/modTradePwd",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf setNewpayPassworld];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf setNewpayPassworld];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self showWithSuccessWithStatus:@"支付密码修改成功"];
                [self performSelector:@selector(goBack) withObject:nil afterDelay:3.0f];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                NSLog(@"....%@",responseObject[@"msg"]);
                [self clearUpPassword];
                _saveBtn.userInteractionEnabled = YES;
                [_saveBtn setTitle:@"请输入支付密码" forState:UIControlStateNormal];
                _tiShiLab.text = @"请输入原密码";
                self.clickBtn = 0;
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:@"修改失败，请重试"];
    }];
}

@end
