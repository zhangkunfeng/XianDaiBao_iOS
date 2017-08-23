//
//  MyAssetsBottomView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/11/27.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AssetDetailsViewController.h"
#import "AutoBidViewController.h"
#import "BaseViewController.h"
#import "BindingBankCardViewController.h"
#import "DebtTransferViewController.h"
#import "BidViewController.h"
#import "MyAssetsBottomView.h"
#import "MyBankCardViewController.h"
#import "RecentlyBidViewController.h"
#import "RechargeMyAssetsViewController.h"
#import "RechargeRecordViewController.h"
#import "SettingViewController.h"
#import "UniversalWebViewController.h"
#import "WithdrawViewController.h"
#import "assetsBackGroundButton.h"
#import "RedenvelopeViewController.h"
#import "SignInNewViewController.h"
#import "setPaymentPassWorldViewController.h"
//#import "MyInviteHongBaoViewController.h"
#import "WDFinancialPlannerViewController.h"
#import "myUILabel.h"
#import "ChangeViewController.h"
#import "PaySelectedView.h"
#import "CreditRechargeViewController.h"//融支付
#import "DiscoverControllerOne.h"
#import "BYInviteEnvelopeViewController.h"

typedef NS_ENUM(NSInteger, ButtonJumpType) {
    RecentlyState = 0,//充值 已注
    WithdrawState,    //提现 已注
    ChangeMoneyState, //零钱包
    AutoBidState,     //自动投标
    yaoqing,
};

@interface MyAssetsBottomView () <UIAlertViewDelegate>
{
    NSTimer * _timer;
    UIAlertView * changeMoneyAlert; //零钱包
    UIAlertView * autoBidAlert;     //自动投标
    BaseViewController *_viewController;
    UIAlertView * certificationAlert;
    
}
@property (weak, nonatomic) IBOutlet UIView *zongzicnView;
@property (weak, nonatomic) IBOutlet UIView *dingqiView;
@property (weak, nonatomic) IBOutlet UIView *daishouView;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *assetsMoneyEyeBtn;//资产总额显示&不显示
@property (weak, nonatomic) IBOutlet UILabel *accountMoneyLable;         //我的资产总额
@property (weak, nonatomic) IBOutlet UILabel *usableAssetsLable;         //可用资产总额
@property (weak, nonatomic) IBOutlet UILabel *TotalInterestLable;        //累计赚取出总额
@property (weak, nonatomic) IBOutlet UIView *autoBidBackgroundView;      //自动投标背景图
@property (weak, nonatomic) IBOutlet UILabel *autoNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *autoexplainLable;
@property (weak, nonatomic) IBOutlet UILabel *chanGen;

@property (weak, nonatomic) IBOutlet UILabel *dingQiLab;

//iPhone 6 Plus autoLayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstant;//171
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myAssetsMoneyDescriptionLabelTopConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *assetsMoneyLabelTopConstant;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoBidViewHeightConstant;  //45

//隐藏数字适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *assetsAmontToBottom;//11
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *assetsAmontToTop;   //11

//autoBidViewAutoLayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoBidImageViewLeading;//22
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeImageViewLeading; //25

//自动投标|零钱计划|资金明细|我的红包
@property (weak, nonatomic) IBOutlet UIView *autoBidViewAddGesture;
@property (weak, nonatomic) IBOutlet UIView *changeViewAddGesture;
@property (weak, nonatomic) IBOutlet UIView *financialPlannerViewAddGestrue;//改资金明细
@property (weak, nonatomic) IBOutlet UIView *redEnvelopeAddGesture;
@property (weak, nonatomic) IBOutlet UILabel *redCountLabel;


//投资记录|待收明细
@property (weak, nonatomic) IBOutlet UIView *investRecordAddGesture;
@property (weak, nonatomic) IBOutlet UIView *waitingRecordAddGesture;

//更改掉了
@property (weak, nonatomic) IBOutlet UIView *moneyRecordAddGesture;
@property (weak, nonatomic) IBOutlet UIView *transferRecordAddGesture;

@property (nonatomic, copy) NSDictionary *accinfoDict;          //资产数据
@property (nonatomic, copy) NSDictionary *UserInformationDict;  //用户信息字典
@property (nonatomic, assign) BOOL isHavePayPassworld;          //是否有交易密码
@property (nonatomic, strong) AssetDetailsViewController *myAssetDetailView;

