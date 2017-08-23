//
//  BorrowingWaitingView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BorrowingWaitingView.h"

@implementation BorrowingWaitingTopView

- (IBAction)selectDateStartBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectDateStartBtnDelegateAction:)]) {
        [self.delegate selectDateStartBtnDelegateAction:(UIButton *)sender];
    }
}

- (IBAction)selectDateEndBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectDateEndBtnDelegateAction:)]) {
        [self.delegate selectDateEndBtnDelegateAction:(UIButton *)sender];
    }
}

- (instancetype)initWithBorrowingWaitingTopViewFram:(CGRect)viewFram {
    if (![super init]) {
        return nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"BorrowingWaitingView" owner:self options:nil] firstObject];
    self.frame = viewFram;
    
    return self;
}

@end


@implementation BorrowingWaitingBottomView

- (IBAction)bottomSeclectBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bottomSeclectBtnActionDelegate:)]) {
        [self.delegate bottomSeclectBtnActionDelegate:(UIButton *)sender];
    }
}

- (IBAction)immediateRepaymentBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(immediatementBtnActionDelegate:)]) {
        [self.delegate immediatementBtnActionDelegate:_bottomAmountMoneyLabel.text];
    }
}

- (instancetype)initWithBorrowingWaitingBottomViewFram:(CGRect)viewFram {
    if (![super init]) {
        return nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"BorrowingWaitingView" owner:self options:nil] lastObject];
    self.frame = viewFram;
    
    return self;
}

@end
