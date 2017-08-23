//
//  investedUserModel.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/10/15.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  投资用户模型

#import <Foundation/Foundation.h>

@interface investedUserModel : NSObject

@property (nonatomic, copy)NSString *useriPhoneNumber;
@property (nonatomic, copy)NSString *currentTenderAmount;
@property (nonatomic, copy)NSString *tenderTime;


- (id)initWithinvestedDict:(NSDictionary *)dict;

@end
