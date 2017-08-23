//
//  payView.m
//  weidaiwang
//
//  Created by 艾运旺 on 15/8/12.
//  Copyright (c) 2015年 艾运旺. All rights reserved.
//

#import "payView.h"

@implementation payView

-(id)initWithpayView:(NSDictionary *)payDict theDelegate:(id<PayViewDelegate>) tagDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"payView" owner:self options:nil] lastObject];
    if (self) {
        self.payPassworldTF.layer.borderWidth = .5;
        self.payPassworldTF.layer.borderColor = LineBackGroundColor.CGColor;
        
        self.cancelButton.layer.borderWidth = .5;
        self.cancelButton.layer.borderColor = LineBackGroundColor.CGColor;
        
        
        self.bankNameTF.delegate = self;
        //添加左边图片
        UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03080000"]];
        self.bankNameTF.leftView = UserNameleftImageView;
        self.bankNameTF.leftViewMode = UITextFieldViewModeAlways;
        
        self.bankNameTF.text = @"招商银行(6222************678)";
        
        if (iPhoneWidth == 320) {
            self.payViewWidthConstraint.constant = 280;
            self.bankNameTF.font = [UIFont systemFontOfSize:16.0f];
        }
    }
    CGRect rectFarm = self.frame;
    rectFarm.size.width = iPhoneWidth;
    rectFarm.size.height = iPhoneHeight;
    self.frame = rectFarm;
    
    delegate = tagDelegate;
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        return NO;
    }
    return YES;
}

- (IBAction)forgetPassworldButtonAction:(id)sender {
    [delegate forgetPassworldButtonAction];
}
- (IBAction)cancelButtonAction:(id)sender {
    [delegate cancelButtonAction];
}
- (IBAction)gotoPayButtonAction:(id)sender {
    [delegate gotoPayButtonAction];
}
@end
