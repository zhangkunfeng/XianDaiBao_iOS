//
//  CalculatorView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/12/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "CalculatorView.h"

static NSInteger denoButtonTag = 10000;

@interface CalculatorView ()<UITextFieldDelegate>

@property (nonatomic, copy)NSDictionary *calculatorDict;
@property (nonatomic, strong)UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UILabel *DeadlineLable;
@property (weak, nonatomic) IBOutlet UILabel *DisplayMoneyLable;
@property (weak, nonatomic) IBOutlet UIButton *calculatorButton;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)calculatorButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentYAlignmentConstraint;

@end

@implementation CalculatorView
@synthesize doneButton;

- (instancetype)initWithCalculatorView:(id<CalculatorViewDelegate>)theDelegate calculatorDict:(NSDictionary *)dataDict{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:self options:nil] lastObject];
    if(self){
        CGRect calculatorFrame = self.frame;
        calculatorFrame.size.width = iPhoneWidth;
        calculatorFrame.size.height = iPhoneHeight;
        self.frame = calculatorFrame;
        self.DeadlineLable.text = dataDict[@"Deadline"];
        self.rightTextField.text = dataDict[@"DeadlineNumber"];
        self.calculatorDict = [dataDict copy];
        
        UIImageView *leftImafeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calculatorLeftImage"]];
        self.leftTextField.leftView = leftImafeView;
        self.leftTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calculatorRightImage"]];
        self.rightTextField.leftView = rightImageView;
        self.rightTextField.leftViewMode = UITextFieldViewModeAlways;
        
        self.contentView.layer.cornerRadius = 6.0;
        self.calculatorButton.layer.cornerRadius = 5.0;
        
        self.leftTextField.delegate = self;
        
        delegate = theDelegate;
        
        //自定义键盘
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowOnDelay:) name:UIKeyboardWillShowNotification object:nil];
        return self;
    }
    return nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (iPhoneHeight <= 568) {
        [UIView animateWithDuration:1.0 animations:^{
            self.contentYAlignmentConstraint.constant = iPhoneHeight/2 - (iPhoneHeight - 440 + 110);
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (iPhoneHeight <= 568) {
        [UIView animateWithDuration:1.0 animations:^{
            self.contentYAlignmentConstraint.constant = 0;
        }];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString *NumberString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([NumberString doubleValue] > [self.calculatorDict[@"bidAmount"] doubleValue]) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.leftTextField resignFirstResponder];
    [self removeDoneButtonFromNumPadKeyboard];
    if ([self.leftTextField.text doubleValue] > 0) {
        self.DisplayMoneyLable.text = [NSString stringWithFormat:@"%.2f",([self.leftTextField.text doubleValue] / [self.calculatorDict[@"bidAmount"] doubleValue]) * [self.calculatorDict[@"bidProfitAmount"] doubleValue]];
    }else{
        self.DisplayMoneyLable.text = @"0.00";
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.leftTextField resignFirstResponder];
    [self removeDoneButtonFromNumPadKeyboard];
    [delegate initWithCalculatorCancelAction];
    self.leftTextField.text = @"";
    self.DisplayMoneyLable.text = @"0.00";
}

- (IBAction)calculatorButtonAction:(id)sender {
    [self.leftTextField resignFirstResponder];
    [self removeDoneButtonFromNumPadKeyboard];
    if ([self.leftTextField.text doubleValue] > 0) {
        /*输入数/标的总额*总收益数*/
        self.DisplayMoneyLable.text = [NSString stringWithFormat:@"%.2f",([self.leftTextField.text doubleValue] / [self.calculatorDict[@"bidAmount"] doubleValue]) * [self.calculatorDict[@"bidProfitAmount"] doubleValue]];
    }
}
- (void)keyboardWillShowOnDelay:(NSNotification *)notification
{
    [self performSelector:@selector(keyboardWillShow:) withObject:nil afterDelay:0];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self addDoneButtonToNumPadKeyboard];
}

- (void)addDoneButtonToNumPadKeyboard
{
    if (!doneButton) {
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    if (iOS8){
        doneButton.frame = CGRectMake(0, iPhoneHeight-53, iPhoneWidth/3, 53);
    }else{
        doneButton.frame = CGRectMake(0, 163, iPhoneWidth/3, 53);
    }
    doneButton.tag = denoButtonTag;
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setTitle:@"." forState:UIControlStateNormal];
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *windowArr = [[UIApplication sharedApplication] windows];
    if (windowArr != nil && windowArr.count > 1){
        UIWindow *needWindow = [windowArr objectAtIndex:1];
        UIView *keyboard;
        for(int i = 0; i < [needWindow.subviews count]; i++) {
            keyboard = [needWindow.subviews objectAtIndex:i];
            NSLog(@"%@", [keyboard description]);
            if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) || ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) || ([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)){
                
                UIView *doneButtonView = [keyboard viewWithTag:denoButtonTag];
                if (doneButtonView == nil){
                    [keyboard addSubview:doneButton];
                }
            }
        }
    }
}

- (void)doneButton:(UIButton *)btn{
    //    NSLog(@"kongyu");
    //    [self.txt resignFirstResponder];
    if ([self.leftTextField.text rangeOfString:@"."].location == NSNotFound) {
        self.leftTextField.text = [NSString stringWithFormat:@"%@.",self.leftTextField.text];
    }
}

- (void)removeDoneButtonFromNumPadKeyboard
{
    UIView *doneButton1 = nil;
    
    NSArray *windowArr = [[UIApplication sharedApplication] windows];
    if (windowArr != nil && windowArr.count > 1){
        UIWindow *needWindow = [windowArr objectAtIndex:1];
        UIView *keyboard;
        for(int i = 0; i < [needWindow.subviews count]; i++) {
            keyboard = [needWindow.subviews objectAtIndex:i];
            if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) || ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) || ([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)){
                doneButton1 = [keyboard viewWithTag:denoButtonTag];
                if (doneButton1 != nil){
                    [doneButton1 removeFromSuperview];
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
