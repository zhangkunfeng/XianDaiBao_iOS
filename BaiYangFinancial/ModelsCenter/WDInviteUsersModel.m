//
//  WDInviteUsersModel.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/23.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "NSString+CustomNil.h"
#import "WDInviteUsersModel.h"

@implementation recommendFriendsListModel

@end

@implementation WDInviteUsersModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self parseResponseStatusToModel:dict successBlock:^(id data) {
            self.recommendCount = [NSString stringWithJsonStringAtNillIfNull:data[@"refCount"]];
            self.successrecommenCount = [NSString stringWithJsonStringAtNillIfNull:data[@"successCount"]];
            self.recommendListNumber = [NSString stringWithJsonStringAtNillIfNull:data[@"total"]];

            if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *jsonArray = data[@"data"];
                NSMutableArray *temparray = [NSMutableArray array];
                [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *jsonDic = (NSDictionary *) obj;
                    recommendFriendsListModel *friendsListModel = [[recommendFriendsListModel alloc] init];
                    friendsListModel.mobile = [NSString stringWithJsonStringAtNillIfNull:jsonDic[@"mobile"]];
                    friendsListModel.registerTime = [NSString stringWithJsonStringAtNillIfNull:jsonDic[@"regTime"]];
                    if ([jsonDic[@"status"] integerValue] == 1) {
                        friendsListModel.status = @"有效邀请人";
                    } else {
                        friendsListModel.status = @"无效邀请人";
                    }
                    [temparray addObject:friendsListModel];
                }];
                self.recommendFriendsList = [NSMutableArray arrayWithArray:temparray];
            }
        }];
        return self;
    }
    return nil;
}

@end
