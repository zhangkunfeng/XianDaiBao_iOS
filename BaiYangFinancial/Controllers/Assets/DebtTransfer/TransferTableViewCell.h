//
//  TransferTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bidName;//标名
@property (weak, nonatomic) IBOutlet UILabel *transferPrice;//转让价格
@property (weak, nonatomic) IBOutlet UILabel *recover_capital;//转让本金
@property (weak, nonatomic) IBOutlet UILabel *recoverPeriod;//剩余期数
@property (weak, nonatomic) IBOutlet UILabel *acceptTimeShow;//承接时间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *transferOrWaitingMoneyDescLabel;

@end
