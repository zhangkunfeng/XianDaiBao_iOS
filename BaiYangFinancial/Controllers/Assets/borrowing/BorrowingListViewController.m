//
//  BorrowingListViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BorrowingListViewController.h"
#import "BorrowingTableViewCell.h"
#import "BorrowingWaitingView.h"
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"
#import "XRPayPassWorldView.h"
#import "VerificationiPhoneCodeViewController.h"
#import "WithDrawDetailsViewController.h"
#import "SelectCalendarViewCotroller.h"
#import "ForgetPassWdViewController.h"

//连连支付
#import "LLPaySdk.h"

@interface BorrowingListViewController ()<UITableViewDelegate,UITableViewDataSource,BorrowingWaitingBottomViewDelegate,BorrowingWaitingTopViewDelegate,XRPayPassWorldViewDelegate,LLPaySdkDelegate>
{
    //连连支付返回的
    NSInteger LLPayresultCode;
    NSString *LLPayMessage;
    
    NSInteger _cellSelectedNum;
    
    //选择回传日期
    NSString *_startDateStr;
    NSString *_theEndDateStr;
}
@property (nonatomic, assign) float cellAmountMoney;
@property (nonatomic, strong)UITableView *borrowingTableViewList;
@property (nonatomic, copy) NSMutableArray *borrowinginfoArray;
@property (nonatomic, copy) NSDictionary *UserInformationDict;
@property (nonatomic, strong)NSDictionary *rechargeInfo;  //后台充值数据
@property (nonatomic, copy) NSDictionary *orderParamDict; //储存连连支付的数据
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong) UIAlertView * borrowingAlert;//
@property (nonatomic, strong) BorrowingWaitingTopView * waitingTopView;
@property (nonatomic, strong) BorrowingWaitingBottomView *waitingBottomView;
@property (strong, nonatomic) XRPayPassWorldView *payPWDView;
@property (nonatomic, strong) SelectCalendarViewCotroller * slectCalendarVC;

@property (nonatomic, retain) LLPaySdk *llPaysdk;         //连连支付的sdk

@end

@implementation BorrowingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndexNum = 1;
    _startDateStr = @"";
    _theEndDateStr = @"";
    _cellAmountMoney = 0.0f;
    _cellSelectedNum = 0;
    _borrowinginfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGFloat tableViewHeight = iPhoneHeight -
    ([self.title isEqualToString:@"待还款"]?158:108);
    self.borrowingTableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, tableViewHeight) style:UITableViewStylePlain];
    self.borrowingTableViewList.showsVerticalScrollIndicator = NO;
    self.borrowingTableViewList.tableFooterView=[[UIView alloc]init];
    self.borrowingTableViewList.scrollsToTop = NO;
    self.borrowingTableViewList.delegate = self;
    self.borrowingTableViewList.dataSource = self;
    [self.view addSubview:self.borrowingTableViewList];
    
    [self addBorrowingWatingViewTopAndBottomView];
    
    [self setupHeader];
    [self setupFooter];
}

- (void)addBorrowingWatingViewTopAndBottomView
{
    if ([self.title isEqualToString:@"待还款"]) {
        
        _waitingTopView = [[BorrowingWaitingTopView alloc] initWithBorrowingWaitingTopViewFram:CGRectMake(0, 0, iPhoneWidth, 45)];
        self.borrowingTableViewList.tableHeaderView = _waitingTopView;
        _waitingTopView.delegate = self;
        
        //view上添加才正常
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, iPhoneHeight-50-64-44, iPhoneWidth, 50)];
        [self.view addSubview:view];
        _waitingBottomView = [[BorrowingWaitingBottomView alloc] initWithBorrowingWaitingBottomViewFram:CGRectMake(0,0, iPhoneWidth, 50)];
        _waitingBottomView.delegate = self;
        [view addSubview:_waitingBottomView];
    }
}


/**  查询所以不传值
 借款记录接口  user/getBorrowList   * @param uid
 * @param page(当前页 从1开始)
 * @param pageSize(每页条数)
 * @param dateStart(开始日期)
 * @param dateEnd(结束日期)
 * @param status 还款状态 1-已还 0-未还
 返回值r=-1 没有足够权限 不显现借款记录菜单
 */
