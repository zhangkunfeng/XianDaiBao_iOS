//
//  WDFinancialPlannerViewController.m
//  weidaitest
//
//  Created by yaoqi on 16/3/16.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//


#import "Masonry.h"
#import "WDAlertView.h"
#import "AFNetworkTool.h"
#import "UIAlertView+Blocks.h"
#import "WDInviteUsersViewController.h"
//#import "MyInviteHongBaoViewController.h"
#import "BYInviteEnvelopeViewController.h"
#import "WDApplyFinancialPlannerModel.h"
#import "WDArdawRecordsViewController.h"
#import "WDFinancialPlannerPagesModel.h"
#import "WDFinancialPlannerViewController.h"
#import "WDInvestmentRecordsViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "FinancialRuleViewController.h"

static NSString *const content1 = @"我愿意加入贤钱宝理财师行列!"/*@"我愿意加入贤钱宝理财师行列《贤钱宝理财师规则》"*/;
static NSString *const content2 = @"...";
static NSString *const content3 = @"您的资金不足，请去充值后再来申请";
static NSString *const content4 = @"提交成功!~请耐心等待相关工作人员审核.";
static NSString *const buttonTitle1 = @"确定申请";
static NSString *const buttonTitle2 = @"确定";
static NSInteger const buttonTag1 = 101;
static NSInteger const buttonTag2 = 102;
static NSInteger const buttonTag3 = 103;
static NSInteger const buttonTag4 = 104;
static NSInteger const buttonTag5 = 105;

@interface WDFinancialPlannerViewController () <UITableViewDataSource, UITableViewDelegate, CustomUINavBarDelegate, WDAlertViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIImageView *animationImageView;
@property (strong, nonatomic) UIImageView *bannerImageView;

//数据配置
@property (strong, nonatomic) NSArray *imageIconArray;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *detailTitleArray;
@property (strong, nonatomic) WDFinancialPlannerPagesModel *financialPlannerPagesModel;

//动画
@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UILabel *currentPhoneLabel;
@property (strong, nonatomic) UILabel *currentTotalAssetsLabel;
@property (strong, nonatomic) UILabel *currentApplicationLabel;

@property (strong, nonatomic) UIView *hidenView;
@property (strong, nonatomic) UILabel *hidenPhoneLabel;
@property (strong, nonatomic) UILabel *hidenTotalAssetsLabel;
@property (strong, nonatomic) UILabel *hidenApplicationLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count; //取数组的第几个对象
@property (assign, nonatomic) NSInteger flag;  //标识当前是哪个view显示(currentView/hidenView)
@property (assign, nonatomic) BOOL isApplyfor; //是否申请理财师

@property (strong, nonatomic) WDAlertView *alertView;
@property (strong, nonatomic) UIButton *inviteFriendsButton;

@end

@implementation WDFinancialPlannerViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    [self queryFinancialPlanner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self showAnimation];
}

/* 下面有停止 方法*/
//页面将要进入前台，开启定时器
- (void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
}
//页面消失，进入后台不显示该页面，关闭定时器
- (void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

//暂加
- (void)dealloc
{
    [_timer invalidate];
}

#pragma mark - Action
- (void)buttonClicked:(UIButton *)button {
    NSInteger status = [self.financialPlannerPagesModel.status integerValue];
    if (status == 2) {
        if (self.isApplyfor) {
            [self addAlertViewWithContent:content4 buttonTitle:buttonTitle2 buttonTag:buttonTag4];
        } else {
            [self addAlertViewWithContent:content1 buttonTitle:buttonTitle1 buttonTag:buttonTag1];
        }
    } else if (status == 1) {
        //邀请好友送红包
//        MyInviteHongBaoViewController * invite = [[MyInviteHongBaoViewController alloc] init];
//        [self customPushViewController:invite customNum:0];
        
        BYInviteEnvelopeViewController * invite = [[BYInviteEnvelopeViewController alloc] init];
        [self customPushViewController:invite customNum:0];
    }
//        else if (status == 0) {
//             [self addAlertViewWithContent:content4 buttonTitle:buttonTitle2 buttonTag:buttonTag4];
////             [self addAlertViewWithContent:content1 buttonTitle:buttonTitle1 buttonTag:buttonTag1];/*测试*/
//        }
}
#pragma mark - Private Methods
- (void)initData {
    self.count = 0;
    self.flag = 0;
    
    //    self.imageIconArray = @[
    //        @"invited-users-icon",
    //        @"award-records-icon",
    //        @"invited-records-icon",
    //        @"rules-icon",
    //    ];
    self.titleArray = @[
                        @"邀请的好友",
                        @"奖励记录",
                        @"收益记录",
//                        @"理财师详细规则",
                        ];
    //    self.detailTitleArray = @[
    //        @"看看有几人",
    //        @"我赚了多少",
    //        @"他们投资了吗",
    //        @"规则明明白白",
    //    ];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    CustomMadeNavigationControllerView *financialView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"理财师" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:financialView];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 63.5, iPhoneWidth, 0.5);
    lineLabel.backgroundColor = [UIColor darkGrayColor];
    lineLabel.alpha = 0.15;
    [self.view addSubview:lineLabel];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight * 0.35)];
    view.backgroundColor = AppMianColor;
