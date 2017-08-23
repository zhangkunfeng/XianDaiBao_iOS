//
//  MyInviteHongBaoViewController.h
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/6/28.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, ShareDictType) {
    ShareDictType_iconImage = 0,
    ShareDictType_shareTitle,
    ShareDictType_shareDesc,
    ShareDictType_shareLink
};
@interface MyInviteHongBaoViewController : BaseViewController
@property (nonatomic,assign)ShareDictType type;

@end
