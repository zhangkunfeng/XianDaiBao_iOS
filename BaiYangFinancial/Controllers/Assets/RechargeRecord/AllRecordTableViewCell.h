//
//  AllRecordTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/9.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

+ (id)allRecordTableViewCell;
+ (NSString *)allRecordTableViewCellID;
+ (CGFloat)allRecordTableViewCellHeight;

@end