//    [self setTheGradientWithView:view];
    [self.view addSubview:view];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-28) style:UITableViewStyleGrouped];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 55.f;
    //去除多余 cell  当今无须
    //    self.myTableView.separatorInset = UIEdgeInsetsZero;
    //    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.myTableView];
    
    UIButton * dobutBtn = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth-47, 20, 44, 44)];
    [dobutBtn setImage:[UIImage imageNamed:@"moneyChange_dobut"] forState:UIControlStateNormal];
    [dobutBtn addTarget:self action:@selector(dobutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [financialView addSubview:dobutBtn];

}

- (void)dobutBtnClicked:(id)sender
{
    FinancialRuleViewController * financialRuleVC = [[FinancialRuleViewController alloc] init];
    [self customPushViewController:financialRuleVC customNum:0];
//    [self jumpToWebview:FinancialPlannerRulesURL webViewTitle:@"贤钱宝理财师规则"];
}
/*
 - (void)showAnimation {
 
 [UIView animateWithDuration:1.0 animations:^{
 [self.animationImageView.layer setValue:@185.0 forKeyPath:@"transform.translation.y"];
 }
 completion:^(BOOL finished){
 
 }];
 }
 
 - (void)hideAnimation {
 [UIView animateWithDuration:1.0 animations:^{
 [self.animationImageView.layer setValue:@-125.0 forKeyPath:@"transform.translation.y"];
 }
 completion:^(BOOL finished) {
 [self.animationImageView removeFromSuperview];
 }];
 }*/

- (void)createCurrentView:(UIView *)containerView {
    self.currentView = [[UIView alloc] init];
    //    self.currentView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    self.currentView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    WDFinancialPlannerDataListModel *financialPlannerDataListModel = self.financialPlannerPagesModel.dataListArray[self.count];
    
    self.currentPhoneLabel = [[UILabel alloc] init];
    [self.currentPhoneLabel setText:financialPlannerDataListModel.mobile];
    [self.currentPhoneLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.currentPhoneLabel setTextColor:[UIColor whiteColor]];
    [self.currentPhoneLabel setTextAlignment:NSTextAlignmentCenter];
    [self.currentView addSubview:self.currentPhoneLabel];
    
    self.currentTotalAssetsLabel = [[UILabel alloc] init];
    [self.currentTotalAssetsLabel setText:[NSString stringWithFormat:@"总资产%.2f万元", [financialPlannerDataListModel.amount doubleValue] / 10000]];
    [self.currentTotalAssetsLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.currentTotalAssetsLabel setTextColor:[UIColor whiteColor]];
    [self.currentTotalAssetsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.currentView addSubview:self.currentTotalAssetsLabel];
    
    self.currentApplicationLabel = [[UILabel alloc] init];
    [self.currentApplicationLabel setText:@"正在申请理财师"];
    [self.currentApplicationLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.currentApplicationLabel setTextColor:[UIColor whiteColor]];
    [self.currentApplicationLabel setTextAlignment:NSTextAlignmentCenter];
    [self.currentView addSubview:self.currentApplicationLabel];
    
    [self.currentPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentView.mas_leading).offset(0);
        make.top.equalTo(self.currentView.mas_top);
        make.bottom.equalTo(self.currentView.mas_bottom);
        make.width.equalTo(self.currentTotalAssetsLabel.mas_width);
    }];
    
    [self.currentTotalAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentView.mas_top);
        make.bottom.equalTo(self.currentView.mas_bottom);
        make.leading.equalTo(self.currentPhoneLabel.mas_trailing);
        make.trailing.equalTo(self.currentApplicationLabel.mas_leading);
        make.width.equalTo(self.currentApplicationLabel.mas_width);
    }];
    
    [self.currentApplicationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentView.mas_top);
        make.bottom.equalTo(self.currentView.mas_bottom);
        make.leading.equalTo(self.currentTotalAssetsLabel.mas_trailing);
        make.trailing.equalTo(self.currentView.mas_trailing).offset(-0);
    }];
}

