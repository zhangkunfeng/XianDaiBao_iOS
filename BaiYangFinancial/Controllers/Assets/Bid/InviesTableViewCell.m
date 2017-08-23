//
//  InviesTableViewCell.m
//  白杨
//
//  Created by 徐洪 on 15/11/6.
//  Copyright © 2015年 金鼎. All rights reserved.
//

#import "InviesTableViewCell.h"

@implementation InviesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMyCell];
    }
    return self;
}

- (void)createMyCell
{
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.02, Screen_Width * 0.7, Screen_Height * 0.03)];
    self.titleLable.textColor = UIColorFromRGB(0x474747);
    self.titleLable.font = [UIFont systemFontOfSize:17.0];
    [self.contentView addSubview:self.titleLable];
    
    self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.72, Screen_Height * 0.02, Screen_Width * 0.25, Screen_Height * 0.03)];
    self.timeLable.textColor = UIColorFromRGB(0x474747);
    self.timeLable.textAlignment = NSTextAlignmentRight;
    self.timeLable.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.timeLable];
    
    self.rateLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.07, Screen_Width * 0.21, Screen_Height * 0.03)];
    self.rateLable.textColor = [UIColor colorWithHexString:@"#FB9300"];
    self.rateLable.font = [UIFont systemFontOfSize:18.0];
    self.rateLable.textAlignment = NSTextAlignmentCenter;
//    self.rateLable.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.rateLable];
    
    self.moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.33, Screen_Height * 0.07, Screen_Width * 0.32, Screen_Height * 0.03)];
    self.moneyLable.textColor = UIColorFromRGB(0x474747);
    self.moneyLable.font = [UIFont boldSystemFontOfSize:14.0];
    self.moneyLable.textAlignment = NSTextAlignmentCenter;
//    self.moneyLable.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.moneyLable];
    
    
    self.nestLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.66, Screen_Height * 0.07, Screen_Width * 0.32, Screen_Height * 0.03)];
    self.nestLable.textColor = [UIColor colorWithHexString:@"#FB9300"];
    self.nestLable.font = [UIFont systemFontOfSize:14.0];
    self.nestLable.textAlignment = NSTextAlignmentCenter;
//     self.nestLable.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.nestLable];
    
    self.yearLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.12, Screen_Width * 0.21, Screen_Height * 0.03)];
    self.yearLable.textColor = UIColorFromRGB(0x474747);
    self.yearLable.text = @"年化收益率";
    self.yearLable.font = [UIFont boldSystemFontOfSize:13.0];
    self.yearLable.textAlignment = NSTextAlignmentCenter;
//     self.yearLable.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.yearLable];
    
    
    self.invesLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.33, Screen_Height * 0.12, Screen_Width * 0.32, Screen_Height * 0.03)];
    self.invesLable.textColor = UIColorFromRGB(0x474747);
    self.invesLable.text = @"投资金额(元)";
    self.invesLable.font = [UIFont boldSystemFontOfSize:13.0];
    self.invesLable.textAlignment = NSTextAlignmentCenter;
//     self.invesLable.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.invesLable];
    
    
    self.lixiLable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.66, Screen_Height * 0.12, Screen_Width * 0.32, Screen_Height * 0.03)];
    self.lixiLable.textColor = UIColorFromRGB(0x474747);
    self.lixiLable.text = @"待收本息(元)";
    self.lixiLable.font = [UIFont boldSystemFontOfSize:13.0];
    self.lixiLable.textAlignment = NSTextAlignmentCenter;
//     self.lixiLable.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.lixiLable];
    
    
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
