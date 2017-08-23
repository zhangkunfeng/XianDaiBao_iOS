//
//  BidRecordTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/3.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bidName;//标名
@property (weak, nonatomic) IBOutlet UILabel *repayAmonutAll;//应收总额
@property (weak, nonatomic) IBOutlet UILabel *repayInterestAll;//应收利息
@property (weak, nonatomic) IBOutlet UILabel *borrowAnnualYield;//借款年化利率
@property (weak, nonatomic) IBOutlet UILabel *borrowerPeriod;//借款期限
@property (weak, nonatomic) IBOutlet UILabel *successTime;//交易日期
@property (weak, nonatomic) IBOutlet UILabel *topLine;


@end