#pragma mark - 加载借款记录接口
- (void)loadBorrowingRecordData{
    NSString * statusStr = @"";
    NSDictionary *parameters = nil;
    if ([self.title isEqualToString:@"待还款"]) {
        statusStr = @"0";
    }else if ([self.title isEqualToString:@"已还款"]){
        statusStr = @"1";
    }
    parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                    @"sid": getObjectFromUserDefaults(SID),
                    @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
                    @"page": [NSString stringWithFormat:@"%zd",_pageIndexNum],
                    @"pageSize"  : @"10",
                    @"status"    : statusStr,
                    @"dateStart" : _startDateStr,
                    @"dateEnd"   : _theEndDateStr};
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getBorrowList",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadBorrowingRecordData];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self dismissWithDataRequestStatus];
                [_weakRefreshHeader endRefreshing];
                //移除错误界面
                [weakSelf hideMDErrorShowView:self];
                if (_pageIndexNum == 1 && [_borrowinginfoArray count] > 0) {
                    [_borrowinginfoArray removeAllObjects];
                }
                NSArray *array = responseObject[@"data"];
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                        [weakSelf errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",weakSelf.title]];
                    }
                }
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (id info in array) {
                        [_borrowinginfoArray addObject:info];
                    }
                }
                if ([_borrowinginfoArray count] > 0) {
                    //移除错误界面
                    [weakSelf hideMDErrorShowView:self];
                    [weakSelf.borrowingTableViewList reloadData];
                }else{
                    [weakSelf.borrowingTableViewList reloadData];
                    [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0,45, iPhoneWidth, iPhoneHeight - 108 - 45) contentShowString:@"暂无数据" MDErrorShowViewType:againRequestData];
                }
            }else{
                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                [_weakRefreshHeader endRefreshing];
            }
        }
    } fail:^{
        [self dismissWithDataRequestStatus];
        [_weakRefreshHeader endRefreshing];
        [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108)];
    }];
}

- (void)viewDidCurrentView
{
    if ([_borrowinginfoArray count] == 0) {
        [_weakRefreshHeader beginRefreshing];
    }else{
        [self.borrowingTableViewList setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - MDErrorShowViewDelegate
- (void)againLoadingData{
    //移除错误界面
    [self hideMDErrorShowView:self];
    [self performSelector:@selector(viewDidCurrentView) withObject:nil afterDelay:0.3f];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _borrowinginfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorrowingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[BorrowingTableViewCell initWithBorrowingTableViewCellID]];
    if (cell == nil) {
        cell = [BorrowingTableViewCell initWithBorrowingTableViewCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    
    NSDictionary *accinfoDict = nil;
    if ([_borrowinginfoArray count] > 0) {
        accinfoDict = [_borrowinginfoArray objectAtIndex:indexPath.row];
    }
    
    /**
     {
     repayAmount = 20200;
     repayCapital = 20000;
     repayInterest = 200;
     repayTime = 13;
     title = "cs 01";
     userName = "\U8d75\U745c";
     }
     */
    
    if (_waitingBottomView.bottomSelectBtn.selected) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    
    
   
    
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
     cell.moneyLabel.text = [NSString stringWithFormat:@"%@元",
         [self isLegalObject:accinfoDict[@"repayAmount"]]?
         [Number3for1 formatAmount:accinfoDict[@"repayAmount"]]:@""];
    
     cell.titleLabel.text = [NSString stringWithFormat:@"%@",
         [self isLegalObject:accinfoDict[@"title"]]?accinfoDict[@"title"]:@""];
    
     cell.nameLabel.text = [NSString stringWithFormat:@"%@",
         [self isLegalObject:accinfoDict[@"userName"]]?accinfoDict[@"userName"]:@""];
    
     NSString * repayTimeStr = [self isLegalObject:accinfoDict[@"repayTime"]]?
                              accinfoDict[@"repayTime"]:@"";
     cell.remainingTimeLabel.text = [self.title isEqualToString:@"待还款"]
                    ?[NSString stringWithFormat:@"剩余%@天",repayTimeStr]
                    :[NSString stringWithFormat:@"%@",repayTimeStr];
                                    
     if ([self.title isEqualToString:@"已还款"]) {
        [cell setAlreadyMoneyCellConstans];
     }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BorrowingTableViewCell initWithBorrowingTableViewCellHeight];
}

- (void)selectBtnClick:(UIButton *)btn
{
    _cellAmountMoney = [[Number3for1 forDelegateChar:_waitingBottomView.bottomAmountMoneyLabel.text] floatValue];
    btn.selected = !btn.selected;
    //首先获得Cell：button的父视图是contentView，再上一层才是UITableViewCell
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    //然后使用indexPathForCell方法，就得到indexPath了~
    NSIndexPath *indexPath = [_borrowingTableViewList indexPathForCell:cell];
    
    NSDictionary * accinfoDict = [_borrowinginfoArray objectAtIndex:indexPath.row];
    if (btn.selected) {
        _cellSelectedNum += 1;
        _cellAmountMoney += [accinfoDict[@"repayAmount"] floatValue];
        _waitingBottomView.bottomSelectBtn.selected =_cellSelectedNum==_borrowinginfoArray.count?YES:NO;
    }else{
        _cellSelectedNum -= 1;
        _cellAmountMoney -= [accinfoDict[@"repayAmount"] floatValue];
        _waitingBottomView.bottomSelectBtn.selected = NO;
    }
    NSLog(@"%.2f",_cellAmountMoney);
    
    _waitingBottomView.bottomAmountMoneyLabel.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.2f",_cellAmountMoney]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -----  上下拉加载  ------
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.borrowingTableViewList];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            _cellSelectedNum = 0;
            _cellAmountMoney = 0.0f;
            _waitingBottomView.bottomSelectBtn.selected = NO;
            [self loadBorrowingRecordData];
            _waitingBottomView.bottomAmountMoneyLabel.text = [NSString stringWithFormat:@"%.2f",_cellAmountMoney];
        });
    };
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.borrowingTableViewList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadBorrowingRecordData];
        [self.refreshFooter endRefreshing];
        
    });
}

