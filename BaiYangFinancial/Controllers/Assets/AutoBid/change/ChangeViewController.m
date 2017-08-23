//
//  ChangeViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/1/12.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ChangeViewController.h"
#import "RollOutViewController.h"
#import "RollInViewController.h"
#import "ChangeRecordViewController.h"
#import "AssetsRulesViewController.h"

#define ChangeVCTitle @"零钱包"
@interface ChangeViewController ()
{
    UILabel * _theFirstYu;
    UILabel * _theSecndYu;
    UILabel * _theThreeYu;
    UILabel * _theFoureYu;
    UILabel * _theFivesYu;
    
    CGFloat  _theFirstYuValue;
    CGFloat  _theSecndYuValue;
    CGFloat  _theThreeYuValue;
    CGFloat  _theFoureYuValue;
    
    CGFloat  _theYearRateDay;//日利率
    NSString * _thePersonAmout;//钱包可用余额
    NSString * _bid;//标的
}

@property (strong, nonatomic) UIView *sliderBackgroundView;
@property (strong, nonatomic) UISlider * investSlider;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, strong)NSDictionary *moneyChangeInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *TheBackgrondViewScrollView;
@property (weak, nonatomic) IBOutlet UIView *modifiedView;
@property (weak, nonatomic) IBOutlet UIView *TopView;

@property (weak, nonatomic) IBOutlet UIView *TheSilderBigBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *sliderDescLabel;
@property (weak, nonatomic) IBOutlet UIView *RollOutView;//转出
@property (weak, nonatomic) IBOutlet UIView *RollInView; //买入

@property (weak, nonatomic) IBOutlet UILabel *yesterdayEarningLab;
@property (weak, nonatomic) IBOutlet UILabel *yearRateLab;
@property (weak, nonatomic) IBOutlet UILabel *personAmontLab;

@property (weak, nonatomic) IBOutlet UILabel *yearRateLab_Bottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theMobifiedViewHeight;

@end

@implementation ChangeViewController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:ChangeVCTitle];
    [AFNetworkTool cancelAllHTTPOperations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:ChangeVCTitle];
//    [self loadChangeMoneyData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:ChangeVCTitle showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight * 0.35)];
    view.backgroundColor = [UIColor clearColor];
    [self setTheGradientWithView1:view];
    [self.view insertSubview:view atIndex:0];
    

    
    /*零钱记录*/
    UIButton * changeRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth-65, 23, 50, 30)];
    //[changeRecordBtn setImage:[UIImage imageNamed:@"moneyChange_record"] forState:UIControlStateNormal];
    [changeRecordBtn setTitle:@"明细" forState:UIControlStateNormal];
    changeRecordBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [changeRecordBtn addTarget:self action:@selector(changeRecordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [AutobidView addSubview:changeRecordBtn];
   
    _theYearRateDay = 0.07/365;//初始化
    (iPhone4||iPhone5)?self.sliderDescLabel.font= [UIFont systemFontOfSize:13.0f]:0;
    self.sliderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, iPhoneWidth-30, 30)];
    [self.TheSilderBigBackgroundView addSubview:self.sliderBackgroundView];
    
    [self addTapGestureForRollView];
    [self createYuLabel];
    [self settingTheSlider];
    
    [self loadChangeMoneyData];
    [self setupHeader];
    self.TheBackgrondViewScrollView.scrollEnabled = YES;
    self.TheBackgrondViewScrollView.userInteractionEnabled = YES;
}

- (void)setTheGradientWithView1:(UIView *)view
{
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = CGRectMake(0, 0, iPhoneWidth, CGRectGetHeight(view.frame));
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)[self colorFromHexRGBD:@"999999"].CGColor,
                             (id)[self colorFromHexRGBD:@"999999"].CGColor,
                             /* (id)[UIColor blueColor].CGColor*/];
    
    //    //  设置三种颜色变化点，取值范围 0.0~1.0
    //    gradientLayer.locations = @[@(0.1f) ,@(0.4f)];
    
    //    startPoint&endPoint 颜色渐变的方向，
    //范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
    //    [view.layer addSublayer:gradientLayer];
    //添加在最底层当背景使用
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

- (UIColor *)colorFromHexRGBD:(NSString *)inColorString {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString) {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed:(float) redByte / 0xff
              green:(float) greenByte / 0xff
              blue:(float) blueByte / 0xff
              alpha:0.2];
    return result;
}


- (void)dobutBtnClicked:(id)sender
{
#if 1
    AssetsRulesViewController * assetsRulesVC = [[AssetsRulesViewController alloc] init];
    assetsRulesVC.rulesType = ChangeRulesType;
    [self customPushViewController:assetsRulesVC customNum:0];
    
#elif 0
    NSLog(@"点击了dobut按钮");
    [self jumpToWebview:ChangeMoneyFinancialRulesURL webViewTitle:@"关于零钱规则"];
#endif
}

