//
//  BorrowingTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BorrowingTableViewCell.h"

@implementation BorrowingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)initWithBorrowingTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"BorrowingTableViewCell" owner:self options:nil] lastObject];
}

+ (NSString *)initWithBorrowingTableViewCellID{
    return @"BorrowingTableViewCellID";
}

+ (CGFloat)initWithBorrowingTableViewCellHeight{
    return 62;
}

- (void)setAlreadyMoneyCellConstans{
    self.moneyLabelLeading.constant = 15;
    [self.selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
