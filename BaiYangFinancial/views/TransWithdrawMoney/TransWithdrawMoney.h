//
//  payPassWorldView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/6/19.
//  Copyright © 2016年 无名小子. All rights reserved.
//
/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */

#import <UIKit/UIKit.h>

@protocol TransWithdrawMoneyDelegate <NSObject>

@required
- (void)sureTappend:(NSString *)transWithdrawMoenyStr;
- (void)cancelTappend;
@end

@interface TransWithdrawMoney : UIView

@property (weak, nonatomic) IBOutlet UITextField *transMoneyTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *commissionMoneyLabel;//手续费金额
@property (weak, nonatomic) IBOutlet UILabel *premiumRateLabel;//费率数
@property (weak, nonatomic) IBOutlet UILabel *noTransWithdrawMoneyLabel;//不可提现金额数
@property (weak, nonatomic) IBOutlet UILabel *transWithDrawLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *shiJiLab;

@property (nonatomic, weak)id <TransWithdrawMoneyDelegate> delegate;

- (instancetype)initWithTransWithdrawMoneyViewDisAvalCash:(NSString *)disAvalCash factorage:(NSString *)factorage  viewController:(UIViewController *)viewController  theDelegate:(id<TransWithdrawMoneyDelegate>)tagDelegate;

@end
