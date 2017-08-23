//
//  WDQuerySessionID.h
//  IOS-WeidaiCreditLoan
//
//  Created by 无名小子 on 16/4/25.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//
/**
 *  获取sessionID接口
 *
 *  逻辑：在请求失败时，会循环执行3次，如果3次都失败，就终止请求，并报错
 */
#undef AS_SINGLETON
#define AS_SINGLETON

#undef AS_SINGLETON
#define AS_SINGLETON(...)           \
- (instancetype) sharedInstance; \
+(instancetype) sharedInstance;

@interface WDQuerySessionID : NSObject

AS_SINGLETON(WDQuerySessionID)

- (void)querySessionIDWithSuccessBlock:(void (^)(id responseObj))successBlock withFailureBlock:(void (^)())failureBlock;

@end
