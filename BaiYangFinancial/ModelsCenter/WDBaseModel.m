//
//  WDBaseModel.m
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/21.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "WDBaseModel.h"

@implementation WDBaseModel

- (instancetype)parseResponseStatusToModel:(NSDictionary *)responseData successBlock:(successBlock)block {

    _item = [NSString stringWithJsonStringAtNillIfNull:responseData[@"item"]];
    _msg = [NSString stringWithJsonStringAtNillIfNull:responseData[@"msg"]];

    NSString *rStatus = [NSString stringWithJsonStringAtNillIfNull:responseData[@"r"]];
    if (([rStatus isEqualToString:@"1"])) {
        _r_status = WDModelSuccess;
        block(responseData);
    } else if ([rStatus isEqualToString:TOKEN_TIME]) {
        _r_status = WDModelTokenExpire;
    } else if ([rStatus isEqualToString:SESSION_EMPTY]) {
        _r_status = WDModelSidExpire;
    } else {
        _r_status = WDModelFail;
        _apiErrorMessage = _msg;
    }
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue {
    self = [super init];
    if (self) {
        [self parseResponseStatusToModel:dictionaryValue
                            successBlock:^(id data){
                            }];
    }
    return self;
}

@end
