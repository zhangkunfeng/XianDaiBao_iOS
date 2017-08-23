//
//  HomeTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (id)addHomeTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] objectAtIndex:0];
}
+ (NSString *)HomeTableViewCellID {
    return @"HomeTableViewCellID";
}
+ (CGFloat)HomeTableViewCellHeight {
    return iPhone6_ ? 203 : 180;
}
- (void)setCellConstant
{
    if (iPhone6_) {
        self.immediatelyBtnTop.constant = 20;
        self.checkBtnLeading.constant = 50;//没变
        self.cheackBtnTrailing.constant = 50;//没变
        self.checkHeight.constant = 43;
        self.bottomLineBottom.constant = 1;//5
        return;//不能少
    }
    
    //data
    self.moneyTop.constant = 20;
    self.descTop.constant = 8;
    self.dataLineTop.constant = 13;
    self.checkBtnTop.constant = 2;
    self.checkBtnHeight.constant = 40;
    
    //login
    self.titleTop.constant = 13;
    self.loginLineTop.constant = 12;
    self.loginLineBottom.constant = 12;
    self.immediatelyBtnTop.constant = 17;
}

@end

#pragma mark - HomeTableViewChangeMoneyCell
@implementation HomeTableViewChangeMoneyCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (id)addHomeTableViewChangeMoneyCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] objectAtIndex:1];
}
+ (NSString *)HomeTableViewChangeMoneyCellID {
    return @"HomeTableViewChangeMoneyCellID";
}
+ (CGFloat)HomeTableViewChangeMoneyCellHeight {
    return 163;
}

@end


#pragma mark - HomeTableViNoviceCell
@implementation HomeTableViNoviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+ (id)addHomeTableViNoviceCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] objectAtIndex:2];
}
+ (NSString *)HomeTableViNoviceCellID {
    return @"HomeTableViNoviceCellID";
}
+ (CGFloat)HomeTableViNoviceCellHeight {
    return 270;
}

@end


#pragma mark - HomeNewTableViewCell
@implementation HomeNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+ (id)addHomeNewTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] objectAtIndex:3];
}
+ (NSString *)HomeNewTableViewCellID {
    return @"HomeNewTableViewCellID";
}
+ (CGFloat)HomeNewTableViewCellHeight {
    return 270;
}

@end
