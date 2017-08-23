//
//  NSString+CustomNil.h
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/21.
//  Copyright © 2016年 无名小子. All rights reserved.
//  字符串分类 当字符串为空 设置为@""

#import <Foundation/Foundation.h>

@interface NSString (CustomNil)

+ (NSString *)stringWithJsonStringAtNillIfNull:(NSString *)string;

@end
