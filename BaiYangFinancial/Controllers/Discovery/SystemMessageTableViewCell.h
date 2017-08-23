//
//  SystemMessageTableViewCell.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/14.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *systemMessageImage;
@property (weak, nonatomic) IBOutlet UILabel *systemContentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *frameBtn;//布局btn

+(id)initWithSystemMessageTableViewCell;

+(NSString *)initWithSystemMessageTableViewCell_ID;

+(CGFloat)initWithSystemMessageTableViewCell_height;

- (CGFloat)cellHeight;

@end
