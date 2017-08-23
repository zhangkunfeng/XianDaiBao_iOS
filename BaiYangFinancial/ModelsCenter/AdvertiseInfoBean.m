//
//  AdvertiseInfoBean.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/22.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AdvertiseInfoBean.h"

@implementation AdvertiseInfoBean

- (AdvertiseInfoBean *)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _advertise_logo = dict[@"path"];
        _advertise_title = dict[@"title"];
        _advertise_url = dict[@"urlLink"];
    }
    return self;
}

@end