#pragma mark -BorrowingWaitingTopViewDelegate 选择日期
- (void)selectDateStartBtnDelegateAction:(UIButton *)btn
{
    [self gotoSelectCalendarViewCotroller:btn title:@"请选择起始日期"];
}
- (void)selectDateEndBtnDelegateAction:(UIButton *)btn
{
    [self gotoSelectCalendarViewCotroller:btn title:@"请选择截止日期"];
}

- (void)gotoSelectCalendarViewCotroller:(UIButton *)selectDateBtn title:(NSString *)title
{
    WS(weakSelf);
    if (!_slectCalendarVC) { //不能这么写，不用创建不会重置
        _slectCalendarVC= [[SelectCalendarViewCotroller alloc] init];
    }
    [_slectCalendarVC setCalendarInit];//初始化日历 采用下面重置
     [_slectCalendarVC setupDetailPageNavigationViewTitleStr:title];
     _slectCalendarVC.selectCalendarVCBlock = ^(NSInteger day, NSInteger month, NSInteger year) {
        NSString * btnDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
         if (selectDateBtn.tag == 1000) {
             _startDateStr = [NSString stringWithString:btnDateStr];
         }else{
             _theEndDateStr = [NSString stringWithString:btnDateStr];
             [weakSelf loadBorrowingRecordData];

         }
        [selectDateBtn setTitle:btnDateStr forState:UIControlStateNormal];
    };
    [self customPushViewController:_slectCalendarVC customNum:0];
}

#pragma mark -BorrowingWaitingBottomViewDelegate 立即还款
- (void)bottomSeclectBtnActionDelegate:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    float cellAmountMoneySum = 0.0f;
    for (NSDictionary *dic in _borrowinginfoArray) {
        if (btn.selected) {
            _cellSelectedNum = _borrowinginfoArray.count;
            cellAmountMoneySum += [dic[@"repayAmount"] floatValue];
        }else{
            _cellSelectedNum = 0;
            cellAmountMoneySum = 0.0f;
        }
    }
    _waitingBottomView.bottomAmountMoneyLabel.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.2f",cellAmountMoneySum]];
    
    [_borrowingTableViewList reloadData];
}

- (void)immediatementBtnActionDelegate:(NSString *)amountMoneyStr{
    //本页面值 _cellAmountMoney 不准确  代理值准确 不过得处理,  代理值暂且不用
    [self loadJudgeTradingPasswordAndCardData];
}


#pragma mark - 判断设置交易密码以及绑卡方法
- (void)loadJudgeTradingPasswordAndCardData{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
#if 1
                //是否设置交易密码
                if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDict[@"pay"] integerValue] == 1) {
                    //是否绑卡
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        _borrowingAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"还款需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_borrowingAlert show];
                    } else {
                        
                    //充值流程  输入支付密码
                    if ([[Number3for1 forDelegateChar:_waitingBottomView.bottomAmountMoneyLabel.text]  doubleValue] < 0.01) {
                            [self errorPrompt:3.0 promptStr:@"请勾选至少一项还款金额"];
                            return;
                    }
                    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPWDView];
                    }

                }else{
                    [self setPaymentPassWordController];
                }