- (void)createHidenView:(UIView *)containerView {
    self.hidenView = [[UIView alloc] init];
    self.hidenView.hidden = YES;
    //    self.hidenView.frame = CGRectMake(0, containerView.frame.size.height, containerView.frame.size.width, containerView.frame.size.height);
    self.hidenView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:self.hidenView];
    [self.hidenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_bottom).offset(20);//.offset(20)增  解决第一次看得见数据条
        make.leading.trailing.mas_equalTo(0);
        make.height.equalTo(containerView.mas_height);
    }];
    
    WDFinancialPlannerDataListModel *financialPlannerDataListModel = self.financialPlannerPagesModel.dataListArray[self.count];
    
    self.hidenPhoneLabel = [[UILabel alloc] init];
    [self.hidenPhoneLabel setText:financialPlannerDataListModel.mobile];
    [self.hidenPhoneLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.hidenPhoneLabel setTextColor:[UIColor whiteColor]];
    [self.hidenPhoneLabel setTextAlignment:NSTextAlignmentCenter];
    [self.hidenView addSubview:self.hidenPhoneLabel];
    
    self.hidenTotalAssetsLabel = [[UILabel alloc] init];
    [self.hidenTotalAssetsLabel setText:[NSString stringWithFormat:@"总资产%.2f万元", [financialPlannerDataListModel.amount doubleValue] / 10000]];
    [self.hidenTotalAssetsLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.hidenTotalAssetsLabel setTextColor:[UIColor whiteColor]];
    [self.hidenTotalAssetsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.hidenView addSubview:self.hidenTotalAssetsLabel];
    
    self.hidenApplicationLabel = [[UILabel alloc] init];
    [self.hidenApplicationLabel setText:@"正在申请理财师"];
    [self.hidenApplicationLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.hidenApplicationLabel setTextColor:[UIColor whiteColor]];
    [self.hidenApplicationLabel setTextAlignment:NSTextAlignmentCenter];
    [self.hidenView addSubview:self.hidenApplicationLabel];
    
    [self.hidenPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.hidenView.mas_leading).offset(0);
        make.top.equalTo(self.hidenView.mas_top);
        make.bottom.equalTo(self.hidenView.mas_bottom);
        make.width.equalTo(self.hidenTotalAssetsLabel.mas_width);
    }];
    
    [self.hidenTotalAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hidenView.mas_top);
        make.bottom.equalTo(self.hidenView.mas_bottom);
        make.leading.equalTo(self.hidenPhoneLabel.mas_trailing);
        make.trailing.equalTo(self.hidenApplicationLabel.mas_leading);
        make.width.equalTo(self.hidenApplicationLabel.mas_width);
    }];
    
    [self.hidenApplicationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hidenView.mas_top);
        make.bottom.equalTo(self.hidenView.mas_bottom);
        make.leading.equalTo(self.hidenTotalAssetsLabel.mas_trailing);
        make.trailing.equalTo(self.hidenView.mas_trailing).offset(-0);
    }];
}