@end

@implementation MyAssetsBottomView

- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController theDelegate:(id<MyAssetsButtonViewDelegate>)theDelegate {
    if (![super init]) {
        return nil;
    }
    
    //[NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"waitTotalMouth"] doubleValue]]
    self = [[[NSBundle mainBundle] loadNibNamed:@"MyAssetsBottomView" owner:self options:nil] firstObject];
    self.frame = viewFram;
    _viewController = (BaseViewController *) viewController;
    delegate = theDelegate;
    
    //autoBidViewAutoLayout
    self.autoBidImageViewLeading.constant = (iPhone4||iPhone5)?10:14/*iPhoneWidth * 0.0667*/;
    self.changeImageViewLeading.constant = (iPhone4||iPhone5)?15:iPhoneWidth * 0.08;
    
//    [_viewController setTheGradientWithView:self.topView];
    //代收
    [self addTapGestureSEL:@selector(lookDaishouButtonAction:) view:self.daishouView];

    //定期
    [self addTapGestureSEL:@selector(lookQiqingButtonAction:) view:self.dingqiView];

    //添加手势  去查看自己的资产明细
    [self addTapGestureSEL:@selector(lookDetailsButtonAction:) view:self.zongzicnView];
    
    //自动投标单击手势
    [self addTapGestureSEL:@selector(gotoAutoBidViewController:) view:self.autoBidViewAddGesture];
    //零钱单击手势  改我的红包
     [self addTapGestureSEL:@selector(gotoRedEnvelopeViewController:) view:self.changeViewAddGesture];
    
    //改资金明细  原理财师单击手势
    [self addTapGestureSEL:@selector(gotoMoneyRecordViewController:) view:self.financialPlannerViewAddGestrue];
    //我的红包单击手势 改待收明细
    [self addTapGestureSEL:@selector(gotoWaitingRecordViewController:) view:self.redEnvelopeAddGesture];
    
    //投资记录单击手势
    [self addTapGestureSEL:@selector(gotoInvestRecordViewController:) view:self.investRecordAddGesture];
    
    [self InitializationData];//初始化数据 避闪改数据
    [self settingAssetsMoneyEyeBtn];
    
    return self;
}

- (void)InitializationData{
    if ([getObjectFromUserDefaults(SHOWASSETSMONEY) isEqualToString:@"YES"]) {
        self.assetsMoneyEyeBtn.selected = YES;
        self.accountMoneyLable.text  = @"****";
        self.usableAssetsLable.text  = @"****";
        self.TotalInterestLable.text = @"****";
        self.dingQiLab.text = @"****";
        self.chanGen.text = @"****";
        self.assetsAmontToTop.constant = 19;
        self.assetsAmontToBottom.constant = 8;
    }
}

