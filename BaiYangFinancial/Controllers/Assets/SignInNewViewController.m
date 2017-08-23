//
//  SignInNewViewController.m
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/8/28.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "SignInNewViewController.h"
#import "FyCalendarView.h"
#import "CustomMadeNavigationControllerView.h"
#import "SignInHeaderView.h"
#import "AlertSignSuccessInView.h"

@interface SignInNewViewController ()<CustomUINavBarDelegate,SignInHeaderViewDelegate,AlertSignSuccessInViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) FyCalendarView * calendarView;
@property(nonatomic,strong) SignInHeaderView * signInHeaderView;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) UIView * sectionHeaderView;
@property(nonatomic,copy) NSMutableArray * arrayDS;

@property(nonatomic,assign) NSInteger upLoadYear;
@property(nonatomic,assign) NSInteger upLoadMonth;
@property(nonatomic,strong) AlertSignSuccessInView * alertSignSuccessInView;
@property(nonatomic,copy)NSMutableArray *signInDaysListArray; //存放数据的数组
@property(nonatomic,copy) NSString * signInIntegralString;//签到获得总积分
@property (nonatomic,assign) BOOL requestEndFlag;

@end

@implementation SignInNewViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"每日签到"];
    //移除错误界面
    [self hideMDErrorShowView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"每日签到"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    CustomMadeNavigationControllerView *signInView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"每日签到" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:signInView];
    _requestEndFlag = NO;//默认
    self.date = [NSDate date]; //2016-08-30 07:56:11 +0000
    //初始化数组
    _signInDaysListArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self createTabelView];
    [self loadCurrentCalendarInfo:self.date];//获取当前日历/
    [self loadAllSignIninfo:self.date];
    [self setupCalendarView];
}

- (void)loadCurrentCalendarInfo:(NSDate *)date
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    _upLoadYear = [comp year];
    _upLoadMonth = [comp month];
}

- (void)createTabelView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, /*Screen_Height * 0.6*/Screen_Height-24) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [self addTableViewHeaderView];
}
- (void)goBack{
    [self customPopViewController:0];
}
#pragma mark - 签到
- (void)loadEveryDaySignIninfo:(UIButton *)btn {
    
    NSDictionary * parameters = @{@"uid": getObjectFromUserDefaults(UID),
                                  @"at":  getObjectFromUserDefaults(ACCESSTOKEN) };
    [self showWithDataRequestStatus:@"签到中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/sign",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadEveryDaySignIninfo:btn];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadEveryDaySignIninfo:btn];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"点击本日签到返回数据 = %@",responseObject);
                [self dismissWithDataRequestStatus];
                if ([responseObject[@"bool"] integerValue] == 0 && [btn.titleLabel.text isEqualToString:@"签到成功"]) {
                    [self errorPrompt:3.0 promptStr:@"您今天已经签过到了"];
                }else{
                    [btn setTitle:@"签到成功" forState:UIControlStateNormal];
                    //当前签到 获得积分
                    NSString * currentSignInIntegal;
                    if ([self isLegalObject:responseObject[@"currentSignInIntegral"]]) {
                        currentSignInIntegal = [NSString stringWithFormat:@"%@",responseObject[@"currentSignInIntegral"]];
                    }else{
                        currentSignInIntegal = @"1";
                    }
                    //_alertSignSuccessInView 传不去  得 self.alertSignSuccessInView
                    [self.alertSignSuccessInView setCurrentSignInIntegral:currentSignInIntegal];
                    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.alertSignSuccessInView];
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

#pragma mark - 判断请求数据是否成功
- (void)waitingRequestEnd
{
    _requestEndFlag = NO; //否则不 runloop
    if ([NSThread currentThread] == [NSThread mainThread]) {
        while (!_requestEndFlag){
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
        }
    }else
    {
        @autoreleasepool{
            while (_requestEndFlag){
                [NSThread sleepForTimeInterval:0.3];
            }
        }
    }
}