- (void)createTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//无效?
- (void)stopTimer {
    if ([self.timer isValid] == YES) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)hideAlertView {
    [UIView animateWithDuration:0.25 animations:^{
        [self.alertView removeFromSuperview];
    }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)addAlertViewWithContent:(NSString *)content buttonTitle:(NSString *)buttonTitle buttonTag:(NSInteger)buttonTag {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.alertView = [[WDAlertView alloc] initWithFrame:window.frame];
    self.alertView.buttonTag = buttonTag;
    if ([content rangeOfString:@"提交成功"].location != NSNotFound) {
        NSArray *array = [content componentsSeparatedByString:@"~"];
        NSString *top = array[0];
        NSString *bottom = array[1];
        self.alertView.content = [NSString stringWithFormat:@"%@\n%@", top, bottom];
        NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:self.alertView.content];
        [strAtt_Temp addAttributes:@{ NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                      NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                      /* NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)*/}
                             range:NSMakeRange([top length] + 1, [bottom length])];
        [strAtt_Temp addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor blackColor],}
                             range: NSMakeRange(0, [top length])];
        UILabel *aaaa = [self.alertView valueForKey:@"contentLabel"];
        [aaaa setAttributedText:strAtt_Temp];
        
        UILabel * titleLabel = [self.alertView valueForKey:@"titleLabel"];
        [titleLabel setText:@"温馨提示"];
        
    } else {
        self.alertView.content = content;
    }
    self.alertView.confimButtonTitle = buttonTitle;
    self.alertView.delegate = self;
    [window addSubview:self.alertView];
    
    self.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)dealTimer {

    self.count++;
    if (self.count == self.financialPlannerPagesModel.dataListArray.count) {
        self.count = 0;
    }
    
    WDFinancialPlannerDataListModel *financialPlannerDataListModel = self.financialPlannerPagesModel.dataListArray[self.count];
    
    NSLog(@"当前取值对象计数 -->  %ld",(long)(long)self.count);
    NSLog(@"mobile = %@",financialPlannerDataListModel.mobile);
    NSLog(@"amount = %@",financialPlannerDataListModel.amount);
    NSLog(@"当前 flag == %ld",(long)(long)self.flag);
    
    if (self.flag == 1) {
        self.currentPhoneLabel.text = financialPlannerDataListModel.mobile;
        self.currentTotalAssetsLabel.text = [NSString stringWithFormat:@"总资产%.2f万元", [financialPlannerDataListModel.amount doubleValue] / 10000];
    }
    
    if (self.flag == 0) {
        self.hidenPhoneLabel.text = financialPlannerDataListModel.mobile;
        self.hidenTotalAssetsLabel.text = [NSString stringWithFormat:@"总资产%.2f万元", [financialPlannerDataListModel.amount doubleValue] / 10000];
    }
    
    if (self.flag == 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.hidenView.hidden = NO;
            self.currentView.hidden = YES;
            //            self.currentView.frame = CGRectMake(0, -self.currentView.frame.size.height, self.currentView.frame.size.width, self.currentView.frame.size.height);//可有可无
            self.hidenView.frame = CGRectMake(0, 0, self.hidenView.frame.size.width, self.hidenView.frame.size.height);
        }
                         completion:^(BOOL finished) {
                             self.flag = 1;
                             self.currentView.frame = CGRectMake(0, self.currentView.frame.size.height * 2, self.currentView.frame.size.width, self.currentView.frame.size.height);
                         }];
    } else {
       
        [UIView animateWithDuration:0.3 animations:^{
            self.currentView.hidden = NO;
            self.hidenView.hidden = YES;
            //            self.hidenView.frame = CGRectMake(0, -self.hidenView.frame.size.height, self.hidenView.frame.size.width, self.hidenView.frame.size.height);//可有可无
            self.currentView.frame = CGRectMake(0, 0, self.currentView.frame.size.width, self.currentView.frame.size.height);
        }
                         completion:^(BOOL finished) {
                             self.flag = 0;
                             self.hidenView.frame = CGRectMake(0, self.hidenView.frame.size.height * 2, self.hidenView.frame.size.width, self.hidenView.frame.size.height);
                         }];
    }
}

#pragma mark - HTTP
- (void)queryFinancialPlanner {
    [self showWithDataRequestStatus:@"正在加载数据..."];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    
    
    
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/myFinancialInterface", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        [self dismissWithDataRequestStatus];
//        NSLog(@"%@",responseObject);
        self.financialPlannerPagesModel = [[WDFinancialPlannerPagesModel alloc] initWithDictionary:responseObject];
        if (self.financialPlannerPagesModel.r_status == WDModelSuccess) {
            [self.myTableView reloadData];
           [self createTimer];
        } else if (self.financialPlannerPagesModel.r_status == WDModelTokenExpire) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf queryFinancialPlanner];
        } withFailureBlock:^{
            
        }];
        } else if (self.financialPlannerPagesModel.r_status == WDModelSidExpire) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf queryFinancialPlanner];
                } withFailureBlock:^{
                    
                }];
        } else {
            [self errorPrompt:2.0 promptStr:self.financialPlannerPagesModel.msg];
        }
    }
        fail:^{
            [self errorPrompt:2.0 promptStr:errorPromptString];
        }];
}