- (void)settingAssetsMoneyEyeBtn
{
    [self.assetsMoneyEyeBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateNormal];
    [self.assetsMoneyEyeBtn setImage:[UIImage imageNamed:@"睁眼"] forState: UIControlStateHighlighted];
    [self.assetsMoneyEyeBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
    [self.assetsMoneyEyeBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [self.assetsMoneyEyeBtn addTarget:self action:@selector(assetsMoneyEyeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)assetsMoneyEyeBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;

    if (btn.selected) {
        [_timer invalidate]; _timer = nil;
        self.accountMoneyLable.text  = @"****";
        self.usableAssetsLable.text  = @"****";
        self.TotalInterestLable.text = @"****";
        self.dingQiLab.text = @"****";
        self.chanGen.text = @"****";
        self.assetsAmontToTop.constant = 19;
        self.assetsAmontToBottom.constant = 8;
        getObjectFromUserDefaults(SHOWASSETSMONEY) ? removeObjectFromUserDefaults(SHOWASSETSMONEY) : @"";
        saveObjectToUserDefaults(@"YES",SHOWASSETSMONEY);
    }else{
        self.accountMoneyLable.text = [Number3for1 formatAmount:_accinfoDict[@"amount"]];
        
        self.usableAssetsLable.text = [Number3for1 formatAmount:_accinfoDict[@"balance"]];

        self.TotalInterestLable.text = [Number3for1 formatAmount:_accinfoDict[@"totalEarning"]];
        self.dingQiLab.text = [Number3for1 formatAmount:_accinfoDict[@"waitTotal"]];
        self.chanGen.text = [Number3for1 formatAmount:_accinfoDict[@"waitTotalMouth"]];
        //waitTotal = 0;定期
        //零钱包 personAmount = 0; 
        self.assetsAmontToTop.constant = 11;
        self.assetsAmontToBottom.constant = 16;
        getObjectFromUserDefaults(SHOWASSETSMONEY) ? removeObjectFromUserDefaults(SHOWASSETSMONEY) : @"";
        saveObjectToUserDefaults(@"NO",SHOWASSETSMONEY);
    }
}

- (void)addTapGestureSEL:(SEL)selector view:(UIView *)addGestureview
{
    UITapGestureRecognizer *autoBidGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [addGestureview addGestureRecognizer:autoBidGesture];
}

#pragma mark - 判断设置交易密码
- (void)loadSettingData:(ButtonJumpType)type  {
    [_viewController showWithDataRequestStatus:@"加载中..."];
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadSettingData:type];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadSettingData:type];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                NSDictionary * dic = [responseObject[@"item"] copy];
                if (dic != nil) {
                    if (![dic[@"pay"] isKindOfClass:[NSNull class]] && [dic[@"pay"] integerValue] == 1) {
//                        _isHavePayPassworld = YES;
                        [self getMyBankCardinformation:type];
                        
                    }else{
                         [_viewController dismissWithDataRequestStatus];
                         [self setPaymentPassWordController];
                    }
                }
            }
        } else {
            [_viewController errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
      fail:^{
          [_viewController showErrorViewinMain];
      }];
}

- (void)getMyBankCardinformation:(ButtonJumpType)JumpType {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
    };
    //加载框
    WS(weakSelf);
//    [_viewController showWithDataRequestStatus:@"加载中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf getMyBankCardinformation:JumpType];
        } withFailureBlock:^{
            
        }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf getMyBankCardinformation:JumpType];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [_viewController dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isKindOfClass:[NSNull class]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
              if (JumpType == ChangeMoneyState) {
                    //零钱包
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        changeMoneyAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"零钱计划需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [changeMoneyAlert show];
                    } else {
                        ChangeViewController * changeVC = [[ChangeViewController alloc] initWithNibName:@"ChangeViewController" bundle:nil];
                        [_viewController customPushViewController:changeVC customNum:0];
                    }
              }else if (JumpType == AutoBidState){
                  //自动投标
                  if ([_UserInformationDict[@"status"] integerValue] == 2) {
                      autoBidAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"自动投标需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                      [autoBidAlert show];
                  } else {
                      
                      AutoBidViewController *AutobidView = [[AutoBidViewController alloc] init];
                      AutobidView.backAssetsView = ^(NSDictionary *autoSettingDict) {
                          if ([autoSettingDict[@"enabled"] integerValue] == 0) { //自动投标关闭
                              self.autoNumberLable.text = @"无忧理财!";
                              self.autoexplainLable.text = @"(未开启)";
                          } else {
                              self.autoNumberLable.text = @"无忧理财!";
                              self.autoexplainLable.text = @"(已开启)";
                          }
                      };
                      [_viewController customPushViewController:AutobidView customNum:0];
                  }
              }else if (JumpType == yaoqing){
                  if ([_UserInformationDict[@"status"] integerValue] == 2) {
                      certificationAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"邀请好友需要实名认证，请认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                      [certificationAlert show];
                  } else{
                      BYInviteEnvelopeViewController * invite = [[BYInviteEnvelopeViewController alloc] init];
                      [_viewController customPushViewController:invite customNum:0];
                      
                      
                  }

              
              }
                
                /*branchState 为0的话  可以修改支行信息  为1 不可修改支行信息
                 *state 为1锁住银行信息  为2已审核可以更改   为3 提现审核中不可修改
                 *status 1有卡 2无卡  3替换
                 *realStatus 0 身份信息通过  1不通过  2审核中
                 */
            }
        } else {
            [_viewController errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
        fail:^{
            [_viewController showErrorViewinMain];
        }];
}
//设置支付密码页面
- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            _isHavePayPassworld = YES;
        }
    };
    [_viewController errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [_viewController customPushViewController:setPaymentPassWorldView customNum:1];
}

