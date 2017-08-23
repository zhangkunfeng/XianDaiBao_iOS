//
//  weidaiActivityTableViewCell.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/10.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weidaiActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *ContentimageView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;

@property (weak, nonatomic) IBOutlet UIView *weidaiActivityContentView;
@property (weak, nonatomic) IBOutlet UILabel *NewsLabel;

+(id)initWithweidaiActivityTableViewCell;

+(CGFloat)weidaiActivityTableViewCellHeight;

+(NSString *)weidaiActivityTableViewCell_id;


@property (weak, nonatomic) IBOutlet UILabel *forGoLab;


@end