- (void)applyFinancialPlanner {
    [self showWithDataRequestStatus:@"正在申请中..."];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/applyFinancial", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        [self dismissWithDataRequestStatus];
        WDApplyFinancialPlannerModel *applyFinancialPlannerModel = [[WDApplyFinancialPlannerModel alloc] initWithDictionary:responseObject];
        if (applyFinancialPlannerModel.r_status == WDModelSuccess) {
//            NSLog(@"%@",responseObject);
            if ([responseObject[@"status"] integerValue] == 1) {
                [self addAlertViewWithContent:applyFinancialPlannerModel.msg buttonTitle:buttonTitle2 buttonTag:buttonTag3];
            } else {
                self.isApplyfor = YES;
                self.inviteFriendsButton.enabled = NO;
                [self.inviteFriendsButton setTitle:@"申请中" forState:UIControlStateNormal];
                [self addAlertViewWithContent:applyFinancialPlannerModel.msg buttonTitle:buttonTitle2 buttonTag:buttonTag2];
            }
        } else if (applyFinancialPlannerModel.r_status == WDModelTokenExpire) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf applyFinancialPlanner];
        } withFailureBlock:^{
            
        }];
        } else if (applyFinancialPlannerModel.r_status == WDModelSidExpire) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf applyFinancialPlanner];
                } withFailureBlock:^{
                    
                }];
        } else {
            [self addAlertViewWithContent:applyFinancialPlannerModel.msg buttonTitle:buttonTitle2 buttonTag:buttonTag5];
        }
    }
        fail:^{
            [self errorPrompt:2.0 promptStr:errorPromptString];
        }];
}

#pragma mark - WDAlertViewDelegate
- (void)alertView:(WDAlertView *)alertView contentButton:(UIButton *)contentButton {
    NSLog(@"contentButton=%s", __FUNCTION__);
    [self hideAlertView];
    if (alertView.buttonTag == buttonTag1) {
        [self jumpToWebview:@"http://mp.weixin.qq.com/s?__biz=MjM5ODA2NzU5Mg==&mid=405650171&idx=1&sn=1b750f5c7fd17f48b3e68d14959aa92a#rd" webViewTitle:@"理财师规则"];
    }
}

- (void)alertView:(WDAlertView *)alertView confimButton:(UIButton *)confimButton {
    NSLog(@"confimButton=%s, %@, %ld", __FUNCTION__, alertView.content, (long) alertView.buttonTag);
    [self hideAlertView];

    switch (alertView.buttonTag) {
    case buttonTag1: {
        [self applyFinancialPlanner];
    } break;
    case buttonTag2: {
        [self addAlertViewWithContent:content4 buttonTitle:buttonTitle2 buttonTag:buttonTag4];
    } break;
    case buttonTag3: {

    } break;
    case buttonTag4: {
        //不处理
    } break;
    default:
        break;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 265;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //容器视图
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 265)];
    containerView.userInteractionEnabled = YES;
    containerView.backgroundColor = AppMianColor;
//    [self setTheGradientWithView:containerView];
    //banner图片
    UIImageView *bannerImageView = [[UIImageView alloc] init];
//    [bannerImageView setImage:[UIImage imageNamed:@"financial-planner-banner"]];
//    bannerImageView.backgroundColor = [UIColor colorWithHexString:@"3145A9"];
    [containerView addSubview:bannerImageView];
    bannerImageView.userInteractionEnabled = YES;
//    self.bannerImageView = bannerImageView;
    [bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(265);
    }];
    /*
    self.animationImageView = [[UIImageView alloc] init];
    [self.animationImageView setImage:[UIImage imageNamed:@"hand-icon"]];
    [containerView addSubview:self.animationImageView];
    self.animationImageView.frame = CGRectMake((self.view.frame.size.width - 157) / 2, -100, 157, 96);
    */
    
    //第一块视图
    UIView *view2 = [[UIView alloc] init];
