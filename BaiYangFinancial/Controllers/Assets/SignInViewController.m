//
//  SignInViewController.m
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/8/22.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "SignInViewController.h"
#import "CustomMadeNavigationControllerView.h"
@interface SignInViewController ()<CustomUINavBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}
@property(nonatomic,copy) NSMutableArray * arrayDS;
@property(nonatomic,assign) CGFloat iCurDaySize;
@end

@implementation SignInViewController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"签到送积分"];
    //移除错误界面
    [self hideMDErrorShowView:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"签到送积分"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    CustomMadeNavigationControllerView *signInView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"签到送积分" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:signInView];
    
     [self createTabelView];
    //初始化数组
    _arrayDS = [[NSMutableArray alloc] initWithCapacity:0];
    
}
- (void)createTabelView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width,Screen_Height - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (void)goBack{
    [self customPopViewController:0];
}

#pragma mark - UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifierdata = @"cell";
    UITableViewCell *ncell = [tableView dequeueReusableCellWithIdentifier:identifierdata];
    if(ncell == nil){
        ncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierdata];
    }
    return ncell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, iPhoneWidth, 140);
    headerView.backgroundColor = RGB(213, 25, 37);
    headerView.userInteractionEnabled = YES;
    
    UIScrollView * calendarView = [[UIScrollView alloc] init];
    calendarView.frame = CGRectMake(0, 0, iPhoneWidth, 50);
    [headerView addSubview:calendarView];
    
    [self createCalendarDetailView:calendarView];
    
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(50, CGRectGetMaxY(calendarView.frame), iPhoneWidth - 100, 20);
    detailLabel.text = @"已连续签到0天,已获得积分0";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:detailLabel];
    
    UIButton * detailBtn = [[UIButton alloc] init];
    detailBtn.frame = CGRectMake(iPhoneWidth - 25, CGRectGetMaxY(calendarView.frame), 15, 15);
    [detailBtn setBackgroundColor: [UIColor greenColor]];
    [headerView addSubview:detailBtn];
    
    UIButton * signInBtn = [[UIButton alloc] init];
    signInBtn.frame = CGRectMake(iPhoneWidth*0.37, CGRectGetMaxY(detailLabel.frame)+20, iPhoneWidth*0.26, 35);
    signInBtn.layer.cornerRadius = iPhoneWidth * 0.26 * 0.18;
    [signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(signInBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInBtn setBackgroundColor:[UIColor orangeColor]];
    [headerView addSubview:signInBtn];
    
    return headerView;
}

/**
 //2. 获取当前年份和月份和天数
 NSCalendar *calendar = [NSCalendar currentCalendar];
 unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
 NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
 NSInteger iCurYear = [components year];  //当前的年份
 NSInteger iCurMonth = [components month];  //当前的月份
 NSInteger iCurDay = [components day];  // 当前的号数
 */
- (void)createCalendarDetailView:(UIScrollView *)calendarView
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //本月
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *this = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) fromDate:[[NSDate alloc] init]];
    NSDate *thisMonDate = [calendar dateFromComponents:this];
    //得到这个月天数
    NSInteger dayNum = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:thisMonDate].length;
    NSInteger iCurDay = [this day];
    /*测试*/
//    NSInteger iCurDay = arc4random()%32;
//    NSInteger iCurDay = 31;
#pragma clang diagnostic pop
    
    NSInteger iCurMonth = [this month];
    
    NSLog(@"%ld",(long)dayNum);
    NSLog(@"%ld",(long)iCurDay);
    
    for (NSInteger i = 0; i < dayNum; i++) {
        UILabel * label = [[UILabel alloc] init];
        CGFloat labelWidth = iPhoneWidth / 11;
        label.frame = CGRectMake(i * labelWidth, 10, labelWidth, 30);
        label.text = [NSString stringWithFormat:@"%ld",(long)i+1];
        label.textAlignment = NSTextAlignmentCenter;
        if (i+1 == iCurDay) {
            label.textColor = [UIColor yellowColor];
            label.font = [UIFont boldSystemFontOfSize:20.0f];
            
            UILabel * monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth, 0, labelWidth, 10)];
            monthLabel.textColor = [UIColor orangeColor];
            monthLabel.text = [NSString stringWithFormat:@"%ld月",(long)iCurMonth];
            monthLabel.textAlignment = NSTextAlignmentCenter;
            monthLabel.font = [UIFont systemFontOfSize:13.0f];
            [calendarView addSubview:monthLabel];
            
        }else{
            label.textColor = [UIColor whiteColor];
        }
        
        NSArray * dayArray = [NSArray arrayWithObjects:@"1",@"11",@"4",@"15",@"6",@"7",@"9",@"13",@"18",@"19",@"23",@"27",@"29",@"31",nil];
        for (NSInteger j = 0; j < dayArray.count; j++) {
            if (i+1 == [dayArray[j] integerValue]) {
                UILabel * dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth + (labelWidth - 4)/2, 40, 4, 4)];
                dianLabel.backgroundColor = [UIColor greenColor];
                dianLabel.layer.masksToBounds = YES;
                dianLabel.layer.cornerRadius = 2;
                [calendarView addSubview:dianLabel];
            }
        }
        [calendarView addSubview:label];
      }
    
    if (iCurDay < 6) {
        _iCurDaySize = 0;
    }else if(iCurDay > 26){
        _iCurDaySize = iPhoneWidth / 11 * (26 - 6);//26居中 26+以后不再调整位置
    }else{
        _iCurDaySize = iPhoneWidth / 11 * (iCurDay - 6);
    }
    
    //    calendarView.delegate = self;
    calendarView.contentSize = CGSizeMake(dayNum * iPhoneWidth / 11, 50);
    calendarView.contentOffset = CGPointMake(_iCurDaySize, 0);//设置滚动到某个位置
    //    [calendarView setContentOffset:CGPointMake(200, 0) animated:YES];
    calendarView.showsHorizontalScrollIndicator = NO;

}
- (void)signInBtnClicked:(UIButton *)btn
{
    NSLog(@"当前点击了 btn");
    [btn setTitle:@"签到成功" forState:UIControlStateNormal];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//通过上下组视图添加高度来约束间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//组视图的预估高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    return 0;
//}

//组视图的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
////    return Screen_Height * 0.03;
//    return 0;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
