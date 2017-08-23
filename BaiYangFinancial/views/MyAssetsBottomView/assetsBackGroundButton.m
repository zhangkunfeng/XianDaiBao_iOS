//
//  assetsBackGroundButton.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/11/27.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "assetsBackGroundButton.h"

@implementation assetsBackGroundButton

//title
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 60, iPhoneWidth/3, 20);
}
//image
- (CGRect)backgroundRectForBounds:(CGRect)bounds{
    return CGRectMake((iPhoneWidth/3 - 31) / 2, 20, 31, 31);
}

@end