#pragma mark - 功能区域单击手势方法
//查看资产明细
- (void)lookDetailsButtonAction:(id)sender {
    if (_accinfoDict != nil) {
        if (!_myAssetDetailView) {
            _myAssetDetailView = [[AssetDetailsViewController alloc] initWithNibName:@"AssetDetailsViewController" bundle:nil];
        }
        _myAssetDetailView.accinfoDict = [_accinfoDict copy];
        [_viewController customPushViewController:_myAssetDetailView customNum:0];
    }
}
- (void)lookQiqingButtonAction:(id)sender {
    DiscoverControllerOne *isDingVC = [[DiscoverControllerOne alloc]init];
    [_viewController customPushViewController:isDingVC customNum:0];

    

}
- (void)lookDaishouButtonAction:(id)sender {
    RecentlyBidViewController *RecentlyBidVc = [[RecentlyBidViewController alloc] init];
    [_viewController customPushViewController:RecentlyBidVc customNum:0];

    

}

//查看自动投标详情
- (void)gotoAutoBidViewController:(id)sender {

    
    [self loadSettingData:AutoBidState];
}

//零钱
- (void)gotoChangePageViewController:(UITapGestureRecognizer *)tap{
    [self loadSettingData:ChangeMoneyState];//判断交易密码是否设置
}

//白杨理财师
- (void)gotoFinancialPlannerViewController:(UIGestureRecognizer *)gesture {
    WDFinancialPlannerViewController * WDFinancialPlannerView = [[WDFinancialPlannerViewController alloc] init];
    [_viewController customPushViewController: WDFinancialPlannerView customNum:0];
}
//我的红包
- (void)gotoRedEnvelopeViewController:(UIGestureRecognizer *)gesture {
    RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] init];
    [_viewController customPushViewController:myRedenvelopeView customNum:0];
}

//投资记录
- (void)gotoInvestRecordViewController:(UIGestureRecognizer *)gesture {
    BidViewController *MDInvestRecordView = [[BidViewController alloc] init];
    [_viewController customPushViewController:MDInvestRecordView customNum:0];
}
//待收明细
- (void)gotoWaitingRecordViewController:(UIGestureRecognizer *)gesture {
    RecentlyBidViewController *RecentlyBidVc = [[RecentlyBidViewController alloc] init];
    [_viewController customPushViewController:RecentlyBidVc customNum:0];
}


//定期



//新版我的定期
- (IBAction)myDingqiAction:(UITapGestureRecognizer *)sender {
    DiscoverControllerOne *isDingVC = [[DiscoverControllerOne alloc]init];
    [_viewController customPushViewController:isDingVC customNum:0];

}
//新版我的红包
- (IBAction)myRedBaoAction:(UITapGestureRecognizer *)sender {
    RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] init];
    [_viewController customPushViewController:myRedenvelopeView customNum:0];
}
//新版我的交易记录
- (IBAction)myJiaoyiAction:(UITapGestureRecognizer *)sender {
    RechargeRecordViewController *RechargeRecordView = [[RechargeRecordViewController alloc] init];
    [_viewController customPushViewController:RechargeRecordView customNum:0];

    
}
//新版邀请有好礼
- (IBAction)yaoQingAction:(UITapGestureRecognizer *)sender {
    [self loadSettingData:yaoqing];

   //    BYInviteEnvelopeViewController * invite = [[BYInviteEnvelopeViewController alloc] init];
//    [_viewController customPushViewController:invite customNum:0];
}
//#pragma mark - UIAlertView代理
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//        if (buttonIndex != 0 && alertView == certificationAlert){
//        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
//        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
//        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
//            
//        };
//        BindingBankCardView.UserInformationDict = [_accinfoDict copy];
//        [_viewController customPushViewController:BindingBankCardView customNum:0];
//    }
//    
//}

