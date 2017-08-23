//
//  WeidaiActivityTableCell.h
//  BaiYangFinancial
//
//  Created by xgy on 2017/8/10.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeidaiActivityTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *ContentimageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

+(CGFloat)weidaiActivityTableViewCellHeight;

@end
