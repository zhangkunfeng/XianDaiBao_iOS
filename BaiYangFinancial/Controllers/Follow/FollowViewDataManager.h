//
//  FollowViewDataManager.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/7.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowViewDataManager : NSObject

@property (nonatomic, strong) NSArray * lettersArray;
@property (nonatomic, strong) NSArray * followsListArray;
@property (nonatomic, strong) NSArray * sectionTitleArray;

+ (FollowViewDataManager *)manager;

- (NSArray *)getLettersArray;
- (NSArray *)getFollowsListArray;
- (NSArray *)getSectionTitleArray;

@end