//    view2.backgroundColor = [UIColor colorWithRed:42 / 255.0 green:178 / 255.0 blue:235 / 255.0 alpha:1.0];
    [bannerImageView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(120);
//        make.top.equalTo(bannerImageView.mas_bottom);
    }];
    
     
    UILabel *totalEarnLabel = [[UILabel alloc] init];
    [totalEarnLabel setText:@"累计收益 (元)"];
    [totalEarnLabel setTextAlignment:NSTextAlignmentCenter];
    [totalEarnLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [totalEarnLabel sizeToFit];
    [totalEarnLabel setTextColor:[UIColor whiteColor]];
    [view2 addSubview:totalEarnLabel];
    [totalEarnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
//        make.leading.equalTo(view2.mas_leading).offset(70);
//        make.trailing.equalTo(view2.mas_trailing).offset(-70);
        make.width.mas_equalTo(150);
        make.centerX.mas_equalTo(0);
    }];

    UILabel *totalEarnCountLabel = [[UILabel alloc] init];
    [totalEarnCountLabel setText:[Number3for1 formatAmount:[NSString stringWithFormat:@"%.2f",[self.financialPlannerPagesModel.amount doubleValue]]]];
//    [totalEarnCountLabel setText:[Number3for1 formatAmount:@"12345678"]];
    [totalEarnCountLabel setTextColor:[UIColor colorWithHexString:@"F7F7F7"]];
    [totalEarnCountLabel setTextAlignment:NSTextAlignmentCenter];
    [totalEarnCountLabel setFont:[UIFont systemFontOfSize:41.0f]];
    [totalEarnCountLabel sizeToFit];
    [totalEarnCountLabel setTextColor:[UIColor whiteColor]];
//    [totalEarnCountLabel setTextColor:[UIColor colorWithRed:254 / 255.0 green:228 / 255.0 blue:129 / 255.0 alpha:1.0]];
    [view2 addSubview:totalEarnCountLabel];
    [totalEarnCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalEarnLabel.mas_bottom).offset(28);
//        make.width.mas_equalTo(0);0无位置
        make.height.mas_equalTo(33);
        make.centerX.mas_equalTo(0);
    }];
    
    //第二块视图
    UIView *view3 = [[UIView alloc] init];