- (void)changeRecordBtnClicked:(id)sender
{
    NSLog(@"点击了零钱记录按钮");
    ChangeRecordViewController * changeRecordVC = [[ChangeRecordViewController alloc] init];
    [self customPushViewController:changeRecordVC customNum:0];
}

#pragma mark-----  上下拉加载  ------
- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_TheBackgrondViewScrollView];
    _weakRefreshHeader = refreshHeader;
    [_weakRefreshHeader settingTextIndicatorColorIsChange:YES];
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadChangeMoneyData];
        });
    };
}

/**
 *  获取 零钱包数据接口 bid/getCoinInfo
 */
- (void)loadChangeMoneyData
{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    [self showWithDataRequestStatus:@"获取中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getCoinInfo", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadChangeMoneyData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                 [_weakRefreshHeader endRefreshing];
                [self dismissWithDataRequestStatus];
                NSLog(@"请求零钱包数据接口 = %@",responseObject);
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _moneyChangeInfo = [responseObject[@"item"] copy];
                }
                [self setAllDataValues];
            } else {
                 [_weakRefreshHeader endRefreshing];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                   [_weakRefreshHeader endRefreshing];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (void)setAllDataValues
{
    /**
     {
     r = 1,
     data = (
     )
     ,
     msg = 成功！,
     item = {
     amount = 100000,       标总额
     uid = <null>,
     borrowedAmount = 350,  标内当前余额
     tenderMinAmount = 0,   最小投标金额
     borrowAnnualYieldDay = 0.01,  日利率（值有误）
     title = 零钱包001,
     borrowAnnualYield = 7,    年利率
     recoveredInterest = 0,  昨日收益
     personAmount = 0,   用户零钱包中的余额
     bid = 7
     },
     */
    
    //标的
    if ([self isLegalObject:_moneyChangeInfo[@"bid"]]) {
        _bid =  [NSString stringWithFormat:@"%@", _moneyChangeInfo[@"bid"]];
    }
    
    // 昨日收益
    if ([self isLegalObject:_moneyChangeInfo[@"recoveredInterest"]]) {
        self.yesterdayEarningLab.text = [Number3for1 formatAmount:_moneyChangeInfo[@"recoveredInterest"]];
    }
    
    //年化利率
    if ([self isLegalObject:_moneyChangeInfo[@"borrowAnnualYield"]]) {
        NSString * theYearRateStr  = [NSString stringWithFormat:@"%.2f%@",[_moneyChangeInfo[@"borrowAnnualYield"] floatValue],@"%"];
        self.yearRateLab.text = theYearRateStr;
//        self.yearRateLab_Bottom.text =  [NSString stringWithFormat:@"%.1f%@",[_moneyChangeInfo[@"borrowAnnualYield"] floatValue],@"%"];
    }
    
    //总金额 钱包可用金额
    if ([self isLegalObject:_moneyChangeInfo[@"personAmount"]]) {
        self.personAmontLab.text = [Number3for1 formatAmount:_moneyChangeInfo[@"personAmount"]];
        _thePersonAmout = [NSString stringWithFormat:@"%@元",self.personAmontLab.text];
    }
    
    //日利率
    if ([self isLegalObject:_moneyChangeInfo[@"borrowAnnualYieldDay"]]) {
        _theYearRateDay = [_moneyChangeInfo[@"borrowAnnualYieldDay"] floatValue]/100;
    }
    
    if ([self isLegalObject:_moneyChangeInfo[@"recoveredInterest"]]) {
        self.leiJLab.text = [Number3for1 formatAmount:_moneyChangeInfo[@"personTotalEarnings"]];
    }
    
    if ([self isLegalObject:_moneyChangeInfo[@"recoveredInterest"]]) {
        self.shengYuLab.text = [Number3for1 formatAmount:_moneyChangeInfo[@"personSurplus"]];
    }
    
    if ([self isLegalObject:_moneyChangeInfo[@"recoveredInterest"]]) {
        self.chengjiaoLab.text = [Number3for1 formatAmount:_moneyChangeInfo[@"totalVolumeBusiness"]];
    }
    
    if ([self isLegalObject:_moneyChangeInfo[@"recoveredInterest"]]) {
        self.userLab.text = [Number3for1 formatAmount:_moneyChangeInfo[@"countInvestors"]];
    }
    

    
    
    
    
    //初始化 self.sliderDescLabel
    CGFloat theMoneyRate = _theYearRateDay*30;
    NSString * investMoneyStr = @"10,000.00";
    NSString * invtEarningStr = [NSString stringWithFormat:@"%.2f",theMoneyRate*10000];
    NSString * sliderDescLabelStr = [NSString stringWithFormat:@"投资%@元,30天可获得收益%@元",investMoneyStr,invtEarningStr];
    [self AttributedStringChangeVCSetting:sliderDescLabelStr andTextColor:[UIColor colorWithHexString:@"EB702A"] andTextFontSize:(iPhone4||iPhone5)?16.0f:18.0f andRange1:NSMakeRange(2,investMoneyStr.length) andRange2:NSMakeRange(sliderDescLabelStr.length-invtEarningStr.length-1, invtEarningStr.length) AndLabel:self.sliderDescLabel];
}

- (void)addTapGestureForRollView
{
    UITapGestureRecognizer  * rollOuttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rollOutViewTap:)];
    [self.RollOutView addGestureRecognizer:rollOuttap];
  
    UITapGestureRecognizer  * rollIntap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rollInViewTap:)];
    [self.RollInView addGestureRecognizer:rollIntap];
}

