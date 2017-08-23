//
//  UIColor+NotRGB.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/9.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NotRGB)

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
