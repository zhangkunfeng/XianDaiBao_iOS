//
//  MyFriendsTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/26.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "MyFriendsTableViewCell.h"

@implementation MyFriendsTableViewCell

+ (id)MyFriendsTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"MyFriendsTableViewCell" owner:self options:nil] lastObject];
}

+ (NSString *)MyFriendsTableViewCellID {
    return @"MyFriendsTableViewCellID";
}

+ (CGFloat)MyFriendsTableViewCellHeight {
    return 56;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