//    view3.backgroundColor = [UIColor colorWithRed:29 / 255.0 green:164 / 255.0 blue:224 / 255.0 alpha:1.0];
    [bannerImageView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(129);
        make.top.equalTo(view2.mas_bottom).offset(0);
    }];

    UILabel *levelLabel = [[UILabel alloc] init];
    [levelLabel setText:@"我的级别"];
    [levelLabel setFont:[UIFont systemFontOfSize:12.f]];
    [levelLabel setTextColor:[UIColor whiteColor]];
    [levelLabel setTextAlignment:NSTextAlignmentCenter];
    [view3 addSubview:levelLabel];

    UILabel *inviteBenefitsRewardsLabel = [[UILabel alloc] init];
    [inviteBenefitsRewardsLabel setText:@"一级奖励"];
    [inviteBenefitsRewardsLabel setFont:[UIFont systemFontOfSize:12.f]];
    [inviteBenefitsRewardsLabel setTextColor:[UIColor whiteColor]];
    [inviteBenefitsRewardsLabel setTextAlignment:NSTextAlignmentCenter];
    [view3 addSubview:inviteBenefitsRewardsLabel];

    UILabel *secondDegreeContactsInviteRewardsLabel = [[UILabel alloc] init];
    [secondDegreeContactsInviteRewardsLabel setText:@"二级奖励"];
    [secondDegreeContactsInviteRewardsLabel setFont:[UIFont systemFontOfSize:12.f]];
    [secondDegreeContactsInviteRewardsLabel setTextColor:[UIColor whiteColor]];
    [secondDegreeContactsInviteRewardsLabel setTextAlignment:NSTextAlignmentCenter];
    [view3 addSubview:secondDegreeContactsInviteRewardsLabel];

    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.mas_equalTo(7);
        if (iPhone4 || iPhone5) make.leading.mas_equalTo(iPhoneWidth * 0.1239); // 0.1239
        else if (iPhone6_)      make.leading.mas_equalTo(iPhoneWidth * 0.1374); //0.1374
        else                    make.leading.mas_equalTo(iPhoneWidth * 0.1333);
    }];

    [inviteBenefitsRewardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelLabel.mas_top);
        make.width.mas_equalTo(iPhoneWidth * 0.304);
        make.leading.mas_equalTo(iPhoneWidth * 0.348);//linshi 0.437   0.436图纸
    }];

    [secondDegreeContactsInviteRewardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelLabel.mas_top);
        make.trailing.mas_equalTo(-iPhoneWidth * ((iPhone4||iPhone5)?0.1239
                                                  :iPhone6_?0.1374:0.1333));
    }];
    
    UILabel *goldFinancialPlannerLabel = [[UILabel alloc] init];
    [goldFinancialPlannerLabel setText:self.financialPlannerPagesModel.financialName];
    [goldFinancialPlannerLabel setFont:[UIFont systemFontOfSize:12.f]];
    [goldFinancialPlannerLabel setTextColor:[UIColor colorWithRed:254 / 255.0 green:228 / 255.0 blue:129 / 255.0 alpha:1.0]];
    [goldFinancialPlannerLabel setTextAlignment:NSTextAlignmentCenter];
    [goldFinancialPlannerLabel sizeToFit];
    [view3 addSubview:goldFinancialPlannerLabel];

    
    UIImageView *goldImageView = [[UIImageView alloc] init];
    NSInteger levels = [self.financialPlannerPagesModel.level integerValue];
    if (levels == 1) {
        goldImageView.image = [UIImage imageNamed:@"gold-icon"];
    }
    if (levels == 2) {
        goldImageView.image = [UIImage imageNamed:@"diamond-icon"];
    } else if (levels == 3) {
        goldImageView.image = [UIImage imageNamed:@"crown-icon"];
    }
    goldImageView.contentMode = UIViewContentModeScaleToFill;
    [view3 addSubview:goldImageView];
    

    UIView *LineViewleft = [[UIView alloc] init];
    LineViewleft.backgroundColor = [UIColor whiteColor];
    [view3 addSubview:LineViewleft];
  
    
    UIView *LineViewRight = [[UIView alloc] init];
    LineViewRight.backgroundColor = [UIColor whiteColor];
    [view3 addSubview:LineViewRight];
  
    
    UILabel *inviteBenefitsRewardsPercentLabel = [[UILabel alloc] init];
    [inviteBenefitsRewardsPercentLabel setText:[NSString stringWithFormat:@"%.2f%%", [self.financialPlannerPagesModel.firstRates doubleValue] * 100]];
    [inviteBenefitsRewardsPercentLabel setFont:[UIFont systemFontOfSize:12.f]];
    [inviteBenefitsRewardsPercentLabel setTextColor:[UIColor colorWithRed:254 / 255.0 green:228 / 255.0 blue:129 / 255.0 alpha:1.0]];
    [inviteBenefitsRewardsPercentLabel setTextAlignment:NSTextAlignmentCenter];
    [inviteBenefitsRewardsPercentLabel sizeToFit];
    [view3 addSubview:inviteBenefitsRewardsPercentLabel];

    UILabel *secondDegreeContactsInviteRewardsPercentLabel = [[UILabel alloc] init];
    [secondDegreeContactsInviteRewardsPercentLabel setText:[NSString stringWithFormat:@"%.2f%%", [self.financialPlannerPagesModel.secRates doubleValue] * 100]];
    [secondDegreeContactsInviteRewardsPercentLabel setFont:[UIFont systemFontOfSize:12.f]];
    [secondDegreeContactsInviteRewardsPercentLabel setTextColor:[UIColor colorWithRed:254 / 255.0 green:228 / 255.0 blue:129 / 255.0 alpha:1.0]];
    [secondDegreeContactsInviteRewardsPercentLabel setTextAlignment:NSTextAlignmentCenter];
    //    [secondDegreeContactsInviteRewardsPercentLabel setBackgroundColor:[UIColor redColor]];
    [secondDegreeContactsInviteRewardsPercentLabel sizeToFit];
    [view3 addSubview:secondDegreeContactsInviteRewardsPercentLabel];

    [goldFinancialPlannerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(levelLabel.mas_leading);
        make.top.equalTo(levelLabel.mas_bottom).offset(0);
        make.height.equalTo(inviteBenefitsRewardsPercentLabel.mas_height);
    }];

    
    [inviteBenefitsRewardsPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(inviteBenefitsRewardsLabel.mas_leading);
        make.top.equalTo(goldFinancialPlannerLabel.mas_top);
        make.height.equalTo(secondDegreeContactsInviteRewardsPercentLabel.mas_height);
        make.width.equalTo(inviteBenefitsRewardsLabel.mas_width);
    }];

    
    [goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.leading.equalTo(goldFinancialPlannerLabel.mas_trailing).offset(5);
//        make.trailing.equalTo(inviteBenefitsRewardsPercentLabel.mas_leading).offset(-15);
        make.centerY.equalTo(goldFinancialPlannerLabel.mas_centerY);
    }];
    
    [secondDegreeContactsInviteRewardsPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(secondDegreeContactsInviteRewardsLabel.mas_leading);
        make.top.equalTo(goldFinancialPlannerLabel.mas_top);
        make.width.equalTo(secondDegreeContactsInviteRewardsLabel.mas_width);
    }];
    
    [LineViewleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.leading.mas_equalTo(iPhoneWidth * 0.348);//linshi 0.3467
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(25);
//        make.height.equalTo(inviteBenefitsRewardsPercentLabel.mas_bottom).offset(0);
    }];
    
    [LineViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LineViewleft.mas_top);
        make.trailing.mas_equalTo(-iPhoneWidth * 0.348);//linshi 0.3467
        make.width.equalTo(LineViewleft.mas_width);
        make.height.mas_equalTo(25);
