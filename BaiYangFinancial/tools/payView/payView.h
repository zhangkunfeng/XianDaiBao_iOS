//
//  payView.h
//  weidaiwang
//
//  Created by 艾运旺 on 15/8/12.
//  Copyright (c) 2015年 艾运旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayViewDelegate <NSObject>

-(void)gotoPayButtonAction;

-(void)cancelButtonAction;

-(void)forgetPassworldButtonAction;

@end


@interface payView : UIView<UITextFieldDelegate>{
    id<PayViewDelegate> delegate;
}

@property (weak, nonatomic) IBOutlet UIView *payView;//输入支付密码View
@property (weak, nonatomic) IBOutlet UILabel *userName;//用户名
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;//银行卡信息
@property (weak, nonatomic) IBOutlet UITextField *payPassworldTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


- (IBAction)forgetPassworldButtonAction:(id)sender;//忘记密码
- (IBAction)cancelButtonAction:(id)sender;//取消按钮
- (IBAction)gotoPayButtonAction:(id)sender;//去付款

-(id)initWithpayView:(NSDictionary *)payDict theDelegate:(id<PayViewDelegate>) tagDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewWidthConstraint;

@end
