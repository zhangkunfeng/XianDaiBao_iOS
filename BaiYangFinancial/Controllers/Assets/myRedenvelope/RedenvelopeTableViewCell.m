//
//  RedenvelopeTableViewCell.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/16.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "RedenvelopeTableViewCell.h"

@implementation RedenvelopeTableViewCell

+ (NSString *)initWithRedenvelopeTableViewCellID {
    return @"RedenvelopeTableViewCell";
}

+ (CGFloat)initWithRedenvelopeTableViewCellHeight {
    return 150;
}

+ (instancetype)initWithRedenvelopeTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"RedenvelopeTableViewCell" owner:self options:nil] lastObject];
}

@end