#elif 0   //test
                
                //充值流程  输入支付密码
                if ([[Number3for1 forDelegateChar:_waitingBottomView.bottomAmountMoneyLabel.text]  doubleValue] < 0.01) {
                    [self errorPrompt:3.0 promptStr:@"请勾选至少一项还款金额"];
                    return;
                }
                [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPWDView];
                
#endif
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }

    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

//设置支付密码页面
- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            //            _isHavePayPassworld = YES;
        }
    };
    [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [self customPushViewController:setPaymentPassWorldView customNum:1];
}

#pragma mark - payPassworldViewDelegate
- (void)sureTappend{
    [self getEncryptionString];
}

- (void)cancelTappend{
    [self dismissPopupController];
}

- (void)forgetPassWorldTappend{
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);
    [self customPushViewController:VerificationCode customNum:0];
    
}
//获取交易密码加密字  秘钥
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    [weakSelf getEncryptionString];
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                /*添加提示信息<-->在gotoPlay页面隐藏*/
                [KVNProgress showWithStatus:@"充值中..."];
                [weakSelf gotoPay];
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}
/**  立即还款 接口
 *   bank/lianlianWithhold   参数和连连充值参数一致
 *   参数uid sid  name  card_no  id_no  money appType bankId  pwd  与富有参数一致
 */
#pragma mark - 立即还款 接口
- (void)gotoPay{
    NSString * rechargePriceBorrowing = [Number3for1 forDelegateChar:_waitingBottomView.bottomAmountMoneyLabel.text];
    NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                 @"sid":   getObjectFromUserDefaults(SID),
                                 @"at" :   getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"name"   : _UserInformationDict[@"userName"],
                                 @"id_no"  : _UserInformationDict[@"idNumber"],
                                 @"card_no": _UserInformationDict[@"account"],
                                 @"bankId" : _UserInformationDict[@"bankId"],
                                 @"money"  : rechargePriceBorrowing,
                                 @"appType": @"101",
                                 @"pwd":  [NetManager TripleDES:self.payPWDView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 /*似乎没用，留着吧*/
                                 @"sms_code":  @"" };
    
    NSLog(@"parameters = %@",parameters);
    
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bank/lianlianWithhold",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        WS(weakSelf);
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self cancelTappend];/*移除支付视图<-->*/
                [KVNProgress dismiss];/*隐藏提示视图<-->*/
                
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _rechargeInfo = [responseObject[@"item"] copy];
                    [self loadLianlianPayRechargePage]; /**连连方案*/
                }
                
            }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTappend];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf sureTappend];
                } withFailureBlock:^{
                    
                }];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}
#pragma mark - 连连支付接入方案
- (void)loadLianlianPayRechargePage
{
    _orderParamDict = @{};
    if (_rechargeInfo == nil) {
        return;
    } else if ([self isBlankString:_rechargeInfo[@"no_order"]]) {
        [self errorPrompt:3.0 promptStr:@"订单号为空"];
    } else if ([self isBlankString:_rechargeInfo[@"dt_order"]]) {
        [self errorPrompt:3.0 promptStr:@"商户订单时间为空"];
    } else if ([self isBlankString:_rechargeInfo[@"money_order"]]) {
        [self errorPrompt:3.0 promptStr:@"大侠你要充值多少钱呀"];
    } else if ([self isBlankString:_rechargeInfo[@"busi_partner"]]) {
        [self errorPrompt:3.0 promptStr:@"业务类型为空"];
    } else if ([self isBlankString:_rechargeInfo[@"sign_type"]]) {
        [self errorPrompt:3.0 promptStr:@"没有加密方式"];
    } else if ([self isBlankString:_rechargeInfo[@"sign"]]) {
        [self errorPrompt:3.0 promptStr:@"加密字符串"];
    } else if ([self isBlankString:_rechargeInfo[@"user_id"]]) {
        [self errorPrompt:3.0 promptStr:@"用户id用空"];
    } else if ([self isBlankString:_rechargeInfo[@"oid_partner"]]) {
        [self errorPrompt:3.0 promptStr:@"商户号为空"];
    } else if ([self isBlankString:_rechargeInfo[@"valid_order"]]) {
        [self errorPrompt:3.0 promptStr:@"过期时间为空"];
    } else if ([self isBlankString:_rechargeInfo[@"acct_name"]]) {
        [self errorPrompt:3.0 promptStr:@"姓名为空"];
    } else if ([self isBlankString:_rechargeInfo[@"id_no"]]) {
        [self errorPrompt:3.0 promptStr:@"身份证号码为空"];
    } else if ([self isBlankString:_rechargeInfo[@"card_no"]]) {
        [self errorPrompt:3.0 promptStr:@"银行卡号为空"];
    } else {
        _orderParamDict = @{ @"acct_name"   : _rechargeInfo[@"acct_name"], //self.nameField.text
                             @"busi_partner": _rechargeInfo[@"busi_partner"],
                             @"card_no"     : _rechargeInfo[@"card_no"], //self.BankCardField.text
                             @"dt_order"    : _rechargeInfo[@"dt_order"],
                             @"id_no"       : _rechargeInfo[@"id_no"], //self.CardidField.text
                             @"money_order" : _rechargeInfo[@"money_order"],
                             @"no_order"    : _rechargeInfo[@"no_order"],
                             @"notify_url"  : _rechargeInfo[@"notify_url"],
                             @"oid_partner" : _rechargeInfo[@"oid_partner"],
                             @"risk_item"   : _rechargeInfo[@"risk_item"],
                             @"sign_type"   : _rechargeInfo[@"sign_type"],
                             @"sign"        : _rechargeInfo[@"sign"],
                             @"user_id"     : _rechargeInfo[@"user_id"],
                             @"valid_order" : _rechargeInfo[@"valid_order"],
                             @"info_order"  : _rechargeInfo[@"info_order"],
                             @"name_goods"  : _rechargeInfo[@"name_goods"]};
        NSLog(@"%@", _orderParamDict);
        [self payWithSignedOrder:_orderParamDict];
    }
}

