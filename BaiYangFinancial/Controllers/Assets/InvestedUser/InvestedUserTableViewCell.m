//
//  InvestedUserTableViewCell.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/3.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "InvestedUserTableViewCell.h"

@implementation InvestedUserTableViewCell

- (void)setInvestedModel:(investedUserModel *)investedModel{
    _investedModel = investedModel;

    self.userNameLable.text = investedModel.useriPhoneNumber;
    
//    self.currentTenderAmountLable.text = [NSString stringWithFormat:@"%.2f元" ,[investedModel.currentTenderAmount doubleValue]];
    self.currentTenderAmountLable.text =[NSString stringWithFormat:@"%@",[Number3for1 formatAmount:investedModel.currentTenderAmount]];
    
    self.tenderTimeLable.text = investedModel.tenderTime;
    
    if (iPhoneWidth == 320) {
        self.leadingConstraint.constant = 15;
    }
}


@end
