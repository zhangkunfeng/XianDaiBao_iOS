//
//  InvierViewController.m
//  白杨
//
//  Created by 徐洪 on 15/11/5.
//  Copyright © 2015年 金鼎. All rights reserved.
//

#import "BidDetailViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "InviesTableViewCell.h"
#import "PaymentStatusTableViewCell.h"

@interface BidDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CustomUINavBarDelegate>
{
    UITableView  * tableview;
    NSMutableDictionary * _accinfoDetailArray;
    NSMutableArray * _repayListArray;
}
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter; //上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;

//@property (nonatomic, copy) NSMutableDictionary * accinfoDetailArray; //投资详情数组

@property (nonatomic ,copy) NSString * arc4NumStr;
@end

@implementation BidDetailViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"投资详情"];
    //移除错误界面
    [self hideMDErrorShowView:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"投资详情"];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomMadeNavigationControllerView * bidDetailView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"投资详情" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:bidDetailView];
    
   [self createTabelView];

    //初始化数组
    _accinfoDetailArray = [[NSMutableDictionary alloc] init];
    _repayListArray = [[NSMutableArray alloc] init];
    [self loadBidRecordDetailData];
    
    self.arc4NumStr = [NSString stringWithFormat:@"%u",arc4random()%1000];
}
- (void)createTabelView
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, /*Screen_Height * 0.6*/Screen_Height - 64) style:UITableViewStyleGrouped];
//    tableview.backgroundColor = [UIColor whiteColor];
    tableview.delegate = self;
    tableview.dataSource = self;
//    tableview.userInteractionEnabled = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
//    self.headView = [[TopView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, 150)];
//    self.headView.backgroundColor = [UIColor greenColor];
//    tableview.tableHeaderView = self.headView;
 
}
#pragma mark - 加载投标记录的数据
- (void)loadBidRecordDetailData {
    
    NSDictionary * parameters = @{
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"at":  getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"bid": self.bidString,
                                  };
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getBidDetailList",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadBidRecordDetailData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadBidRecordDetailData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                NSLog(@"Test投资记录页数据 = %@",responseObject[@"item"]);
                [self dismissWithDataRequestStatus];
                if (responseObject[@"item"]){
                    _accinfoDetailArray  = responseObject[@"item"];
                    if ([_accinfoDetailArray count] > 0) {
                        if (_accinfoDetailArray[@"repaylist"]) {
                            _repayListArray = _accinfoDetailArray[@"repaylist"];
                        }
                        [tableview reloadData];
                    } else {
                        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 108 + 64) contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                    }
                }
                
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 108 +64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
                                  
                              }];
}

//TODO:返回按钮
- (void)goBack {
    [self customPopViewController:0];
}

