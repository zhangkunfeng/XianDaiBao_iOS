//
//  EnveloperPayView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/5.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "EnveloperPayView.h"

@implementation EnveloperPayView

- (instancetype)initWithEnveloperMoney:(NSString *)enveloperMoney theDelegate:(id<EnveloperPayViewDelegate>)tagDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"EnveloperPayView" owner:self options:nil] lastObject];
    if (self) {
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
        _delegate = tagDelegate;
        
        [self addGestrue];
        
        return self;
    }
    return nil;
}
- (IBAction)cancelBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cancelBtnClicked:)]) {
        [_delegate cancelBtnClicked:sender];
    }
}

- (void)addGestrue
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceViewTap:)];
    [self.balanceGestureView addGestureRecognizer:tap];
}

- (void)balanceViewTap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(balanceGestureViewTap)]) {
        [_delegate balanceGestureViewTap];
    }
}

@end
