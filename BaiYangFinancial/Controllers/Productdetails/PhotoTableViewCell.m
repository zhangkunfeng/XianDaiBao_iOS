//
//  PhotoTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/7.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(id)initWithPhotoTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"PhotoTableViewCell" owner:self options:nil] lastObject];
}

+(NSString *)initWithPhotoTableViewCell_ID{
    return @"PhotoTableViewCell_ID";
}

+(CGFloat)initWithPhotoTableViewCellHeight{
    return 350;
}


/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
