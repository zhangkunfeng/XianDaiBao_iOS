//
//  WDFinancialPlannerPagesModel.h
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/21.
//  Copyright © 2016年 无名小子. All rights reserved.
//  理财师模型

#import "WDBaseModel.h"

@interface WDFinancialPlannerDataListModel : WDBaseModel

@property (nonatomic, copy) NSString *mobile; /** 手机号 */
@property (nonatomic, copy) NSString *amount; /** 收益 */

@end

@interface WDFinancialPlannerPagesModel : WDBaseModel

@property (nonatomic, copy) NSString *financialName; /** 理财师称谓 */
@property (nonatomic, copy) NSString *firstRates;    /** 一级收益百分比 */
@property (nonatomic, copy) NSString *secRates;      /** 二级收益百分比 */
@property (nonatomic, copy) NSString *level;         /** 等级 等级1金牌理财师，2钻石理财师，3皇冠理财师 */
@property (nonatomic, copy) NSString *status;        /** 是否理财师0默认1是 */
@property (nonatomic, copy) NSString *amount;        /** 收益金额 */

@property (nonatomic, strong) NSMutableArray *dataListArray; /** 列表数据项 */

@end
