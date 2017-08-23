//
//  payView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/12.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "payView.h"
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 50  //每一个输入框的高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
@implementation payView

- (instancetype)initWithpayView:(NSString *)actionDescription howMuchmoney:(NSString *)moneyString theDelegate:(id<PayViewDelegate>)tagDelegate {
    self = [[[NSBundle mainBundle] loadNibNamed:@"payView" owner:self options:nil] lastObject];
    if (self) {
        self.payPassworldTF.layer.borderWidth = .5;
        self.payPassworldTF.layer.borderColor = LineBackGroundColor.CGColor;
        self.payPassworldTF.returnKeyType = UIReturnKeyDone;
        
        self.cancelButton.layer.borderWidth = .5;
        self.cancelButton.layer.borderColor = LineBackGroundColor.CGColor;

        
        //复制
        self.actionDescriptionLable.text = actionDescription;
        self.MoneyLable.text = [NSString stringWithFormat:@"¥ %.2f", [moneyString doubleValue]];
        //从本地获取手机号码
        NSUserDefaults *userDefaults = UserDefaults;
        NSString *valueString = [userDefaults objectForKey:MOBILE];
        self.userName.text = [NSString stringWithFormat:@"%@****%@", [valueString substringWithRange:NSMakeRange(0, 4)], [valueString substringWithRange:NSMakeRange(8, 3)]];
        if (iPhoneWidth == 320) {
            self.payViewWidthConstraint.constant = 280;
        }
        delegate = tagDelegate;

        CGRect rectFarm = self.frame;
        rectFarm.size.width = iPhoneWidth;
        rectFarm.size.height = iPhoneHeight;
        self.frame = rectFarm;

//        self.payPassworldTF.delegate = self;
//        [self.payPassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.passView addSubview:self.textField];
        [self initPwdTextField];

        return self;
    }
    return nil;
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
        _payPassStr = textField.text;
        
        [self gotoPayButtonAction:nil];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    _GotoNextButton.backgroundColor = LineBackGroundColor;
//    _GotoNextButton.userInteractionEnabled = NO;
    return YES;
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


//限制输入
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textField) {
        if (textField.text.length > 5) {
            textField.text = [textField.text substringToIndex:5];
        }
    }
   
}

#pragma mark - 点击屏幕空白区域收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//        [self endEditing:YES];
//    [self.textField resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    if ([textField.text length] > 5) {
        self.payButton.enabled = NO;
        [delegate PassworldcancelButtonAction];
        [delegate PassworldgotoPayButtonAction];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] length] > 5) {
        self.payButton.enabled = YES;
        [self.payButton setBackgroundColor:AppBtnColor];
    } else {
        self.payButton.enabled = NO;
        [self.payButton setBackgroundColor:RGB(127, 127, 127)];
    }
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
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] > 5) {
        self.payButton.enabled = YES;
        [self.payButton setBackgroundColor:AppBtnColor];
    } else {
        self.payButton.enabled = NO;
        [self.payButton setBackgroundColor:RGB(127, 127, 127)];
    }
}

- (IBAction)forgetPassworldButtonAction:(id)sender {
    [self.textField resignFirstResponder];
    self.forgetButton.enabled = NO;
    //[delegate PassworldcancelButtonAction];
    [delegate forgetPassworldButtonAction];
}
- (IBAction)cancelButtonAction:(id)sender {
    [delegate PassworldcancelButtonAction];
    [self clearUpPassword];
}
- (IBAction)gotoPayButtonAction:(id)sender {
    self.payButton.enabled = NO;
    //[delegate PassworldcancelButtonAction];
    [delegate PassworldgotoPayButtonAction];
}

@end
