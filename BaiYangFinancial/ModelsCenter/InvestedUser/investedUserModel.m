//
//  investedUserModel.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/10/15.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "investedUserModel.h"

@implementation investedUserModel
@synthesize useriPhoneNumber;
@synthesize currentTenderAmount;
@synthesize tenderTime;


- (id)initWithinvestedDict:(NSDictionary *)dict{
    if((self = [super init])) {
        if ([self isLegalObject:dict[@"userName"]]) {
            self.useriPhoneNumber = dict[@"userName"];
        }else{
            self.useriPhoneNumber = @"";
        }
        
        if ([self isLegalObject:dict[@"currentTenderAmount"]]) {
            self.currentTenderAmount = dict[@"currentTenderAmount"];
        }else{
            self.currentTenderAmount = @"";
        }
        
        if ([self isLegalObject:dict[@"successTime"]]) {
            self.tenderTime = dict[@"successTime"];
        }else{
            self.tenderTime = @"";
        }
    }
    return self;
}

- (BOOL)isLegalObject:(NSObject *)object {
    if (object == nil) {
        return NO;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

@end
