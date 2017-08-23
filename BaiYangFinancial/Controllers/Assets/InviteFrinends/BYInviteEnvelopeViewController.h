//
//  BYInviteEnvelopeViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/24.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, ShareDictType) {
    ShareDictType_iconImage = 0,
    ShareDictType_shareTitle,
    ShareDictType_shareDesc,
    ShareDictType_shareLink
};

@interface BYInviteEnvelopeViewController : BaseViewController
@property (nonatomic,assign)ShareDictType type;

@end