//资金明细
- (void)gotoMoneyRecordViewController:(UIGestureRecognizer *)gesture {
    RechargeRecordViewController *RechargeRecordView = [[RechargeRecordViewController alloc] init];
    [_viewController customPushViewController:RechargeRecordView customNum:0];
}
//债权转让
- (void)gotoTransferRecordViewController:(UIGestureRecognizer *)gesture {
    DebtTransferViewController *DebtTransferView = [[DebtTransferViewController alloc] init];
    [_viewController customPushViewController:DebtTransferView customNum:0];
}

#pragma mark - initializesetView
- (void)initializeView {
    self.accountMoneyLable.text = @"0.00";
    self.usableAssetsLable.text = @"0.00";
    self.TotalInterestLable.text = @"0.00";
    self.dingQiLab.text = @"0.0";
    self.chanGen.text = @"0.0";
    self.autoNumberLable.text = @"";
    self.autoexplainLable.text = @"";
}

#pragma mark - AssignmentView
- (void)setMDAssetsView:(NSDictionary *)accountInfoDict {
    _accinfoDict = [accountInfoDict copy];
    //总资产明细
    if ([getObjectFromUserDefaults(SHOWASSETSMONEY) isEqualToString:@"YES"]) {
        self.assetsMoneyEyeBtn.selected = YES;
        self.accountMoneyLable.text = @"****";
        self.usableAssetsLable.text  = @"****";
        self.TotalInterestLable.text = @"****";
        self.dingQiLab.text = @"****";
        self.chanGen.text = @"****";
    }else{
        if ([_viewController isLegalObject:accountInfoDict[@"amount"]]){
            if([accountInfoDict[@"amount"] doubleValue] > 0) {
                [self setTotalMoneyAmount:[accountInfoDict[@"amount"] doubleValue]];
                //白杨超越用户
//                [self CompareAssetsRanking:[accountInfoDict[@"amount"] doubleValue]];
            }else{
                self.accountMoneyLable.text = [Number3for1 formatAmount:_accinfoDict[@"amount"]];
            }
        }
        
        if ([_viewController isLegalObject:accountInfoDict[@"balance"]]) {
            //        self.usableAssetsLable.text = [NSString stringWithFormat:@"%.2f", [accountInfoDict[@"balance"] doubleValue]];
            self.usableAssetsLable.text = [Number3for1 formatAmount:accountInfoDict[@"balance"]];
        } else {
            self.usableAssetsLable.text = @"0.00";
        }
        
        if ([_viewController isLegalObject:accountInfoDict[@"totalEarning"]]) {
            //        self.TotalInterestLable.text = [NSString stringWithFormat:@"%.2f", [accountInfoDict[@"totalEarning"] doubleValue]];
            self.TotalInterestLable.text = [Number3for1 formatAmount:accountInfoDict[@"totalEarning"]];
        } else {
            self.TotalInterestLable.text = @"0.00";
        }
        if ([_viewController isLegalObject:accountInfoDict[@"waitTotal"]]){
//            if([accountInfoDict[@"waitTotal"] doubleValue] > 0) {
//                [self setTotalMoneyAmount:[accountInfoDict[@"waitTotal"] doubleValue]];
                //白杨超越用户
                //                [self CompareAssetsRanking:[accountInfoDict[@"amount"] doubleValue]];
            self.dingQiLab.text = [Number3for1 formatAmount:accountInfoDict[@"waitTotal"]];
            }else{
                self.dingQiLab.text = [Number3for1 formatAmount:_accinfoDict[@"waitTotal"]];
            //}
        }
        if ([_viewController isLegalObject:accountInfoDict[@"personAmount"]]) {
            //        self.TotalInterestLable.text = [NSString stringWithFormat:@"%.2f", [accountInfoDict[@"totalEarning"] doubleValue]];
            self.chanGen.text = [Number3for1 formatAmount:accountInfoDict[@"waitTotalMouth"]];
        } else {
            self.chanGen.text = @"0.00";
        }

        
    }
    
    //设置自动投标 autoBid为0 说明自动投标没有开通
    if ([_viewController isLegalObject:accountInfoDict[@"autoBid"]]) {
        if ([accountInfoDict[@"autoBid"] integerValue] == 0) {
            self.autoNumberLable.text = @"无忧理财!";
            self.autoexplainLable.text = @"(未开启)";
        } else {
             self.autoNumberLable.text = @"无忧理财!";
             self.autoexplainLable.text = @"(已开启)";
        }
    }
    
    //可用红包个数
     if ([_viewController isLegalObject:accountInfoDict[@"redCount"]]) {
         self.redCountLabel.text = [NSString stringWithFormat:@"%@个可用",accountInfoDict[@"redCount"]];
     }
    
}

