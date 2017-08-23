//
//  CZProvince.m
//  003省市选择
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CZProvince.h"

@implementation CZProvince


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
