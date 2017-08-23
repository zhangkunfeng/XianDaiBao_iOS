//
//  WDArdawRecordsTableViewCell.h
//  weidaitest
//
//  Created by yaoqi on 16/3/17.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDArdawRecordsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneOrTwoInviteWidthSetting;

@end
