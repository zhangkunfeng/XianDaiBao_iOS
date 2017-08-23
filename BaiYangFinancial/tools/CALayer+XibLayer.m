//
//  CALayer+XibLayer.m
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/6/28.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "CALayer+XibLayer.h"

@implementation CALayer (XibLayer)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
