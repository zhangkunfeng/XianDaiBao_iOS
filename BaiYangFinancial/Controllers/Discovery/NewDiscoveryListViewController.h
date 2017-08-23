//
//  NewDiscoveryListViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/29.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, DiscoveryStyle) {
    Discovery_activity = 0,   // 贤钱宝动态
    Discovery_message,        // 我的消息
};

@interface NewDiscoveryListViewController : BaseViewController
{
    BOOL isOpenCell; //记录系统消息打开状态
    NSInteger currentClickIndex;  //系统消息的当前的index
}
@property (nonatomic, copy)NSMutableArray *discoveryMutabArray; //存放数据的数组
@property (nonatomic,assign)DiscoveryStyle type;
@end
