//
//  payView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/12.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayViewDelegate <NSObject>

@required
- (void)PassworldgotoPayButtonAction;

- (void)PassworldcancelButtonAction;

- (void)forgetPassworldButtonAction;

@end

@interface payView : UIView <UITextFieldDelegate> {
    id<PayViewDelegate> delegate;
}

- (void)clearUpPassword;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@property (nonatomic, strong) NSString *payPassStr;

@property (weak, nonatomic) IBOutlet UIView *payView;   //输入支付密码View
@property (weak, nonatomic) IBOutlet UILabel *userName; //用户名
@property (weak, nonatomic) IBOutlet UITextField *payPassworldTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *actionDescriptionLable; //付款动作
@property (weak, nonatomic) IBOutlet UILabel *MoneyLable;

@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

- (IBAction)forgetPassworldButtonAction:(id)sender; //忘记密码
- (IBAction)cancelButtonAction:(id)sender;          //取消按钮
- (IBAction)gotoPayButtonAction:(id)sender;         //去付款

- (instancetype)initWithpayView:(NSString *)actionDescription howMuchmoney:(NSString *)moneyString theDelegate:(id<PayViewDelegate>)tagDelegate;

//- (id)initWithpayView:(NSDictionary *)payDict DifferencePaymode:(NSInteger)Paymode theDelegate:(id<PayViewDelegate>) tagDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *payButton;



@end
