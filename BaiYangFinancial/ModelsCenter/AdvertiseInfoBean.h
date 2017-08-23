//
//  AdvertiseInfoBean.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/22.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  广告信息模型

#import <Foundation/Foundation.h>

@interface AdvertiseInfoBean : NSObject
@property (nonatomic, retain) NSString *advertise_logo;
@property (nonatomic, retain) NSString *advertise_title;
@property (nonatomic, retain) NSString *advertise_url;

- (AdvertiseInfoBean *)initWithDictionary:(NSDictionary *)dict;

@end