- (void)payWithSignedOrder:(NSDictionary *)signedOrder {
    
    self.llPaysdk = [[LLPaySdk alloc] init];
    //    self.llPaysdk.sdkDelegate = self; //开发提示 没有设置代理
    [LLPaySdk sharedSdk].sdkDelegate = self;//遵从代理
    //适配连连支付跳转充值页面显示页面留白不全屏
    self.view.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneHeight);
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:LLPayTypeVerify
                                            andTraderInfo:signedOrder];
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            NSString *result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                //                NSString *payBackAgreeNo = dic[@"agreementno"];
                //                _agreeNumField.text = payBackAgreeNo;
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = @"支付单处理中";
            } else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = @"支付单失败";
            } else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = @"支付单已退款";
            }
        } break;
        case kLLPayResultFail: {
            msg = @"支付失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"支付取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    //连连支付返回，充值状态存到数据库
    LLPayresultCode = resultCode;
    LLPayMessage = msg;
    [self saveRechargeToData];
    //支付成功之后做一些处理
    if ([msg isEqualToString:@"支付成功"]) {
        
        WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
        WithDrawDetailsView.payMonryString =[Number3for1 forDelegateChar:_waitingBottomView.bottomAmountMoneyLabel.text];
        WithDrawDetailsView.titleString = @"还款";
        WithDrawDetailsView.pushNumber = 5;
        WithDrawDetailsView.userInfodict = [_UserInformationDict copy];
        [self customPushViewController:WithDrawDetailsView customNum:0];
        
    } else {
        
        [self errorPrompt:3.0 promptStr:msg];
    }
}


/*
 Printing description of parameter:{
 at = M41c41c4881c309dedfb4c86a51f5ad8f;
 code = 2;
 message = "\U652f\U4ed8\U53d6\U6d88";
 orderid = 022017032822493904220705407;
 sid = 5b3af4b74a19cefd2e412487661aa13d;
 "source_end" = IOS;
 uid = 169354;
 }
 */
#pragma mark - 充值状态存到数据库
- (void)saveRechargeToData {
    WS(weakSelf);
    NSDictionary *parameter = @{ @"code": [NSString stringWithFormat:@"%zd", LLPayresultCode],
                                 @"appType": @"101",
                                 @"orderid": _rechargeInfo[@"no_order"],
                                 @"uid": getObjectFromUserDefaults(UID),
                                 @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"sid": getObjectFromUserDefaults(SID),
                                 @"message": LLPayMessage };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/phoneRechargeCallback", GeneralWebsite] parameters:parameter success:^(id responseObject) {
        if (responseObject[@"r"]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf saveRechargeToData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf saveRechargeToData];
                } withFailureBlock:^{
                    
                }];
            }
        }
    }
                              fail:^{
                                  
                              }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _borrowingAlert && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}
#pragma mark - setters && getters
- (XRPayPassWorldView *)payPWDView{
    if (!_payPWDView) {
        _payPWDView = [[XRPayPassWorldView alloc] init];
        _payPWDView.delegate = self;
    }
    [_payPWDView.textField becomeFirstResponder];
    return _payPWDView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
