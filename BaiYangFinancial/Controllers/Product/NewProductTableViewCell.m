//
//  NewProductTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/19.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "NewProductTableViewCell.h"

@interface NewProductTableViewCell ()

@end

@implementation NewProductTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.addBidRateLable.layer.borderWidth = 0.5;
    self.addBidRateLable.layer.borderColor = [[UIColor colorWithRed:243/255.0 green:149/255.0 blue:69/255.0 alpha:1]CGColor];
    self.addbidLabConsW.constant = 60;
    
    
    
    self.zhaungtaiImg.transform = CGAffineTransformRotate(self.zhaungtaiImg.transform, -M_PI_4/2-0.2);
}

/**
 //iPhone 5 | iPhone 4 constant
 @property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;//25
 @property (weak, nonatomic) IBOutlet NSLayoutConstraint *investTimeDescLading;//30
 @property (weak, nonatomic) IBOutlet NSLayoutConstraint *investTimeLeading;//10
 @property (weak, nonatomic) IBOutlet NSLayoutConstraint *investStartLeading;//7
 */
- (void)setSmalliPhoneConstant
{
    if (iPhone4 || iPhone5) {
        self.titleLeading.constant = 15;
        self.investTimeDescLading.constant = 15;
        self.investTimeLeading.constant = 5;
        self.investStartLeading.constant = 3;
        self.projectTotalLeading.constant = 5;
    }
}

+ (id)NewproductTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"NewProductTableViewCell" owner:self options:nil] lastObject];
}

+ (NSString *)NewProductTableViewID {
    return @"NewProductTableViewCell";
}

+ (CGFloat)NewProductTableViewCellHeight {
    return 171;
}

@end
