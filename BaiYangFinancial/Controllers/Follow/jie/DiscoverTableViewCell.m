//
//  DiscoverTableViewCell.m
//  jiejie
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Déesse. All rights reserved.
//

#import "DiscoverTableViewCell.h"

@interface DiscoverTableViewCell ()

@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, -M_PI_4/2-0.2);
}
+(id)initWithweidaiActivityTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"DiscoverTableViewCell" owner:self options:nil] lastObject];
}

+(CGFloat)weidaiActivityTableViewCellHeight{
    if (iPhoneWidth == 320) {
        return 213;
    }else if (iPhone6){
        return 238;
    }else if(iPhone6_){
        return 264;
    }else{
        return 244;
    }
}

+(NSString *)weidaiActivityTableViewCell_id{
    return @"DiscoverTableViewCell_id";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
