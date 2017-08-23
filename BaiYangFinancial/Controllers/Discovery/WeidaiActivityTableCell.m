//
//  WeidaiActivityTableCell.m
//  BaiYangFinancial
//
//  Created by xgy on 2017/8/10.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "WeidaiActivityTableCell.h"

@implementation WeidaiActivityTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
