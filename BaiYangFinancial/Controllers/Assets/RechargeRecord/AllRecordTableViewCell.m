//
//  AllRecordTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/9.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "AllRecordTableViewCell.h"

@implementation AllRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (id)allRecordTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"AllRecordTableViewCell" owner:self options:nil] lastObject];
}

+ (NSString *)allRecordTableViewCellID {
    return @"allRecordTableViewCellID";
}

+ (CGFloat)allRecordTableViewCellHeight {
    return 65;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
