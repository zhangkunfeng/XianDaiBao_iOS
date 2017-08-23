//
//  WDRegisterSuccessPopupView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/4/18.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WDRegisterSuccessPopupViewDelegate <NSObject>

- (void)bindingBankCard;

- (void)lookReddenvelope;

@end

@interface WDRegisterSuccessPopupView : UIView

@property (nonatomic, copy) NSMutableAttributedString * labelStr;//可能未使用
@property (nonatomic, weak) id<WDRegisterSuccessPopupViewDelegate> delegate;
@property (nonatomic, copy) NSString * enveloperMoneyStr;
@property (nonatomic, strong)UILabel * detailLabel;

@end
