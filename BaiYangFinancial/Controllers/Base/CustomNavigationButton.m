//
//  CustomNavigationButton.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "CustomNavigationButton.h"

@implementation CustomNavigationButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, (44 - 18)/2, 50, 18);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((40 - 32)/2, (44 - 32)/2, 32, 32);
}


@end
