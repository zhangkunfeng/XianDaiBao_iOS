//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDCalendar : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date;

//在调用初始化
- (void)setCurrentDate:(NSDate *)date;

/**
 *  点击返回日期
 */
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@end
