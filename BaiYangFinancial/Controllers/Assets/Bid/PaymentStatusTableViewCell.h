//
//  PaymentStatusTableViewCell.h
//  白杨
//
//  Created by 徐洪 on 15/11/10.
//  Copyright © 2015年 金鼎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentStatusTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UILabel * LabelYLin;   //垂直线条
@property (nonatomic, strong) UILabel * roundLabel;  //圆点  进度
@property (nonatomic, strong) UILabel *TimeLable;
@property (nonatomic, strong) UILabel *moneylable;
@property (nonatomic, strong) UILabel *StatusLable;
@property (nonatomic, strong) UILabel *Timelable;
@property (nonatomic, strong) UILabel *MoneyLable;
@property (nonatomic, strong) UILabel *status1;
@end
