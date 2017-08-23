//
//  NewProductListViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, ProductStyle) {
    ProductStyle_shortBid = 0,
    ProductStyle_longBid,
    ProductStyle_transformBid
};
@interface NewProductListViewController : BaseViewController
@property (nonatomic,assign)ProductStyle type;
@end
