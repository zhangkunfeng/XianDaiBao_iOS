//
//  choosePersonTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/6.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "choosePersonTableViewCell.h"

@implementation choosePersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconTitleLab.font = [UIFont boldSystemFontOfSize:15.0f];
    
}
+ (id)MyFriendsTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"choosePersonTableViewCell" owner:self options:nil] lastObject];
}

+ (NSString *)MyFriendsTableViewCellID {
    return @"choosePersonTableViewCellID";
}

//+ (CGFloat)MyFriendsTableViewCellHeight {
//    return 56;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