#pragma mark - UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return _repayListArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/*
 {
	account = 5000,
	title = cs011,
	repayAmonutAll = 5041.66,
	repaylist = [
 {
	recoverTime = 2016-08-08,
	status = 0,
	amount = 41.66
 },
 {
	recoverTime = 2016-08-08,
	status = 0,
	amount = 5000
 }
 ],
	borrowAnnualYield = 10,
	endDate = 2016-08-08
 }
 */
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *str = @"cell";
        InviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (cell == nil) {
            cell = [[InviesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
//        cell.backgroundColor = [UIColor greenColor];
        //标题
        if ([self isLegalObject:_accinfoDetailArray[@"title"]]) {
            cell.titleLable.text = [NSString stringWithFormat:@"%@",_accinfoDetailArray[@"title"]];
        }else{
//            cell.titleLable.text = [NSString stringWithFormat:@"测试%@",self.arc4NumStr];
            cell.titleLable.text = @"";
        }
        
        //日期
        if ([self isLegalObject:_accinfoDetailArray[@"endDate"]]) {
            cell.timeLable.text = [NSString stringWithFormat:@"%@",_accinfoDetailArray[@"endDate"]];
        }else{
//            cell.timeLable.text = [NSString stringWithFormat:@"2016-%u-%u",arc4random()%12,arc4random()%12];
            cell.timeLable.text = @"";
        }
        
        //年化收益率
        if ([self isLegalObject:_accinfoDetailArray[@"borrowAnnualYield"]]) {
            cell.rateLable.text =[NSString stringWithFormat:@"%.1f％",[_accinfoDetailArray[@"borrowAnnualYield"] doubleValue]];
        }else{
//            cell.rateLable.text = [NSString stringWithFormat:@"%.2f％",[self.arc4NumStr doubleValue]];
            cell.rateLable.text = @"";
        }
        //投资金额
        if ([self isLegalObject:_accinfoDetailArray[@"account"]]) {
//            cell.moneyLable.text = [NSString stringWithFormat:@"%.2f",[_accinfoDetailArray[@"account"] doubleValue]];
            cell.moneyLable.text = [Number3for1 formatAmount:_accinfoDetailArray[@"account"]];
        }else{
            cell.moneyLable.text = @"";
        }

        //待收本息  总额
        if ([self isLegalObject:_accinfoDetailArray[@"repayAmonutAll"]] ) {
            if ([_accinfoDetailArray[@"repayAmonutAll"] integerValue] == 0) {
                cell.nestLable.text = @"已完成";
            }else{
            cell.nestLable.text = [Number3for1 formatAmount:_accinfoDetailArray[@"repayAmonutAll"]];
            }
        }
        
        return cell;
    }
    
    else if (indexPath.section == 1)
    {
        static NSString *string = @"celltwo";
        PaymentStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PaymentStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        /*
        CGFloat arc4ColorRed   = arc4random()% 256 / 255.0f;
        CGFloat arc4ColorGreen = arc4random()% 256 / 255.0f;
        CGFloat arc4ColorBlue  = arc4random()% 256 / 255.0f;
        UIColor * color = [UIColor colorWithRed:arc4ColorRed green:arc4ColorGreen blue:arc4ColorBlue alpha:1];
        cell.backgroundColor = color;
        */
        //取消 cell 点击时有颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
           //时间
            if ([self isLegalObject:_repayListArray[indexPath.row][@"recoverTime"]]) {
                cell.TimeLable.text =[NSString stringWithFormat:@"%@", _repayListArray[indexPath.row][@"recoverTime"]];
            }else{
//                cell.TimeLable.text = [NSString stringWithFormat:@"2016-%u-%u",arc4random()%12,arc4random()%12];
                cell.TimeLable.text = @"";
            }

        //金额
        if ([self isLegalObject:_repayListArray[indexPath.row][@"amount"]]) {
//            cell.moneylable.text = [NSString stringWithFormat:@"%@",_repayListArray[indexPath.row][@"amount"]];
            cell.moneylable.text = [Number3for1 formatAmount:_repayListArray[indexPath.row][@"amount"]];
        }else{
//            cell.moneylable.text = [NSString stringWithFormat:@"%u",arc4random()%10000000];
            cell.moneylable.text = @"";
        }

        //金额
        if ([_repayListArray[indexPath.row][@"status"] integerValue] == 0) {
            cell.StatusLable.text = @"待还款";
            cell.LabelYLin.backgroundColor = [UIColor lightGrayColor];
            cell.roundLabel.backgroundColor = [UIColor lightGrayColor];
        }else{
            cell.StatusLable.text = @"已还款";
            cell.LabelYLin.backgroundColor = [UIColor colorWithHexString:@"#FB9300"];
            cell.roundLabel.backgroundColor = [UIColor colorWithHexString:@"#FB9300"];
        }
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView * oneSectionHeaderView = [[UIView alloc] init];
    oneSectionHeaderView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height * 0.122);
    oneSectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.03, Screen_Height * 0.02, Screen_Width * 0.8, Screen_Height *0.03)];
    if ([self isLegalObject:_accinfoDetailArray[@"predictRefundTime"]]) {
        lable.text = [NSString stringWithFormat:@"还款计划(%@)",_accinfoDetailArray[@"predictRefundTime"]];
    }else{
        lable.text = @"还款计划(预计当天18点返还)";
    }
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.textColor = UIColorFromRGB(0x474747);
    [oneSectionHeaderView addSubview:lable];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.15, Screen_Height * 0.07, Screen_Width * 0.15, Screen_Height * 0.03)];
    time.text = @"时间";
    time.font = [UIFont systemFontOfSize:16.0];
    time.textColor = UIColorFromRGB(0x474747);
    [oneSectionHeaderView addSubview:time];
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.4, Screen_Height * 0.07, Screen_Width * 0.3, Screen_Height * 0.03)];
    money.text = @"金额";
    money.textAlignment = NSTextAlignmentCenter;
    money.font = [UIFont systemFontOfSize:16.0];
    money.textColor = UIColorFromRGB(0x474747);
    [oneSectionHeaderView addSubview:money];
    UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width * 0.8, Screen_Height * 0.07, Screen_Width * 0.15, Screen_Height * 0.03)];
    status.text = @"状态";
    status.font = [UIFont systemFontOfSize:16.0];
    status.textColor = UIColorFromRGB(0x474747);
    [oneSectionHeaderView addSubview:status];
    
    UIView *xianview = [[UIView alloc]initWithFrame:CGRectMake(Screen_Width * 0.15, Screen_Height * 0.12, Screen_Width * 0.83, Screen_Height * 0.001)];
//    xianview.backgroundColor = UIColorFromRGB(0xf7f7f7);
    xianview.backgroundColor = [UIColor lightGrayColor];
    [oneSectionHeaderView addSubview:xianview];
    
    return oneSectionHeaderView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return Screen_Height * 0.17;
    }else
    {
        return Screen_Height * 0.071;
    }
  
}

//通过上下组视图添加高度来约束间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    return Screen_Height * 0.121;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
