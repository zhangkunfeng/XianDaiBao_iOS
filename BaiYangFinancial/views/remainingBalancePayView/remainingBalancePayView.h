//
//  remainingBalancePayView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/25.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol remainingBalancePayViewDelegate <NSObject>

- (void)gotoPayButtonAction;

- (void)cancelButtonAction;

@end

@interface remainingBalancePayView : UIView {
    id<remainingBalancePayViewDelegate> delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *payAmount; //支付总额

@property (weak, nonatomic) IBOutlet UILabel *userMyassetsMoneyLable; //使用账户余额

@property (weak, nonatomic) IBOutlet UILabel *userMyBankMoneyLable; //使用我的银行卡支付金额

//红包抵扣区域三连label
@property (weak, nonatomic) IBOutlet UILabel *reveloperDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *reveloperLabel;
@property (weak, nonatomic) IBOutlet UILabel *reveloperYuanDescLabel;

//还需银行卡支付距上距离（适配用）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankPayDescLabelTop;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton; //取消按钮
- (IBAction)cancelButtonAction:(id)sender;                   //取消按钮点击事件

- (IBAction)ConfirmButtonAction:(id)sender; //确认按钮点击事件

- (id)initWithremainingBanlancepayView:(NSString *)payAmountsString userMyassetsMoney:(NSString *)userMyassetsMoneyString userMyBankMoney:(NSString *)userMyBankMoneyString theDelegate:(id<remainingBalancePayViewDelegate>)theremainingBalancePayViewDelegate;

- (id)initWithView:(NSString *)payAmountsString userMyassetsMoney:(NSString *)userMyassetsMoneyString userMyBankMoney:(NSString *)userMyBankMoneyString deductionMoneyString:(NSString *)deductionMoneyString theDelegate:(id<remainingBalancePayViewDelegate>)theremainingBalancePayViewDelegate;

@end
