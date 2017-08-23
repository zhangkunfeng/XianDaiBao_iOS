//
//  DueinTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/29.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DueinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;//转让按钮
@property (weak, nonatomic) IBOutlet UILabel *bidName;//标名
@property (weak, nonatomic) IBOutlet UILabel *recoverPeriod;//剩余期数
@property (weak, nonatomic) IBOutlet UILabel *recoverTimeShow;//最近待收时间
@property (weak, nonatomic) IBOutlet UILabel *recoverAmonut;//待收本息

@end
