//
//  MyFriendsTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/26.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userBronzeHeadLabelView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailPhoneLabel;

+ (id)MyFriendsTableViewCell;
+ (NSString *)MyFriendsTableViewCellID;
+ (CGFloat)MyFriendsTableViewCellHeight;

@end
