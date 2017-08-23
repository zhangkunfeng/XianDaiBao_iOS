//
//  NewProductTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/19.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *zhaungtaiImg;

@property (weak, nonatomic) IBOutlet UIImageView *timeImg;

@property (weak, nonatomic) IBOutlet UILabel *baiFenLab;
@property (weak, nonatomic) IBOutlet UILabel *hengLab;

@property (weak, nonatomic) IBOutlet UILabel *chengJieLab;
@property (weak, nonatomic) IBOutlet UILabel *cjDateLab;

@property (weak, nonatomic) IBOutlet UILabel *bidTypeTitle;//标的类型
@property (weak, nonatomic) IBOutlet UILabel *bidTypeDescText;//类型描述
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;

@property (weak, nonatomic) IBOutlet UILabel *bidTitleLable;//标的标题
@property (weak, nonatomic) IBOutlet UILabel *bidRateLable;//标的利率
@property (weak, nonatomic) IBOutlet UILabel *addBidRateLable;//加送标的利率
@property (weak, nonatomic) IBOutlet UILabel *AnnualyieldDesc;//年化收益率


@property (weak, nonatomic) IBOutlet UILabel *TermInvestmentDesc;//投资期限
@property (weak, nonatomic) IBOutlet UILabel *InvestmentStartDesc;//投资起步
@property (weak, nonatomic) IBOutlet UILabel *TotalProjectDesc;//项目总额
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeading;//31.5


@property (weak, nonatomic) IBOutlet UILabel *borrowDeadlineLable;//标的期限/剩余期数
@property (weak, nonatomic) IBOutlet UILabel *tenderMinAmountLable;//标最小购买值/折价率
@property (weak, nonatomic) IBOutlet UILabel *borrowAmountLable;//项目总额

@property (weak, nonatomic) IBOutlet UILabel *undertakeLab;//承接
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undertakeLabTrailing;

@property (weak, nonatomic) IBOutlet UILabel *PercentageDesc;//百分比/期数数据
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BidStateImageView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UILabel *buyLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InvestmentStartTopContant;//投资期限距上
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalProjectTopConstant; //项目总额距上

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopConstant; //垂直线条距上

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewBottomConstant;  //垂直线条距下


//iPhone 5 | iPhone 4 constant
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investTimeDescLading;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investTimeLeading;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investStartLeading;//7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTotalLeading;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addbidLabConsW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transferAmountTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investDateLeftCenterY;


+ (id)NewproductTableViewCell;
+ (NSString *)NewProductTableViewID;
+ (CGFloat)NewProductTableViewCellHeight;
- (void)setSmalliPhoneConstant;
@end
