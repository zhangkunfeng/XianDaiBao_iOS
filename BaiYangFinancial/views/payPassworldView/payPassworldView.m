//
//  payPassworldView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/26.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "payPassworldView.h"

@implementation payPassworldView

- (id)initWithpayPassworldView:(id<payPassworldViewDelegate>)theDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"payPassworldView" owner:self options:nil] lastObject];
    if (self) {
        CGRect rectFram = self.frame;
        rectFram.size.height = iPhoneHeight;
        rectFram.size.width = iPhoneWidth;
        self.frame = rectFram;
        
        self.payPassworldTF.delegate = self;
        self.payPassworldTF.layer.borderWidth = 0.5;
        self.payPassworldTF.layer.borderColor = LineBackGroundColor.CGColor;
        
        delegate = theDelegate;
        
//        self.payPassWorldAlignmentYConstraint.constant = (iPhoneHeight - 173 - 300)/2;
    }
    return self;
}

#pragma mark - 点击屏幕空白区域收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [delegate payPassworldViewConfirm];
    return YES;
}

- (IBAction)cancelButtonAction:(id)sender {
    [delegate payPassworldViewCancel];
}

- (IBAction)ConfirmButtonAction:(id)sender {
    [delegate payPassworldViewConfirm];
}
@end
