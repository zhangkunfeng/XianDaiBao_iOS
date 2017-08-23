//
//  WDFinancialPlannerPagesModel.m
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/21.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "WDFinancialPlannerPagesModel.h"

@implementation WDFinancialPlannerDataListModel

@end

@implementation WDFinancialPlannerPagesModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue {
    self = [super init];
    if (self) {
        [self parseResponseStatusToModel:dictionaryValue
                            successBlock:^(id data) {
                                self.financialName = [NSString stringWithJsonStringAtNillIfNull:data[@"financialName"]];
                                self.firstRates = [NSString stringWithJsonStringAtNillIfNull:data[@"firstRates"]];
                                self.secRates = [NSString stringWithJsonStringAtNillIfNull:data[@"secRates"]];
                                self.level = [NSString stringWithJsonStringAtNillIfNull:data[@"level"]];
                                self.status = [NSString stringWithJsonStringAtNillIfNull:data[@"status"]];
                                self.amount = [NSString stringWithJsonStringAtNillIfNull:data[@"amount"]];

                                if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                                    NSArray *jsonArray = data[@"data"];
                                    NSMutableArray *temparray = [NSMutableArray array];

                                    [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        NSDictionary *jsonDic = (NSDictionary *) obj;
                                        WDFinancialPlannerDataListModel *financialPlannerDataListModel = [[WDFinancialPlannerDataListModel alloc] init];
                                        financialPlannerDataListModel.mobile = [NSString stringWithJsonStringAtNillIfNull:jsonDic[@"mobile"]];
                                        financialPlannerDataListModel.amount = [NSString stringWithJsonStringAtNillIfNull:jsonDic[@"amount"]];
                                        [temparray addObject:financialPlannerDataListModel];
                                    }];
                                    self.dataListArray = [NSMutableArray arrayWithArray:temparray];
                                }

                            }];
    }
    return self;
}

@end
