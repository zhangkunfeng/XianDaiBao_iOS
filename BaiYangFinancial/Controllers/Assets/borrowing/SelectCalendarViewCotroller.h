//
//  SelectCalendarViewCotroller.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/18.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailPageNavigationView.h"

@interface SelectCalendarViewCotroller : BaseViewController<DetailPageNavigationViewDelegate>
/**
 *  点击返回日期
 */
@property (nonatomic, copy) void(^selectCalendarVCBlock)(NSInteger day, NSInteger month, NSInteger year);
@property (nonatomic, copy) NSString * titleStr;
- (void)setCalendarInit;
- (void)setupDetailPageNavigationViewTitleStr:(NSString *)titleStr;
@end
