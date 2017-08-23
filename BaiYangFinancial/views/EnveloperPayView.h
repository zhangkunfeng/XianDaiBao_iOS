//
//  EnveloperPayView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/5.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnveloperPayViewDelegate <NSObject>
@required
- (void)cancelBtnClicked:(UIButton *)btn;
- (void)balanceGestureViewTap;
@end

@interface EnveloperPayView : UIView

@property (weak, nonatomic) IBOutlet UILabel *enveloperMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *balanceGestureView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) id<EnveloperPayViewDelegate> delegate;

- (IBAction)cancelBtnClicked:(id)sender;

- (instancetype)initWithEnveloperMoney:(NSString *)enveloperMoney theDelegate:(id<EnveloperPayViewDelegate>)tagDelegate;

@end
