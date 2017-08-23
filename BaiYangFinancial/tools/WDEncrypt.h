//
//  WDEncrypt.h
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/4/12.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

/**
 *  🔐加密文件
 */

#import <Foundation/Foundation.h>

@interface WDEncrypt : NSObject

/**
 *  md5加密
 */
+ (NSString *)md5FromString:(NSString *)str;

/**
 *  base64加密
 */
+ (NSString *)base64EncodedStringFromString:(NSString *)string;

/**
 *  sha1加密
 */
+ (NSString *)sha1:(NSString *)input;

@end
