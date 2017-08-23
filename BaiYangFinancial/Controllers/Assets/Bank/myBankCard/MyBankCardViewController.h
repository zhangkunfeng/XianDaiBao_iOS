//
//  MyBankCardViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/9.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface MyBankCardViewController : BaseViewController<CustomUINavBarDelegate>
//银行卡view
@property (weak, nonatomic) IBOutlet UIView *bankCardView;
//添加银行卡按钮
@property (weak, nonatomic) IBOutlet UIButton *addBankCardButton;
//添加银行卡按钮事件
- (IBAction)addBankCardButtonAction:(id)sender;
//添加银行卡按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBankbuttonheightConstranint;


@end
