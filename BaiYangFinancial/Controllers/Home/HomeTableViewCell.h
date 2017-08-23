//
//  HomeTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *homeCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *billLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawMothLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *rechargeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeMonthLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

//isLoginView
@property (weak, nonatomic) IBOutlet UIView *cellNoUIDView;
@property (weak, nonatomic) IBOutlet UILabel *RedPacketAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *ImmediatelyReceiveBtn;

//autoLayout
//data
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnHeight;
//loginView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLineBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *immediatelyBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineBottom;

//登录按钮左右间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cheackBtnTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkHeight;


+ (id)addHomeTableViewCell;
+ (NSString *)HomeTableViewCellID;
+ (CGFloat)HomeTableViewCellHeight;
- (void)setCellConstant;

@end

/**
 *   零钱包视图
 */
@interface HomeTableViewChangeMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *homeMoneyChange_RateLabel;

+ (id)addHomeTableViewChangeMoneyCell;
+ (NSString *)HomeTableViewChangeMoneyCellID;
+ (CGFloat)HomeTableViewChangeMoneyCellHeight;

@end

/**
 *   新手视图
 */
@interface HomeTableViNoviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yearRateTop;
@property (weak, nonatomic) IBOutlet UIImageView *bidImageView;
@property (weak, nonatomic) IBOutlet UILabel *yearRateLab;
@property (weak, nonatomic) IBOutlet UILabel *addRateLab;
@property (weak, nonatomic) IBOutlet UILabel *onlyNewPersonLab;

@property (weak, nonatomic) IBOutlet UIButton *clickInvestBtn;

+ (id)addHomeTableViNoviceCell;
+ (NSString *)HomeTableViNoviceCellID;
+ (CGFloat)HomeTableViNoviceCellHeight;

@end

/**
 *   新版cell
 */
@interface HomeNewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *profitLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;

@property (weak, nonatomic) IBOutlet UILabel *setNameLab;

+ (id)addHomeNewTableViewCell;
+ (NSString *)HomeNewTableViewCellID;
+ (CGFloat)HomeNewTableViewCellHeight;

@end

