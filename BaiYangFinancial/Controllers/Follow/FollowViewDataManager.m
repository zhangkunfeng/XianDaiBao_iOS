//
//  FollowViewDataManager.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/7.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "FollowViewDataManager.h"

@implementation FollowViewDataManager
+ (FollowViewDataManager *)manager
{
    static FollowViewDataManager *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _lettersArray      = [NSArray array];
        _followsListArray  = [NSArray array];
        _sectionTitleArray = [NSArray array];
    }
    return self;
}

- (NSArray *)getLettersArray{
    return _lettersArray;
}
- (NSArray *)getFollowsListArray{
    return _followsListArray;
}
- (NSArray *)getSectionTitleArray{
    return _sectionTitleArray;
}

@end
