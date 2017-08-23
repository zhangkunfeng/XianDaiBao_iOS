//
//  BorrowingTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelLeading;//40 待还款

+ (NSString *)initWithBorrowingTableViewCellID;
+ (CGFloat)initWithBorrowingTableViewCellHeight;
+ (instancetype)initWithBorrowingTableViewCell;

- (void)setAlreadyMoneyCellConstans;

@end
