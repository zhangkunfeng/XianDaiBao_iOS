//
//  RecentlyBidViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/8.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "QCSlideSwitchView.h"
#import "BidListViewController.h"
#import "CustomNavigationButton.h"

@interface RecentlyBidViewController : BaseViewController<QCSlideSwitchViewDelegate>

@property (nonatomic, strong) BidListViewController *vc1;
@property (nonatomic, strong) BidListViewController *vc2;

@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (weak, nonatomic) IBOutlet CustomNavigationButton *gobackButton;//返回按钮

- (IBAction)goBackAction:(id)sender;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
