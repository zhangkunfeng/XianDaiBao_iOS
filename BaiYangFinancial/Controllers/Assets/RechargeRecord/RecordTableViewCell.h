//
//  RecordTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amount;      //提现金额.手续费
@property (weak, nonatomic) IBOutlet UILabel *operateTime; //到账时间
@property (weak, nonatomic) IBOutlet UILabel *submittime;  //提交时间
@property (weak, nonatomic) IBOutlet UILabel *tradeState;  //处理状态
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