#pragma mark -  加载签到信息
- (void)loadAllSignIninfo:(NSDate *)selfDate {
    
//    NSLog(@"%ld",(long)_upLoadYear);
//    NSLog(@"%ld",(long)_upLoadMonth);
    
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at":  getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"year": [NSString stringWithFormat:@"%ld",(long)_upLoadYear],
                                  @"moth": [NSString stringWithFormat:@"%ld",(long)_upLoadMonth]
                                  };
    WS(weakSelf);
    [self showWithDataRequestStatus:@"获取中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@sign/info", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadAllSignIninfo:selfDate];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadAllSignIninfo:selfDate];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                _requestEndFlag = YES;
                NSLog(@"提交%ld年%ld月返回签到信息 = %@",(long)_upLoadYear,(long)_upLoadMonth,responseObject);
                [self dismissWithDataRequestStatus];
                
                if ([_signInDaysListArray count] > 0) {
                    [_signInDaysListArray removeAllObjects];
                }
                if ([responseObject[@"signInDaysList"] isKindOfClass:[NSArray class]]) {
                    NSArray * array = responseObject[@"signInDaysList"];
                    if (array.count > 0) {
                        for (id info in array) {
                            NSString * numberDay = [NSString stringWithFormat:@"%d",[info intValue]];
                            [_signInDaysListArray addObject:numberDay];
                        }
                    }
                    self.calendarView.allDaysArr = [NSArray arrayWithArray:_signInDaysListArray];
                    [self.calendarView createCalendarViewWith:selfDate];
                }
                
                //是否已签到
                if ([responseObject[@"bool"] integerValue] == 0) {
                    [_signInHeaderView setIsSignInData:YES];
                }
                
                //签到总积分
                if ([self isLegalObject:responseObject[@"signInIntegral"]]) {
                    self.signInIntegralString =[NSString stringWithFormat:@"%@", responseObject[@"signInIntegral"]];
                }else{
                    self.signInIntegralString = @"0";
                }
                [_signInHeaderView setSignInIntegralData:self.signInIntegralString];
                
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (void)addTableViewHeaderView
{
    if (!_signInHeaderView) {
        _signInHeaderView = [[SignInHeaderView alloc] initWithViewFram:CGRectMake(0, 64, iPhoneWidth, 314 + 11) viewController:self theDelegate:self];
        _signInHeaderView.delegate = self;
    }
    self.tableView.tableHeaderView = _signInHeaderView;
}
- (void)setupCalendarView {
    
    self.calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 278)];
    [self.sectionHeaderView addSubview:self.calendarView];
    //    self.calendarView.isShowOnlyMonthDays = NO;
    self.calendarView.date = [NSDate date];//创建日历  防止无网为空白
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);   //选择日期回调
    };
    
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){ //点击月份回调
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

- (void)setupNextMonth {
    
    [self.calendarView removeFromSuperview];
    self.calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 278)];
    [self.sectionHeaderView addSubview:self.calendarView];
    self.date = [self.calendarView nextMonth:self.date];
    [self loadCurrentCalendarInfo:self.date];
    [self loadAllSignIninfo:self.date];
    self.calendarView.date = self.date;//创建日历  防止无网为空白
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

- (void)setupLastMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 278)];
    [self.sectionHeaderView addSubview:self.calendarView];
    self.date = [self.calendarView lastMonth:self.date];
    [self loadCurrentCalendarInfo:self.date];
    [self loadAllSignIninfo:self.date];
    self.calendarView.date = self.date;//创建日历  防止无网为空白
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    
    WS(weakSelf)
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
}
#pragma mark - SignInHeaderViewDelegate
- (void)ClickedSignInBtn:(UIButton *)btn
{
    [self loadEveryDaySignIninfo:btn];
}
- (void)ClickedClickIntegralShake
{
    [self errorPrompt:3.0 promptStr:@"后续开放,敬请期待!"];
}

#pragma  mark - alertSignSuccessInView
- (AlertSignSuccessInView *)alertSignSuccessInView
{
    if (!_alertSignSuccessInView) {
        _alertSignSuccessInView = [[AlertSignSuccessInView alloc] init];
        _alertSignSuccessInView.delegate = self;
    }
    return _alertSignSuccessInView;
}
#pragma  mark - alertSignSuccessInViewDelegate
- (void)closeSignInSuccessView
{
    [self dismissPopupController];
    [self loadAllSignIninfo:[NSDate date]];//确保本月
}

#pragma mark - UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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
    if (!self.sectionHeaderView) {
        self.sectionHeaderView = [[UIView alloc] initWithFrame:self.calendarView.frame];
        [self.sectionHeaderView addSubview:self.calendarView];
    }
    return self.sectionHeaderView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 278;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
