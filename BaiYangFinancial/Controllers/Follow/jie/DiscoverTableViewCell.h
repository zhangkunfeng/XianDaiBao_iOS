//
//  DiscoverTableViewCell.h
//  jiejie
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Déesse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverTableViewCell : UITableViewCell

+(id)initWithweidaiActivityTableViewCell;

+(CGFloat)weidaiActivityTableViewCellHeight;

+(NSString *)weidaiActivityTableViewCell_id;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nianHuaLab;
@property (weak, nonatomic) IBOutlet UILabel *dataLabOne;
@property (weak, nonatomic) IBOutlet UILabel *moenyLab;
@property (weak, nonatomic) IBOutlet UILabel *isOrNoLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
