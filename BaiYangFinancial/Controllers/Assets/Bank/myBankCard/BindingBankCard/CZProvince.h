//
//  CZProvince.h
//  003省市选择
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZProvince : NSObject

/**
 *  省份名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  所辖城市
 */
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, copy) NSString *area;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
