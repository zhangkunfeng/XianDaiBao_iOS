//
//  setPaymentPassWorldViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "setPaymentPassWorldViewController.h"

#define TEXTCOLOR [self colorFromHexRGB:@"B7B7B7"]
#define TEXTFONT [UIFont systemFontOfSize:15.0]
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 50  //每一个输入框的高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
@interface setPaymentPassWorldViewController ()<UITextFieldDelegate>{
    
    NSString *_oldPassWord;
    NSString *_nePassWord;
    NSString *_aginPassWord;
    
}


@property (nonatomic, strong) UITextField *passWorldField;
@property (nonatomic, strong) UITextField *aginePassWorldField;

@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;//提示
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

@property (nonatomic, strong) NSString *payPassStr;
@property (nonatomic, strong) NSString *firstPassStr;
@property (nonatomic, strong) NSString *againPassStr;
@property (nonatomic,assign)NSInteger clickBtn;
@property (nonatomic, strong)NSString *oneStr;
@property (nonatomic, strong)NSDictionary *accinfoDict;
@end

@implementation setPaymentPassWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomMadeNavigationControllerView *setPaymentPassWorldView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"设置支付密码" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:setPaymentPassWorldView];

//    [self addSafetyViewToSubview:self.safeView];
//    [self addCustomServicesiPhoneNumberView:self.iPhoneNumberView viewController:self];
    
    _passWorldField.delegate = self;
    _aginePassWorldField.delegate = self;
    
    
    [self.aginePassWorldField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.clickBtn = 0;
    [self.commitBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.passView addSubview:self.textField];
    [self initPwdTextField];
}
- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (kUIScreenWidth - 32) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), 1, K_Field_Height)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.passView addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.passView addSubview:dotView];
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
    [self textFieldDidChange1111:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange1111:(UITextField *)textField
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
        [_textField addTarget:self action:@selector(textFieldDidChange1111:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(void)saveBtn:(UIButton *)sender{
//    if (self.clickBtn == 0) {
//        //第一次点击的时候操作
//        if (self.textField.text.length !=6) {
//            [self errorPrompt:3.0 promptStr:@"请输入6位数密码"];
//            return;
//        }else{
//            _oldPassWord = self.textField.text;
//            self.promptLab.text = @"请输入新密码";
//            [_commitBtn setTitle:@"新密码" forState:UIControlStateNormal];
//            self.clickBtn = 1;
//            [self clearUpPassword];
//        }
//    }else
    
if (self.clickBtn == 0){
        //第二次点击的时候操作
        if (self.textField.text.length != 6) {
            [self errorPrompt:3.0 promptStr:@"请输入6位数密码"];
            return;
        }else{
            _nePassWord = self.textField.text;
            self.promptLab.text = @"请确认新密码";
            [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
            self.clickBtn = 1;
            [self clearUpPassword];
        }
    }else{
        //第三次点击的时候操作
        if (self.textField.text.length != 6 || ![self.textField.text isEqualToString:_nePassWord]) {
            [self errorPrompt:3.0 promptStr:@"两次密码输入不同"];
        }else{
            _aginPassWord = self.textField.text;
            _commitBtn.userInteractionEnabled = NO;
            self.clickBtn = 0;
            if (_set == 2) {
                [self forGsetPayPassworld];
            }else{
            [self setPayPassworld];
            }
            
            
        }
    }
    
}
//}

#pragma mark---- 点击屏幕空白区域收起键盘  ----
- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 返回代理方法
- (void)goBack {
    if (_set == 2) {
        [self customPopViewController:3];
    }else{
        [self customPopViewController:1];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _textField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
        if([string isEqualToString:@"\n"]) {
            //按回车关闭键盘
            [textField resignFirstResponder];
            return NO;
        } else if(string.length == 0) {
            //判断是不是删除键
            return YES;
        } else if(textField.text.length >= 6) {
            //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
            NSLog(@"输入的字符个数大于6，忽略输入");
            return NO;
        } else if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"]) {
            return NO;
        } else {
            return YES;
        }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 确认按钮
//- (IBAction)SetPassworlduserButtonAction:(id)sender {
//    if (_textField.text.length < 6) {
//        [self errorPrompt:3.0 promptStr:@"请输入6位支付密码"];
//        return;
//    }
//    if (![_passWorldField.text isEqualToString:_aginePassWorldField.text]) {
//        [self errorPrompt:3.0 promptStr:@"两次输入不一致"];
//        return;
//    }
//    [self setPayPassworld];
//}

#pragma mark - 去提交新的交易密码
- (void)setPayPassworld {
    [_textField resignFirstResponder];
    //[_aginePassWorldField resignFirstResponder];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"newPay": [NetManager TripleDES:_aginPassWord encryptOrDecrypt:kCCEncrypt key:K3DESKey]
    };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/tradePwd", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf setPayPassworld];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf setPayPassworld];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                self.backUpView(YES);
                [self showWithSuccessWithStatus:@"支付密码设置成功"];

                if (_set == 2) {
                    [self comePopViewControllerWithAnimation:YES CustomPushIndex:[self.navigationController.viewControllers count]-3];//2 - 1
                }else{
                    [self customPopViewController:1];
                }
               
                
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                
                [self clearUpPassword];
                _commitBtn.userInteractionEnabled = YES;
                [_commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
                _promptLab.text = @"请输入新密码";
                self.clickBtn = 0;

            }
        }
    }
        fail:^{
            [self clearUpPassword];
            _commitBtn.userInteractionEnabled = YES;
            [_commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
            _promptLab.text = @"请输入新密码";
            self.clickBtn = 0;

            [self errorPrompt:3.0 promptStr:errorPromptString];
        }];
}

#pragma mark - 去提交新的交易密码
- (void)forGsetPayPassworld {
    [_textField resignFirstResponder];
    
    [self showWithDataRequestStatus:@"设置支付密码中..."];
   
   NSDictionary * parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                    @"uid": getObjectFromUserDefaults(UID),
                    @"sid": getObjectFromUserDefaults(SID),
                    @"code": [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", _iPhoneCodeString, getObjectFromUserDefaults(ACCESSTOKEN)]],
                    @"newPay": /*[WDEncrypt md5FromString:self.passWorldTextField.text]*/  [NetManager TripleDES:_aginPassWord encryptOrDecrypt:kCCEncrypt key:K3DESKey]
                    };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/resetTradePwd", GeneralWebsite] parameters:parameters success:^(id responseObject) {
      
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf forGsetPayPassworld];
                }
                                                                     withFailureBlock:^{
                                                                         
                                                                     }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf forGsetPayPassworld];
                }
                                                                 withFailureBlock:^{
                                                                     
                                                                 }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                self.backUpView(YES);
                [self showWithSuccessWithStatus:@"支付密码设置成功"];
                
                //区分开模态进入和压栈进入 1 & 0
                if (_set == 2) {
                    [self comePopViewControllerWithAnimation:YES CustomPushIndex:[self.navigationController.viewControllers count]-3];//2 - 1
                }else{
                    [self customPopViewController:1];
                }
                
            } else {
                 [self dismissWithDataRequestStatus];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                
                [self clearUpPassword];
                _commitBtn.userInteractionEnabled = YES;
                [_commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
                _promptLab.text = @"请输入新密码";
                self.clickBtn = 0;
                
            }
        }
    
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self clearUpPassword];
                                  _commitBtn.userInteractionEnabled = YES;
                                  [_commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
                                  _promptLab.text = @"请输入新密码";
                                  self.clickBtn = 0;

                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}



@end