- (void)rollOutViewTap:(UITapGestureRecognizer *)tap
{
    
    RollInViewController * rollInVC = [[RollInViewController alloc] initWithNibName:@"RollInViewController" bundle:nil];
    rollInVC.bid = _bid;
    rollInVC.rollInRefresh = ^(BOOL isRefresh){
        if (isRefresh) {
            [self loadChangeMoneyData];
        }
    };
    [self customPushViewController:rollInVC customNum:0];
}

- (void)rollInViewTap:(UITapGestureRecognizer *)tap
{
    
    
    RollOutViewController * rollOutVC = [[RollOutViewController alloc] initWithNibName:@"RollOutViewController" bundle:nil];
    rollOutVC.changeMoneyBlanceStr = _thePersonAmout;
    rollOutVC.bid = _bid;
    rollOutVC.rollOutRefresh = ^(BOOL isRefresh){
        if (isRefresh) {
            [self loadChangeMoneyData];
        }
    };
    [self customPushViewController:rollOutVC customNum:0];


}

- (void)createYuLabel
{
    CGFloat backgroundViewWidth = self.sliderBackgroundView.frame.size.width;
    _theFirstYu = [self createYuLabelWithYuLabelX:backgroundViewWidth*0.1174];
    _theSecndYu = [self createYuLabelWithYuLabelX:backgroundViewWidth*0.3290];
    _theThreeYu = [self createYuLabelWithYuLabelX:backgroundViewWidth*0.5391];
    _theFoureYu = [self createYuLabelWithYuLabelX:backgroundViewWidth*0.7536];/*调*/
    _theFivesYu = [self createYuLabelWithYuLabelX:backgroundViewWidth-8];
    
    [self.sliderBackgroundView addSubview:_theFirstYu];
    [self.sliderBackgroundView addSubview:_theSecndYu];
    [self.sliderBackgroundView addSubview:_theThreeYu];
    [self.sliderBackgroundView addSubview:_theFoureYu];
    [self.sliderBackgroundView addSubview:_theFivesYu];
    
    [self getYuLabelPlace];
}

