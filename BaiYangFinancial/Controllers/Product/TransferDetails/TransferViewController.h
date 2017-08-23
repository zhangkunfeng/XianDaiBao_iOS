//
//  TransferViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/16.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface TransferViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain)NSString *transferbid_id;//转让标id
@property (nonatomic, retain)NSString *debtUid;//转让人得id

@property (weak, nonatomic) IBOutlet UILabel *bidName;//标题
@property (weak, nonatomic) IBOutlet UILabel *borrowAnnualYield;//利率

@property (weak, nonatomic) IBOutlet UILabel *discountRateLab;//折价率
@property (weak, nonatomic) IBOutlet UILabel *transferPriceLab;//转让价格
@property (weak, nonatomic) IBOutlet UILabel *recoverPeriod;//剩余期数
@property (weak, nonatomic) IBOutlet UILabel *waitPriceLab;//待收总额
@property (weak, nonatomic) IBOutlet UILabel *principalLab;//待收本金
@property (weak, nonatomic) IBOutlet UILabel *interestLab;//待收利息

@property (weak, nonatomic) IBOutlet UIButton *undertakeBtn;//承接按钮
@property (weak, nonatomic) IBOutlet UILabel *SHouyiLab;

- (IBAction)TransferButtonAction:(id)sender;//承接按钮点击事件

@end
