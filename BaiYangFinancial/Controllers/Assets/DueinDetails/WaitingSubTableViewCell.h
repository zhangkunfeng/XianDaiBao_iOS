//
//  WaitingSubTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/9.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingSubTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//待收总额
@property (weak, nonatomic) IBOutlet UILabel *bidNameLab;//标名
@property (weak, nonatomic) IBOutlet UILabel *recoverPeriod;//还款期数

@end
