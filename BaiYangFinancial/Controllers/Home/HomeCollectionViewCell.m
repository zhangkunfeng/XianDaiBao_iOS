//
//  HomeCollectionViewCell.m
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/27.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *vView;

@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.vView.layer.cornerRadius = 5;
    self.vView.layer.shadowOffset = CGSizeMake(0,0);
    self.vView.layer.shadowColor = [UIColor colorWithRed:5 / 255.0 green:203 / 255.0 blue:243 / 255.0 alpha:1].CGColor;
    //[UIColor colorWithHex:@"05CBF3" alpha:0.3].CGColor;
    self.vView.layer.shadowRadius = 150;
    self.vView.layer.shadowOpacity = 0.2f;
    
    self.rateDescBottomRate.constant = (iPhone4||iPhone5)?-3:iPhone6?-1:0;
    
    
    //创建一个图形
    CGMutablePathRef squarePath = CGPathCreateMutable();
    //让图形的形状为正方形
    CGPathAddRect(squarePath, NULL, self.vView.frame);
    //设定阴影图形
    self.vView.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
}
- (IBAction)clickAction:(UIButton *)sender {
    if (_finishAction) {
        _finishAction();
    }
}

@end
