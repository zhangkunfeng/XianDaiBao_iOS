//
//  payPassWorldView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/6/19.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "TransWithdrawMoney.h"
@interface TransWithdrawMoney () <UITextFieldDelegate>
{
     BaseViewController *_viewController;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYconstraint;
- (IBAction)cancelButonAction:(id)sender;
- (IBAction)sureButtonAction:(id)sender;

@end

@implementation TransWithdrawMoney

- (void)awakeFromNib
{
    [super awakeFromNib];
    //colorTitleLabel setting
    UIBezierPath *maskPath_t = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, iPhoneWidth-50, 50)/*本_transWithDrawLabel.frame 如下*/
                                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                           cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer_t = [[CAShapeLayer alloc] init];
    maskLayer_t.path = maskPath_t.CGPath;
    _transWithDrawLabel.layer.mask = maskLayer_t;
//    NSLog(@"%@",NSStringFromCGRect(_transWithDrawLabel.frame));//指定 xib 328值 不变不适配
}

- (instancetype)initWithTransWithdrawMoneyViewDisAvalCash:(NSString *)disAvalCash factorage:(NSString *)factorage  viewController:(UIViewController *)viewController  theDelegate:(id<TransWithdrawMoneyDelegate>)tagDelegate {
    self = [[[NSBundle mainBundle] loadNibNamed:@"TransWithdrawMoney" owner:self options:nil] lastObject];
    if (self) {
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
        self.transMoneyTextFeild.delegate = self;
        self.delegate = tagDelegate;//必须指定 否则不走
        
        [self.transMoneyTextFeild becomeFirstResponder];
        
        _viewController = (BaseViewController *) viewController;
        
        self.noTransWithdrawMoneyLabel.text = [Number3for1 formatAmount:disAvalCash]; //不可提现
        self.premiumRateLabel.text = [NSString stringWithFormat:@"%.1f",[factorage doubleValue] * 100];//费率
        [self settingTextFieldXianZhiNum];
        
        return self;
    }
    return nil;
}

//限制输入
- (void)settingTextFieldXianZhiNum
{
  [self.transMoneyTextFeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField //用处不大  自动转为最大可提数  可注
{
    if (textField == self.transMoneyTextFeild) {
//        self.shiJiLab.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f" ,[textField.text doubleValue] - [self.commissionMoneyLabel.text doubleValue]]] ;
//        self.commissionMoneyLabel.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f" ,[textField.text doubleValue] / 100 * [self.premiumRateLabel.text doubleValue]]] ;
        
        if ([textField.text isEqualToString:@""]) {
            self.shiJiLab.text = @"0.00";
            self.commissionMoneyLabel.text = @"0,00";
        }
        

        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.transMoneyTextFeild resignFirstResponder];
}

- (IBAction)cancelButonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelTappend)]) {
        [self.delegate cancelTappend];
    }
}

- (IBAction)sureButtonAction:(id)sender {
    [self.transMoneyTextFeild resignFirstResponder];//收回键盘
    
    if ([self.transMoneyTextFeild.text doubleValue] == 0) {
        [_viewController errorPrompt:3.0 promptStr:@"请输入转提现金额"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(sureTappend:)]) {
        [self.delegate sureTappend:self.transMoneyTextFeild.text];
    }
}

/*
 UITextField *transMoenyTextFeild;
 UILabel *commissionMoneyLabel;//手续费金额
 UILabel *premiumRateLabel;//费率数
 UILabel *noTransWithdrawMoneyLabel;//不可提现金额数
 */
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    
    //输入金额
    NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([tempStr doubleValue] > [[Number3for1 forDelegateChar:self.noTransWithdrawMoneyLabel.text] doubleValue]) {
        textField.enabled = NO;
        textField.text = self.noTransWithdrawMoneyLabel.text;
        tempStr = [Number3for1 forDelegateChar:self.noTransWithdrawMoneyLabel.text];
        [_viewController errorPrompt:3.0 promptStr:@"输入金额超出转可提现金额"];
    }
    
    //手续费金额
    self.commissionMoneyLabel.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f" ,[tempStr doubleValue] / 100 * [self.premiumRateLabel.text doubleValue]]] ;
    
    textField.enabled = YES;
    
    self.shiJiLab.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f" ,[tempStr doubleValue] - [self.commissionMoneyLabel.text doubleValue]]] ;
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
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

//点击 done 触发事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
   
    if ([textField.text doubleValue] == 0) {
        [_viewController errorPrompt:3.0 promptStr:@"请输入转可提现金额"];
        return 0;
    }
    if ([self.delegate respondsToSelector:@selector(sureTappend:)]) {
        [self.delegate sureTappend:self.transMoneyTextFeild.text];
    }
     
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat Yconstant = 0.0f;
    if (iPhoneWidth == 320) {
        if (iPhone4)  Yconstant = -45.0f;
        else  Yconstant = -31.0f;
    }
 
//    if (iPhoneWidth == 375) {
//        Yconstant = -45.0f;
//    }
//
//    if (iPhoneWidth == 414) {//iPhone 6Plus  1242 @3x
//        Yconstant = -45.0f;
//    }
    
    [UIView animateWithDuration:1.0 animations:^{
        self.centerYconstraint.constant = Yconstant;
    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (iPhoneWidth == 320 /*|| iPhoneWidth == 375 || iPhoneWidth == 414*/) {
        [UIView animateWithDuration:1.0 animations:^{
            self.centerYconstraint.constant = 0;
        }];
    }
    
}

@end