- (void)settingTheSlider
{
    self.investSlider = [[UISlider alloc] initWithFrame:self.sliderBackgroundView.bounds];
    self.investSlider.value = _theFirstYuValue;
    self.investSlider.tintColor = [UIColor colorWithHexString:@"EB702A"];
    UIImage * thumbImage= [UIImage imageNamed:@"金币"];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件（不加无妨）
    //    [self.investSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.investSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.sliderBackgroundView addSubview:self.investSlider];
    
    //滑块拖动时的事件
    [self.investSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (UILabel *)createYuLabelWithYuLabelX:(CGFloat)yuLabelX
{
    UILabel * yuLabel = [[UILabel alloc] init];
    yuLabel.frame = CGRectMake(yuLabelX, 11, 8, 8);
    yuLabel.backgroundColor = [UIColor colorWithHexString:@"B7B7B7"]; //[UIColor colorWithHexString:@"EB702A"];
    yuLabel.layer.masksToBounds = YES;
    yuLabel.layer.cornerRadius = 4.0f;
    return yuLabel;
}

- (void)getYuLabelPlace
{
    CGFloat theBackgroundViewWidth = self.sliderBackgroundView.frame.size.width;
    _theFirstYuValue = theBackgroundViewWidth * 0.1174 / theBackgroundViewWidth;
    _theSecndYuValue = theBackgroundViewWidth * 0.3290 / theBackgroundViewWidth;
    _theThreeYuValue = theBackgroundViewWidth * 0.5391 / theBackgroundViewWidth;
    _theFoureYuValue = theBackgroundViewWidth * 0.7900 / theBackgroundViewWidth;/*调*/
    
    NSLog(@"_theFirstYuValue = %f",_theFirstYuValue);
    NSLog(@"_theSecndYuValue = %f",_theSecndYuValue);
    NSLog(@"_theThreeYuValue = %f",_theThreeYuValue);
    NSLog(@"_theFoureYuValue = %f",_theFoureYuValue);
}

- (void)sliderValueChanged:(UISlider *)slider
{
    slider.value = slider.value<_theFirstYuValue?_theFirstYuValue//限制最小值
    :(slider.value>_theFirstYuValue&&slider.value<_theSecndYuValue)?_theSecndYuValue
    :(slider.value>_theSecndYuValue&&slider.value<_theThreeYuValue)?_theThreeYuValue
    :(slider.value>_theThreeYuValue&&slider.value<_theFoureYuValue)?_theFoureYuValue
    :1;
    
    UIColor * normalColor = [UIColor colorWithHexString:@"B7B7B7"];
    UIColor * changeColor = [UIColor colorWithHexString:@"EB702A"];
    _theFirstYu.backgroundColor=slider.value<_theFirstYuValue?normalColor:changeColor;
    _theSecndYu.backgroundColor=slider.value<_theSecndYuValue?normalColor:changeColor;
    _theThreeYu.backgroundColor=slider.value<_theThreeYuValue?normalColor:changeColor;
    _theFoureYu.backgroundColor=slider.value<_theFoureYuValue?normalColor:changeColor;

    CGFloat theMoneyRate = _theYearRateDay*30;
    NSString * theFirstEarningStr =[NSString stringWithFormat:@"%.2f",theMoneyRate*10000];
    NSString * theSecndEarningStr =[NSString stringWithFormat:@"%.2f",theMoneyRate*30000];
    NSString * theThreeEarningStr =[NSString stringWithFormat:@"%.2f",theMoneyRate*50000];
    NSString * theFoureEarningStr =[NSString stringWithFormat:@"%.2f",theMoneyRate*100000];
    NSString * theFinalEarningStr =[NSString stringWithFormat:@"%.2f",theMoneyRate*200000];

    //由于sliderValue 取值在_theXxxxxYuValue上下浮动 不能做判断
    //slider.value = 0.328999996  _theFirstYuValue = 0.32900000000000001 [断点值]
    NSString * investMoneyStr =      slider.value<_theFirstYuValue ?@"10,000.00"
    :(slider.value>_theFirstYuValue&&slider.value<_theSecndYuValue)?@"30,000.00"
    :(slider.value>_theSecndYuValue&&slider.value<_theThreeYuValue)?@"50,000.00"
    :(slider.value>_theThreeYuValue&&slider.value<1)?@"100,000.00"
    :@"200,000.00";
    
    NSString * invtEarningStr =      slider.value<_theFirstYuValue ?theFirstEarningStr
    :(slider.value>_theFirstYuValue&&slider.value<_theSecndYuValue)?theSecndEarningStr
    :(slider.value>_theSecndYuValue&&slider.value<_theThreeYuValue)?theThreeEarningStr
    :(slider.value>_theThreeYuValue&&slider.value<1)?theFoureEarningStr
    :theFinalEarningStr;
    
    NSString * sliderDescLabelStr = [NSString stringWithFormat:@"投资%@元,30天可获得收益%@元",investMoneyStr,invtEarningStr];
    
    [self AttributedStringChangeVCSetting:sliderDescLabelStr andTextColor:[UIColor colorWithHexString:@"EB702A"] andTextFontSize:(iPhone4||iPhone5)?16.0f:18.0f andRange1:NSMakeRange(2, investMoneyStr.length) andRange2:NSMakeRange(sliderDescLabelStr.length-invtEarningStr.length-1, invtEarningStr.length) AndLabel:self.sliderDescLabel];
}

- (UILabel *)AttributedStringChangeVCSetting:(NSString *)willChangeString andTextColor:(UIColor *)color andTextFontSize:(CGFloat)fontSize andRange1:(NSRange)range1 andRange2:(NSRange)range2 AndLabel:(UILabel *)label
{
    if (willChangeString == nil) {
        return 0;
    }
    NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:willChangeString];
    
    [strAtt_Temp addAttributes:@{ NSForegroundColorAttributeName: color,
                                  NSFontAttributeName : [UIFont systemFontOfSize:fontSize],}
                         range:range1];
    [strAtt_Temp addAttributes:@{ NSForegroundColorAttributeName: color,
                                  NSFontAttributeName : [UIFont systemFontOfSize:fontSize],}
                         range:range2];
    
    [label setAttributedText:strAtt_Temp];
    
    return label;
}

- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
