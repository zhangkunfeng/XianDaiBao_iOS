//
//  remainingBalancePayView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/25.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "remainingBalancePayView.h"

@implementation remainingBalancePayView

//债权转让承接 支付视图
- (id)initWithremainingBanlancepayView:(NSString *)payAmountsString userMyassetsMoney:(NSString *)userMyassetsMoneyString userMyBankMoney:(NSString *)userMyBankMoneyString theDelegate:(id<remainingBalancePayViewDelegate>)theremainingBalancePayViewDelegate {
    self = [[[NSBundle mainBundle] loadNibNamed:@"remainingBalancePayView" owner:self options:nil] lastObject];
    if (self) {
        
        //适配债权转让视图
        self.reveloperLabel.text = @"";
        self.reveloperDescLabel.text = @"";
        self.reveloperYuanDescLabel.text = @"";
        self.bankPayDescLabelTop.constant = 12;
        
        /*
        self.payAmount.text = payAmountsString;
        self.userMyassetsMoneyLable.text = userMyassetsMoneyString;
        self.userMyBankMoneyLable.text = userMyBankMoneyString;
        */
        self.payAmount.text = [Number3for1 formatAmount:payAmountsString];
        self.userMyassetsMoneyLable.text = [Number3for1 formatAmount:userMyassetsMoneyString];
        self.userMyBankMoneyLable.text = [Number3for1 formatAmount:userMyBankMoneyString];
        delegate = theremainingBalancePayViewDelegate;
    }

    CGRect rectFarm = self.frame;
    rectFarm.size.width = iPhoneWidth;
    rectFarm.size.height = iPhoneHeight;
    self.frame = rectFarm;

    return self;
}

//产品购买支付视图
- (id)        initWithView:(NSString *)payAmountsString
         userMyassetsMoney:(NSString *)userMyassetsMoneyString
           userMyBankMoney:(NSString *)userMyBankMoneyString
      deductionMoneyString:(NSString *)deductionMoneyString
               theDelegate:(id<remainingBalancePayViewDelegate>)theremainingBalancePayViewDelegate {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"remainingBalancePayView" owner:self options:nil] firstObject];
    if (self) {
        /*
        self.payAmount.text = payAmountsString;
        self.userMyassetsMoneyLable.text = userMyassetsMoneyString;
        self.userMyBankMoneyLable.text = userMyBankMoneyString;
        self.deductionLable.text = deductionMoneyString;
         */
        self.payAmount.text = [Number3for1 formatAmount:payAmountsString];
        self.userMyassetsMoneyLable.text = [Number3for1 formatAmount:userMyassetsMoneyString];
        self.userMyBankMoneyLable.text = [Number3for1 formatAmount:userMyBankMoneyString];
        NSLog(@"deductionMoneyString = %@",deductionMoneyString);
        self.reveloperLabel.text =deductionMoneyString?deductionMoneyString:@"";
        delegate = theremainingBalancePayViewDelegate;
    }
    
    CGRect rectFarm = self.frame;
    rectFarm.size.width = iPhoneWidth;
    rectFarm.size.height = iPhoneHeight;
    self.frame = rectFarm;

    return self;
}

- (IBAction)cancelButtonAction:(id)sender {
    [delegate cancelButtonAction];
}
- (IBAction)ConfirmButtonAction:(id)sender {
    [delegate gotoPayButtonAction];
}
@end
