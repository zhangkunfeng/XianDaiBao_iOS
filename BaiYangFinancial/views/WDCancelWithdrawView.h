//
//  WDCancelWithdrawView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/5/3.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sureButtonTappedBlock)();

@interface WDCancelWithdrawView : UIView

+ (instancetype)shareCanceWithdrawView;

- (void)showCancelWithdrawViewWithsureButtonTapped:(sureButtonTappedBlock)block;
@end
