//
//  HomeHeaderView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerView_topViewHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView_topView;       //116
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;           //当月收益
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;        //总资产
@property (weak, nonatomic) IBOutlet UILabel *accumulatedEarningsLabel;//累计收益
@property (weak, nonatomic) IBOutlet UIButton *homeMoneyEyeBtn;

@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)loginBtnClicked:(id)sender;

//当月收益 闭眼适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalAmountToTop;   //15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalAmountToBottom;//20

@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *changeMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *change_RateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leijiShouyiBtn;

@property (nonatomic,assign) BOOL isHaveDiscovery;
@property (weak, nonatomic) IBOutlet UILabel *leijiChenBtn;


- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController;
- (void)setAdViewDataWithArray:(NSArray *)array;
- (void)setTheMonthAssetsEarningsDataWithDictionary:(NSDictionary *)dict;

@end
