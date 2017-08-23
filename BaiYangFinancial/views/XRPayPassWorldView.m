//
//  payPassWorldView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/6/19.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "XRPayPassWorldView.h"
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 50  //每一个输入框的高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width

@interface XRPayPassWorldView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYconstraint;
- (IBAction)cancelButonAction:(id)sender;
- (IBAction)sureButtonAction:(id)sender;
- (IBAction)forgetPassWorldButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *passView;

@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@property (nonatomic, strong) NSString *payPassStr;


@end

@implementation XRPayPassWorldView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"XRPayPassWorldView" owner:self options:nil] lastObject];
    if (self) {
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
        
        [self settingTextFieldXianZhiNum];
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
    _payPassStr = textField.text;
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕走这里");
        //！！！！！！！！！！！！！！！！！！！！！！！！！！
        //这里给一个全局的值保存这个6位数字的值就行
        
        [self sureButtonAction:nil];
        
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

//限制输入
- (void)settingTextFieldXianZhiNum
{
  [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.textField resignFirstResponder];
}

- (IBAction)cancelButonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelTappend)]) {
        [self.delegate cancelTappend];
        [self clearUpPassword];
    }
}

- (IBAction)sureButtonAction:(id)sender {
//支付视图判断
    
    if ([self.delegate respondsToSelector:@selector(sureTappend)]) {
        if (_payPassStr.length == 0) {
            [KVNProgress showErrorWithStatus:@"请输入密码"];
        }else if (_payPassStr.length < 6){
            [KVNProgress showErrorWithStatus:@"支付密码少于6位"];
        }else{
            [self.delegate sureTappend];
                       
        }
        
    }
}

- (IBAction)forgetPassWorldButtonAction:(id)sender {
    [self.textField resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(forgetPassWorldTappend)]) {
            [self.delegate forgetPassWorldTappend];
        }
    });
}
#pragma mark ---- UITextFieldDelegate -----
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
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(sureTappend)]) {
        
        [self.delegate sureTappend];
       
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (iPhoneWidth == 320) {
        [UIView animateWithDuration:1.0 animations:^{
            self.centerYconstraint.constant = -40;
        }];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (iPhoneWidth == 320) {
        [UIView animateWithDuration:1.0 animations:^{
            self.centerYconstraint.constant = 0;
        }];
    }
}



@end
