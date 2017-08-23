//
//  WDMyFewardModel.m
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/23.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "NSString+CustomNil.h"
#import "WDMyFewardModel.h"

@implementation WDMyFewardDataModel

@end

@implementation WDMyFewardModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue {
    self = [super init];
    if (self) {
        [self parseResponseStatusToModel:dictionaryValue
                            successBlock:^(id data) {
                                self.allAmount = [NSString stringWithJsonStringAtNillIfNull:data[@"amount"]];
                                self.total = [NSString stringWithJsonStringAtNillIfNull:data[@"total"]];
                                if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                                    NSArray *dataArray = data[@"data"];
                                    NSMutableArray *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dict in dataArray) {
                                        WDMyFewardDataModel *model = [[WDMyFewardDataModel alloc] init];
                                        model.leavel = [NSString stringWithJsonStringAtNillIfNull:dict[@"leavel"]];
                                        model.amount = [NSString stringWithJsonStringAtNillIfNull:dict[@"amount"]];
                                        model.mobile = [NSString stringWithJsonStringAtNillIfNull:dict[@"mobile"]];
                                        model.percent = [NSString stringWithJsonStringAtNillIfNull:dict[@"percent"]];
                                        model.regTime = [NSString stringWithJsonStringAtNillIfNull:dict[@"regTime"]];
                                        [tempArray addObject:model];
                                    }
                                    self.dataArray = [NSMutableArray arrayWithArray:tempArray];
                                }
                            }];
    }
    return self;
}

@end
