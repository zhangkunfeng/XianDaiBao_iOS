//
//  WDBaseModel.h
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/21.
//  Copyright © 2016年 无名小子. All rights reserved.
//  基础模型 数据返回状态

#import "NSString+CustomNil.h"
#import <Foundation/Foundation.h>

@class WDBaseModel;

typedef NS_ENUM(NSInteger, WDModelStatus) {
    WDModelFail,
    WDModelSuccess,
    WDModelTokenExpire,
    WDModelSidExpire
};

typedef void (^successBlock)(id data);

@interface WDBaseModel : NSObject

//响应数据状态
@property (nonatomic, assign) WDModelStatus r_status;
@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSString *msg;

//api返回错误信息
@property (nonatomic, copy) NSString *apiErrorMessage;

- (instancetype)parseResponseStatusToModel:(NSDictionary *)responseData successBlock:(successBlock)block;

@end

@interface WDBaseModel (WDBaseModelProtocol)

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue;

@end
