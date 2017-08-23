//
//  WDQueryAccessToken.h
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/4/13.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

/**
 *  获取access_token接口
 *
 *  逻辑：在请求失败时，会循环执行3次，如果3次都失败，就终止请求，并报错
 *
 */

#define AS_SINGLETON(...)           \
- (instancetype) sharedInstance; \
+(instancetype) sharedInstance;

@interface WDQueryAccessToken : NSObject

AS_SINGLETON(WDQueryAccessToken)

/**
 *  获取access_token接口
 *
 *  @param successBlock 一般我们用不到，只是知道请求成功了，responseObj其实是WDAccessTokenModel
 *  @param failureBlock 请求失败的回调
 */
- (void)queryAccessTokenWithSuccessBlock:(void (^)(id responseObj))successBlock withFailureBlock:(void (^)())failureBlock;

@end
