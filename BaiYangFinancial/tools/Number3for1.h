//
//  Number3for1.h
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/6/29.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Number3for1 : NSObject
//3位一隔 保留2位
+(NSString*)formatAmount:(NSString*)number;
//删除中间的,号
+(NSString*)forDelegateChar:(NSString *)str;

//label 设置中间文字颜色
+(NSMutableAttributedString *)addyourString:(NSString *)yourString withTextColor1:(UIColor *)textColor1 andTextColor2:(UIColor *)textColor2 rangeString1:(NSString *)rangeString1 andrangeString2:(NSString *)rangeString2;

+(NSString*)forNumMoeny:(NSString*)nummoeny;
+(NSString *)forMoenyString:(NSString *)num;
@end
