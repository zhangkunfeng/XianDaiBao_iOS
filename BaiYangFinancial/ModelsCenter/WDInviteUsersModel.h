//
//  WDInviteUsersModel.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/23.
//  Copyright © 2016年 无名小子. All rights reserved.
//  邀请人模型

#import "WDBaseModel.h"

@interface recommendFriendsListModel : WDBaseModel

@property (copy, nonatomic) NSString *mobile;       //** 邀请人手机号 */
@property (copy, nonatomic) NSString *registerTime; //** 邀请人的注册时间 */
@property (copy, nonatomic) NSString *status;       //** 满足奖励的状态 (默认0 1为满足奖励) */

@end

@interface WDInviteUsersModel : WDBaseModel

@property (copy, nonatomic) NSString *recommendCount;       //** 推荐人数 */
@property (copy, nonatomic) NSString *successrecommenCount; //** 有效推荐人数 */
@property (copy, nonatomic) NSString *recommendListNumber;  //** 推荐列表 */

@property (strong, nonatomic) NSMutableArray *recommendFriendsList; //** 推荐好友列表 */

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
