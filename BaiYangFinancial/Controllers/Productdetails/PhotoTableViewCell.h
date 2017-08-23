//
//  PhotoTableViewCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/7.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

+(id)initWithPhotoTableViewCell;
+(NSString *)initWithPhotoTableViewCell_ID;
+(CGFloat)initWithPhotoTableViewCellHeight;

@end