- (void)setinitWithMDAssetsView {
    self.accountMoneyLable.text = @"0.00";
    self.usableAssetsLable.text = @"0.00";
    self.TotalInterestLable.text = @"0.00";
    self.dingQiLab.text = @"0.00";
    self.chanGen.text = @"0.00";
}

#pragma mark - 动态总资产
- (void)setTotalMoneyAmount:(double)totalMoneyAmount {
    self.accountMoneyLable.text = @"0.00";
    [self setNumberTextOfLabel:self.accountMoneyLable WithAnimationForValueContent:totalMoneyAmount];
}

- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(double)value {
    CGFloat ratio = value / 50.0;
    NSDictionary *userInfo = @{ @"label": label,
                                @"value": @(value),
                                @"ratio": @(ratio)
    };
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)setupLabel:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    double value = [userInfo[@"value"] doubleValue];
    double ratio = [userInfo[@"ratio"] doubleValue];
    
    static int flag = 1;
    
    
    double lastValue = [label.text doubleValue];
    //    double randomDelta = (arc4random_uniform(2) + 1) * ratio;
    double resValue = lastValue + ratio;

    int Maxflag = value / ratio;
    if (flag == Maxflag) {
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        numFormat.numberStyle = kCFNumberFormatterDecimalStyle;
        NSNumber *num = [NSNumber numberWithDouble:value];
        NSString *numString = [numFormat stringFromNumber:num];
        if ([numString rangeOfString:@"."].location != NSNotFound) {
            NSArray *numStringArray = [numString componentsSeparatedByString:@"."];
            if ([[numStringArray objectAtIndex:1] length] == 1) {
                label.text = [NSString stringWithFormat:@"%@0", numString];
            } else if ([[numStringArray objectAtIndex:1] length] == 2) {
                label.text = numString;
            } else {
                label.text = [NSString stringWithFormat:@"%@.%@", [numStringArray objectAtIndex:0], [[numStringArray objectAtIndex:1] substringWithRange:NSMakeRange(0, 2)]];
            }
        } else {
            label.text = [NSString stringWithFormat:@"%@.00", numString];
        }
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    flag++;
}

#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView == changeMoneyAlert || alertView == autoBidAlert || alertView == certificationAlert) && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [_viewController customPushViewController:BindingBankCardView customNum:0];
    }
}

@end


#pragma mark - FooterView Action

@interface MyAssetsBottomViewFooter ()
{
    UIAlertView * alertTel;
    BaseViewController * _viewController;
}
@end

@implementation MyAssetsBottomViewFooter
- (instancetype)initWithBottomViewFooterViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController{
    if (![super init]) {
        return nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"MyAssetsBottomView" owner:self options:nil] lastObject];
    self.frame = viewFram;
    _viewController = (BaseViewController *) viewController;
    
     UITapGestureRecognizer *autoBidGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviesViewTap:)];
    [self.serviceTelephoneViewAddGestrue addGestureRecognizer:autoBidGesture];
    
    return self;
}

- (void)setServicesValue:(NSDictionary *)servicesDict
{
    _serviceDict = [servicesDict copy];
    self.telephoneNumLabel.text  = [NSString stringWithFormat:@"%@",
                                    [_viewController isLegalObject:_serviceDict[@"service_hotline"]]?
                                    _serviceDict[@"service_hotline"]:@"-"];/*@"400-686-5850"*/
    
    self.workTimeLabel.text = [NSString stringWithFormat:@"%@",[_viewController isLegalObject:_serviceDict[@"workTime"]]?_serviceDict[@"workTime"]:@"-"];
}

- (void)serviesViewTap:(UITapGestureRecognizer*)tap
{
    alertTel = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否拨叫客服电话" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"呼叫", nil];
    [alertTel show];
}

//#pragma mark - UIAlertView代理
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != 0 && alertView == alertTel) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_serviceDict[@"service_hotline1"]?_serviceDict[@"service_hotline1"]:@"-"]]];//@"tel://4006865850"]];
//    }
//}

@end

