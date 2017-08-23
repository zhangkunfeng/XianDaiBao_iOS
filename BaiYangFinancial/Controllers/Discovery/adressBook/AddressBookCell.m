//
//  AddressBookCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/24.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "AddressBookCell.h"

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.AddBtn.layer setBorderWidth:.5];
    [self.AddBtn.layer setBorderColor:AppBtnColor.CGColor];
}

+ (id)AdressBookTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"AddressBookCell" owner:self options:nil] lastObject];
}

+ (NSString *)AdressBookTableViewID {
    return @"AddressBookCellID";
}

+ (CGFloat)AdressBookTableViewCellHeight {
    return 56;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
