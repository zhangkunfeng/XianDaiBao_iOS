//
//  SystemMessageTableViewCell.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/14.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell

+(id)initWithSystemMessageTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SystemMessageTableViewCell" owner:self options:nil] firstObject];
}

+(NSString *)initWithSystemMessageTableViewCell_ID{
    return @"SystemMessageTableViewCellID";
}

+(CGFloat)initWithSystemMessageTableViewCell_height{
    return 118;
}

/**
 *  拿到bottomCub的最大Y值并返回
 */
- (CGFloat)cellHeight
{
    //  强制布局之前，需要先手动设置下cell的真实宽度，以便于准确计算
    CGRect rect = self.frame;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = rect;
    [self layoutIfNeeded];    //  一定要强制布局下，否则拿到的高度不准确
    return CGRectGetMaxY(self.frameBtn.frame);
}

@end
