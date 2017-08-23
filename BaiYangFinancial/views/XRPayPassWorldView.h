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

@protocol XRPayPassWorldViewDelegate <NSObject>

@required
- (void)sureTappend;
- (void)cancelTappend;
- (void)forgetPassWorldTappend;

@end

@interface XRPayPassWorldView : UIView
@property (weak, nonatomic) IBOutlet UITextField *centerTextFeild;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak)id <XRPayPassWorldViewDelegate> delegate;

- (void)clearUpPassword;

@end
