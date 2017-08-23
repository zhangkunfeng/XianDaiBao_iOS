//
//  SelectCalendarViewCotroller.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/18.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "SelectCalendarViewCotroller.h"
#import "FDCalendar.h"

@interface SelectCalendarViewCotroller ()
{
    FDCalendar *_calendar;
    DetailPageNavigationView *_borrowingRecordView;
}
@end

@implementation SelectCalendarViewCotroller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setQLStatusBarStyleDefault];
    
    DetailPageNavigationView *borrowingRecordView = [[DetailPageNavigationView alloc] initWithDetailPageNavigationViewTitle:_titleStr?_titleStr:@"请选择日期" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:borrowingRecordView];
    _borrowingRecordView = borrowingRecordView;
    
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = calendar.frame;
    frame.origin.y = 64;
    calendar.frame = frame;
    [self.view addSubview:calendar];
    _calendar = calendar;
    
    calendar.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"主页面回调 = %li-%li-%li", (long)year,(long)month,(long)day);   //选择日期回调
        if (self.selectCalendarVCBlock) {
            self.selectCalendarVCBlock(day, month, year);
        }
        [self customPopViewController:0];
    };
}

//在调用初始化
- (void)setCalendarInit{
    [_calendar setCurrentDate:[NSDate date]];
}

- (void)setupDetailPageNavigationViewTitleStr:(NSString *)titleStr{
    [_borrowingRecordView setupTitleStr:titleStr];
}

- (void)goBack{
    [self customPopViewController:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
