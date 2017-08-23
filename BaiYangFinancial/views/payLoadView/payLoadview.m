//
//  payLoadview.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/11.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "payLoadview.h"

@implementation payLoadview

- (id)initWithPayloadView{
    self = [[[NSBundle mainBundle] loadNibNamed:@"payLoadview" owner:self options:nil] lastObject];
    if (self) {
        CGRect rectFarm = self.frame;
        rectFarm.size.width = iPhoneWidth;
        rectFarm.size.height = iPhoneHeight - 64;
        self.frame = rectFarm;
        
        
        for (int i = 0; i < 12; i++) {
            
        }
        
        self.payLoadImageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"支付动画1"],
                                                 [UIImage imageNamed:@"支付动画2"],
                                                 [UIImage imageNamed:@"支付动画3"],nil];
    }
    return self;
}

- (void)stratImageAnimating{
    self.layer.hidden = NO;
    self.payLoadImageView.animationDuration = 1.2;
    self.payLoadImageView.animationRepeatCount = 0;
    [self.payLoadImageView startAnimating];
}

- (void)stopImageAnimating{
    [self.payLoadImageView stopAnimating];
}

@end
