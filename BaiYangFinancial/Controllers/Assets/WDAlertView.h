//
//  WDAlertView.h
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/22.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDAlertView;
@protocol WDAlertViewDelegate <NSObject>

@optional
- (void)alertView:(WDAlertView *)alertView contentButton:(UIButton *)contentButton;
- (void)alertView:(WDAlertView *)alertView confimButton:(UIButton *)confimButton;

@end

@interface WDAlertView : UIView

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *confimButtonTitle;
@property (nonatomic, assign) NSInteger buttonTag;
@property (nonatomic, weak) id<WDAlertViewDelegate> delegate;

@end
