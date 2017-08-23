//
//  TransferButtonViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "AttributedLabel.h"

typedef void(^backRefresh)(BOOL isRefresh);

@interface TransferButtonViewController : BaseViewController<CustomUINavBarDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contenScrollView;
@property (weak, nonatomic) IBOutlet UIView *BigView;
@property (weak, nonatomic) IBOutlet UILabel *bidName;//标名
@property (weak, nonatomic) IBOutlet UILabel *borrowAnnualYield;//年化利率
@property (weak, nonatomic) IBOutlet UILabel *shouXunLab;//手续费
@property (weak, nonatomic) IBOutlet UILabel *countRateLab;//折价费

@property (weak, nonatomic) IBOutlet UILabel *discountRateLab;//折价率
@property (weak, nonatomic) IBOutlet UILabel *transferPriceLab;//转让价格
@property (weak, nonatomic) IBOutlet UILabel *recoverPeriod;//剩余期数
@property (weak, nonatomic) IBOutlet UILabel *waitPriceLab;//待收总额
@property (weak, nonatomic) IBOutlet UILabel *principalLab;//待收本金
@property (weak, nonatomic) IBOutlet UILabel *interestLab;//待收利息

- (IBAction)sureBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *endPriceLab;//到手价格 暂无
@property (weak, nonatomic) IBOutlet UILabel *recoverTimeShow;//待收时间
//@property (weak, nonatomic) IBOutlet UITextField *transferPSW;

@property (nonatomic, retain)NSString *transferbidID;//转让标id;

@property (nonatomic, copy)backRefresh isbackRefresh;//回调函数 刷新界面

@end
