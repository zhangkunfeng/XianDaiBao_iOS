//
//  AssetsRulesViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/3/7.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef NS_ENUM(NSInteger, RulesStyle) {
    ChangeRulesType = 0,     // 零钱计划规则
    AutoBidRulesType,        // 自动投标规则
};

@interface AssetsRulesViewController : BaseViewController<CustomUINavBarDelegate>

@property (nonatomic, assign)RulesStyle rulesType;

@end
