//
//  choosePersonTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/6.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface choosePersonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iconTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

+ (id)MyFriendsTableViewCell;
+ (NSString *)MyFriendsTableViewCellID;
//+ (CGFloat)MyFriendsTableViewCellHeight;

@end
