//
//  BorrowingWaitingView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BorrowingWaitingTopViewDelegate <NSObject>
- (void)selectDateStartBtnDelegateAction:(UIButton *)btn;
- (void)selectDateEndBtnDelegateAction:(UIButton *)btn;
@end
@interface BorrowingWaitingTopView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectDateStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectDateEndBtn;

- (IBAction)selectDateStartBtnAction:(id)sender;
- (IBAction)selectDateEndBtnAction:(id)sender;

@property (nonatomic, weak) id<BorrowingWaitingTopViewDelegate> delegate;

- (instancetype)initWithBorrowingWaitingTopViewFram:(CGRect)viewFram;

@end


#pragma mark - BorrowingWaitingBottomView  AREA
@protocol BorrowingWaitingBottomViewDelegate <NSObject>
- (void)bottomSeclectBtnActionDelegate:(UIButton *)btn;
- (void)immediatementBtnActionDelegate:(NSString *)amountMoneyStr;

@end
@interface BorrowingWaitingBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *bottomAmountMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomSelectBtn;
- (IBAction)bottomSeclectBtnClicked:(id)sender;
- (IBAction)immediateRepaymentBtnClicked:(id)sender;

@property (nonatomic, weak) id<BorrowingWaitingBottomViewDelegate> delegate;

- (instancetype)initWithBorrowingWaitingBottomViewFram:(CGRect)viewFram;

@end
