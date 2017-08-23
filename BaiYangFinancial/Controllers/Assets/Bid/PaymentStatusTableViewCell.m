//
//  PaymentStatusTableViewCell.m
//  白杨
//
//  Created by 徐洪 on 15/11/10.
//  Copyright © 2015年 金鼎. All rights reserved.
//

#import "PaymentStatusTableViewCell.h"

@implementation PaymentStatusTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMyview];
    }
    return self;
}

- (void)createMyview
{
    /*
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.02, Screen_Width * 0.8, Screen_Height *0.03)];
    lable.text = @"还款计划(预计当天18点返还)";
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:lable];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.05, Screen_Height * 0.08, Screen_Width * 0.15, Screen_Height * 0.03)];
    time.text = @"时间";
    time.font = [UIFont systemFontOfSize:16.0];
    time.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:time];
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.45, Screen_Height * 0.08, Screen_Width * 0.15, Screen_Height * 0.03)];
    money.text = @"金额";
    money.font = [UIFont systemFontOfSize:16.0];
    money.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:money];
    UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.75, Screen_Height * 0.08, Screen_Width * 0.15, Screen_Height * 0.03)];
    status.text = @"状态";
    status.font = [UIFont systemFontOfSize:16.0];
    status.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:status];
    
    UIView *xianview = [[UIView alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.135, Screen_Width * 0.94, Screen_Height * 0.002)];
    xianview.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.contentView addSubview:xianview];
    */
//    bidDetailImage
    
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width * 0.05, Screen_Height * 0, Screen_Width * 0.07, Screen_Height * 0.071)];
//    self.imageV.image = [UIImage imageNamed:@"bidDetailImage.png"];
    [self.contentView addSubview:self.imageV];
    
    self.LabelYLin = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width * 0.035, Screen_Height * 0, 0.5, Screen_Height * 0.071)];
    self.LabelYLin.backgroundColor = [UIColor lightGrayColor];
//    [self.imageV addSubview:self.LabelYLin];
    self.roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width * 0.02, Screen_Height * 0.071 / 2 - Screen_Width * 0.03 / 2, Screen_Width * 0.03 , Screen_Width * 0.03)];
    self.roundLabel.backgroundColor = [UIColor lightGrayColor];
    self.roundLabel.layer.masksToBounds = YES;
    self.roundLabel.layer.cornerRadius = self.roundLabel.frame.size.width / 2;
//    [self.imageV addSubview:self.roundLabel];
    [self.imageV insertSubview:self.LabelYLin atIndex:0];
    [self.imageV insertSubview:self.roundLabel atIndex:1];
    
    
    self.TimeLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.15, Screen_Height * 0.00, Screen_Width * 0.25, Screen_Height * 0.07)];
    self.TimeLable.font = [UIFont systemFontOfSize:14.0];
    self.TimeLable.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:self.TimeLable];
    self.moneylable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.4, Screen_Height * 0.00, Screen_Width * 0.3, Screen_Height * 0.07)];
    self.moneylable.font = [UIFont systemFontOfSize:14.0];
    self.moneylable.textColor = UIColorFromRGB(0x474747);
    self.moneylable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.moneylable];
    
    self.StatusLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.79, Screen_Height * 0.0, Screen_Width * 0.15, Screen_Height * 0.07)];
    self.StatusLable.font = [UIFont systemFontOfSize:14.0];
    self.StatusLable.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:self.StatusLable];
    UIView *xianview1 = [[UIView alloc]initWithFrame:CGRectMake(Screen_Width * 0.15, Screen_Height * 0.07, Screen_Width * 0.83, Screen_Height * 0.001)];
//    xianview1.backgroundColor = UIColorFromRGB(0xf7f7f7);
      xianview1.backgroundColor = [UIColor lightGrayColor];

    [self.contentView addSubview:xianview1];
    
    /*
    self.Timelable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.21, Screen_Width * 0.25, Screen_Height * 0.07)];
    self.Timelable.font = [UIFont systemFontOfSize:14.0];
    self.Timelable.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:self.Timelable];
    
    self.MoneyLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.45, Screen_Height * 0.21, Screen_Width * 0.2, Screen_Height * 0.07)];
    self.MoneyLable.font = [UIFont systemFontOfSize:14.0];
    self.MoneyLable.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:self.MoneyLable];
    
    UILabel *status1 = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.75, Screen_Height * 0.13, Screen_Width * 0.25, Screen_Height * 0.07)];
    status1.text = @"购买成功";
    status1.font = [UIFont systemFontOfSize:14.0];
    status1.textColor = UIColorFromRGB(0x474747);
    [self.contentView addSubview:status1];
    
     */
    
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
