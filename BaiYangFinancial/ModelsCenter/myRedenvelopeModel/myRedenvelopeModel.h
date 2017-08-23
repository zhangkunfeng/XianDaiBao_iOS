//
//  myRedenvelopeModel.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/16.
//  Copyright © 2016年 无名小子. All rights reserved.
//  红信封模型

#import <Foundation/Foundation.h>

@interface myRedenvelopeModel : NSObject

@property (copy, nonatomic) NSString *RedenvelopeID;
@property (copy, nonatomic) NSString *RedenvelopeTitle;
@property (copy, nonatomic) NSString *RedenvelopeTime;
@property (copy, nonatomic) NSString *RedenvelopeMinAount;
@property (copy, nonatomic) NSString *RedenvelopeStatus;
@property (copy, nonatomic) NSString *RedenvelopeMoney;
@property (assign, nonatomic) float RedenvelopeMaxRatio;
@property (copy, nonatomic) NSString *minDeadline;
@property (copy, nonatomic) NSString *RedenvelopeEndTime;
@property (copy, nonatomic) NSString *redpackSource;
//redpackSource(红包来源 1:平台红包 2:好友红包）
- (instancetype)initWithmyRedenvelopeModel:(NSDictionary *)dict;

@end
