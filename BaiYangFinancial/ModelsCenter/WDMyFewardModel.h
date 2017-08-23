//
//  WDMyFewardModel.h
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/23.
//  Copyright © 2016年 无名小子. All rights reserved.
//  投资人模型

#import "WDBaseModel.h"

@interface WDMyFewardDataModel : WDBaseModel

@property (nonatomic, copy) NSString *leavel;  /** 等级 */
@property (nonatomic, copy) NSString *amount;  /** 收益 */
@property (nonatomic, copy) NSString *mobile;  /** 手机号 */
@property (nonatomic, copy) NSString *percent; /** 百分比 */
@property (nonatomic, copy) NSString *regTime; /** 时间 */

@end

@interface WDMyFewardModel : WDBaseModel

@property (nonatomic, copy) NSString *allAmount; /** 收益 */
@property (nonatomic, copy) NSString *total;  //** 符合返利奖励的投资人 */
@property (nonatomic, strong) NSMutableArray<WDMyFewardDataModel *> *dataArray;

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue;

@end
