//
//  ReceiveOrSendEnveloperTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveOrSendEnveloperFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *enveloperAmoutLab;
@property (weak, nonatomic) IBOutlet UILabel *enveloperNumLab;
@property (weak, nonatomic) IBOutlet UILabel *titleDescLab;

+ (id)enveloperFirstTableViewCell;
+ (NSString *)enveloperFirstTableViewCellID;
+ (CGFloat)enveloperFirstTableViewCellHeight;
@end


@interface ReceiveOrSendEnveloperSecondTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

+ (id)enveloperSecondTableViewCell;
+ (NSString *)enveloperSecondTableViewCellID;
+ (CGFloat)enveloperSecondTableViewCellHeight;
@end
