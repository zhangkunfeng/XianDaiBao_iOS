//
//  AssetDetailsTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/21.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *sumLab;//金额
@property (weak, nonatomic) IBOutlet UILabel *topLine;
//实际赚取
@property (weak, nonatomic) IBOutlet UILabel *totalEarning;

@end
