//
//  RedenvelopeTableViewCell.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/16.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedenvelopeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *RedenvelopeName;
@property (weak, nonatomic) IBOutlet UILabel *overdueTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *minAmountLable;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLable;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageview;
@property (weak, nonatomic) IBOutlet UILabel *SymbolLable;
@property (weak, nonatomic) IBOutlet UILabel *belielLable;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLable;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//几天有效期

+ (NSString *)initWithRedenvelopeTableViewCellID;

+ (CGFloat)initWithRedenvelopeTableViewCellHeight;

+ (instancetype)initWithRedenvelopeTableViewCell;

@end
