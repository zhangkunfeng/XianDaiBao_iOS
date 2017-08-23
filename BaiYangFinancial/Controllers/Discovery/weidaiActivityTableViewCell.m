//
//  weidaiActivityTableViewCell.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/10.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "weidaiActivityTableViewCell.h"

@implementation weidaiActivityTableViewCell


+(id)initWithweidaiActivityTableViewCell{
     return [[[NSBundle mainBundle] loadNibNamed:@"weidaiActivityTableViewCell" owner:self options:nil] lastObject];
}

+(CGFloat)weidaiActivityTableViewCellHeight{
    if (iPhoneWidth == 320) {
        return 213;
    }else if (iPhone6){
        return 238;
    }else if(iPhone6_){
        return 264;
    }else{
        return 244;
    }
}

+(NSString *)weidaiActivityTableViewCell_id{
    return @"weidaiActivityTableViewCell_id";
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