//        make.height.equalTo(LineViewleft.mas_bottom).offset(0);
    }];

    /*
    UIView *whiteLineView1 = [[UIView alloc] init];
    whiteLineView1.backgroundColor = [UIColor whiteColor];
    [view3 addSubview:whiteLineView1];
    [whiteLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goldFinancialPlannerLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
        make.leading.equalTo(goldFinancialPlannerLabel.mas_leading);
        make.trailing.equalTo(secondDegreeContactsInviteRewardsLabel.mas_trailing);
    }];
     */

    self.inviteFriendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSInteger status = [self.financialPlannerPagesModel.status integerValue];

    if (status == 2) {
        [self.inviteFriendsButton setTitle:@"立即申请成为理财师" forState:UIControlStateNormal];
    } else if (status == 1) {
        [self.inviteFriendsButton setTitle:@"立即邀请好友" forState:UIControlStateNormal];
    } else if (status == 0) {
        [self.inviteFriendsButton setTitle:@"申请中" forState:UIControlStateNormal];
    }
    [self.inviteFriendsButton.layer setMasksToBounds:YES];
    [self.inviteFriendsButton.layer setCornerRadius:5];
    [self.inviteFriendsButton setTitleColor:AppMianColor forState:UIControlStateNormal];
    [self.inviteFriendsButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.inviteFriendsButton setBackgroundColor:[UIColor whiteColor]];
    [self.inviteFriendsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:self.inviteFriendsButton];
    [self.inviteFriendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondDegreeContactsInviteRewardsPercentLabel.mas_bottom).offset(33);
//        make.leading.equalTo(view3.mas_leading).offset(40);
//        make.trailing.equalTo(view3.mas_trailing).offset(-40);
        make.width.mas_equalTo(180);//原124
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    /*
    UIView *whiteLineView2 = [[UIView alloc] init];
    whiteLineView2.backgroundColor = [UIColor whiteColor];
    [view3 addSubview:whiteLineView2];
    [whiteLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteFriendsButton.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
        make.leading.equalTo(whiteLineView1.mas_leading);
        make.trailing.equalTo(whiteLineView1.mas_trailing);
    }];
     */
     
    UIView *view4 = [[UIView alloc] init];
//    view4.backgroundColor = [UIColor colorWithRed:29 / 255.0 green:164 / 255.0 blue:224 / 255.0 alpha:1.0];
    [view3 addSubview:view4];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteFriendsButton.mas_bottom).offset(10);
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
    }];

//    [self createTimer];
    if (self.financialPlannerPagesModel.dataListArray.count > 0) {
        [self createCurrentView:view4];
        [self createHidenView:view4];
    }
    
    return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger row = indexPath.row;
//    cell.imageView.image = [UIImage imageNamed:self.imageIconArray[row]];
    cell.textLabel.text = self.titleArray[row];
//  cell.detailTextLabel.text = self.detailTitleArray[row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
    case 0: {
        [self customPushViewController:[[WDInviteUsersViewController alloc] init] customNum:0];
    } break;
    case 1: {
        [self customPushViewController:[[WDArdawRecordsViewController alloc] init] customNum:0];
    } break;
    case 2: {
        [self customPushViewController:[[WDInvestmentRecordsViewController alloc] init] customNum:0];
    } break;
//    case 3: {
//        [self jumpToWebview:FinancialPlannerRulesURL webViewTitle:@"贤钱宝理财师规则"];
//        [self errorPrompt:3.0 promptStr:@"规则正在拟定中,敬请期待!"];
//    } break;
    default:
        break;
    }
}

#pragma make - CustomUINavBarDelegate
- (void)goBack {
    [self customPopViewController:0];
}

@end
