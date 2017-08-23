//
//  payLoadview.m
//  weidaiwang
//
//  Created by 艾运旺 on 15/8/11.
//  Copyright (c) 2015年 艾运旺. All rights reserved.
//

#import "payLoadview.h"

@implementation payLoadview

-(id)initWithPayloadView{
    self = [[[NSBundle mainBundle] loadNibNamed:@"payLoadview" owner:self options:nil] lastObject];
    if (self) {
        CGRect rectFarm = self.frame;
        rectFarm.size.width = iPhoneWidth;
        rectFarm.size.height = iPhoneHeight - 64;
        self.frame = rectFarm;
        
        self.payLoadImageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"支付加载1"],
                                                 [UIImage imageNamed:@"支付加载2"],
                                                 [UIImage imageNamed:@"支付加载3"],nil];
//        self.payLoadImageView.animationDuration = 1.0;
//        self.payLoadImageView.animationRepeatCount = 0;
    }
    return self;
}

-(void)stratImageAnimating{
    self.layer.hidden = NO;
    self.payLoadImageView.animationDuration = 1.2;
    self.payLoadImageView.animationRepeatCount = 0;
    [self.payLoadImageView startAnimating];
}

-(void)stopImageAnimating{
    [self.payLoadImageView stopAnimating];
}

@end
