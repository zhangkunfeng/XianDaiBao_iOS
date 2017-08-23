//
//  ProductdetailsViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AutoBidViewController.h"
#import "CalculatorView.h"
#import "InvestedUserViewController.h" //投资记录
#import "ProductdetailsViewController.h"
#import "VerificationiPhoneNumberViewController.h" //登陆界面
#import "bidBuyinformationViewController.h"        //立即购买界面
#import "ProjectDetailsViewController.h" //项目材料
#import "UIImage+GIF.h"
#import "BindingBankCardViewController.h"
#import "theViewOen.h"
#import "setPaymentPassWorldViewController.h"

#define TEXTFONT [UIFont systemFontOfSize:14.0]
@interface ProductdetailsViewController () <CalculatorViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,theViewOenDelegate,UITextFieldDelegate> {
    NSString *bidTenderNum;    //投资记录
    NSInteger CountdownNumber; //倒计时时间
    CGFloat lastContentOffset;//滚动偏移量
    UIAlertView * autoBidAlert;     //支付
}

@property (weak, nonatomic) IBOutlet UIImageView *noviceImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UILabel *userYuELab;

@property (weak, nonatomic) IBOutlet UIView *textFiView;

@property (weak, nonatomic) IBOutlet UILabel *jisuanLab;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *touziNumLab;

@property (weak, nonatomic) IBOutlet UIView *NavigationView;
@property (weak, nonatomic) IBOutlet UIView *NavigationBottomView;

- (IBAction)backBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *DetailBidTitleLabel;//详情标题
@property (weak, nonatomic) IBOutlet UILabel *RevenueCycleLabel;  //理财期限(天/月)
@property (weak, nonatomic) IBOutlet UILabel *isNewExclusiveorOrFixedIncomeLabel;//新人专享/固定收益
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollerView;//背景UIScrollView

@property (weak, nonatomic) IBOutlet UILabel *borrow_periodLable;//投资期限
@property (weak, nonatomic) IBOutlet UILabel *borrow_aprLable;   //标的年化率
@property (weak, nonatomic) IBOutlet UILabel *addborrow_aprLable;//奖励利率
@property (weak, nonatomic) IBOutlet UILabel *borrowAmountLable; //项目总额

@property (weak, nonatomic) IBOutlet UILabel *surplus_borrowAmountLable;//剩余可投
@property (weak, nonatomic) IBOutlet UIProgressView *BorrowProgress;    //进度条
@property (weak, nonatomic) IBOutlet UILabel *showProgressLabel;        //进度条显示label
@property (weak, nonatomic) IBOutlet UIImageView *showProgressImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showProgressLabelLeadingConstant;//labelLeading
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showProgressImageLeadingConstant;//imageLeading
@property (weak, nonatomic) IBOutlet UIButton *ImmediatelyBuyButton;//立即抢购按钮
@property (weak, nonatomic) IBOutlet UITextField *buyTf;

- (IBAction)gotoBuyBidbuttonAction:(id)sender;//立即购买
@property (weak, nonatomic) IBOutlet UILabel *isShowtimeLable;//显示倒计时
@property (weak, nonatomic) IBOutlet UILabel *qitoujinerLabel;//起投金额
@property (nonatomic, copy) NSDictionary *userInformationDict;//用户信息字典
@property (weak, nonatomic) IBOutlet UILabel *lineLable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *productActivityIndicatorView;

- (IBAction)buttomCalculatorAction:(id)sender;
@property (nonatomic, copy) NSArray *tableViewTitleArray;    //底部标的标题
@property (nonatomic, copy) NSArray *tableViewImageArray;    //底部标的图片
@property (nonatomic, strong) UILabel *bidTenderNumberLable; //投资记录
@property (weak, nonatomic) IBOutlet UIButton *calculatorButton;
@property (nonatomic, strong) CalculatorView *calculatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyButtonHorizontalConstraint;//调整计算器位置
@property (weak, nonatomic) IBOutlet UILabel *investRangeLable;

//投资规则
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;   //发标时间
@property (weak, nonatomic) IBOutlet UILabel *withTheTimeLabel;//满标时间
@property (weak, nonatomic) IBOutlet UILabel *paymentTimeLabel;//还款时间
@property (weak, nonatomic) IBOutlet UILabel *closingTimeLabel;//结案时间

@property (weak, nonatomic) IBOutlet UILabel *reimbursementMeansLabel;//还款方式
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;       //标的描述信息

@property (weak, nonatomic) IBOutlet UILabel *showNewPersonLabel;     //新手标描述

@property (weak, nonatomic) IBOutlet UIImageView *withTheTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *paymentTimeLabelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *closingTimeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageGIF;
@property (assign,nonatomic) BOOL isShowImage;

//adapter   normal
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theTwoBigViewHeightConstant;//214

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideTopViewHeightConstant;//34
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidDescriptionView;//54
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideSwitchViewHeightConstant;//544 (iPhone6)

@property (nonatomic, copy) NSDictionary *UserInformationDict;  //用户信息字典
@property (nonatomic, strong) UIAlertView * envelopeAlert;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBCons;
@property (weak, nonatomic) IBOutlet UIView *incomView;



@end

@implementation ProductdetailsViewController
#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"标的详情页"];
    //[self loadLangyaBangData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"标的详情页"];
    //移除报错界面
    [self hideMDErrorShowView:self];
    self.bottomViewBCons.constant = 0;

}
- (void)viewWillDisappear
{
   [super viewWillDisappear:YES];
    [self.buyTf resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    //为监听键盘高度添加两个观察者
    self.jisuanLab.hidden = YES;
    self.buyTf.delegate = self;
    [self.buyTf addTarget:self action:@selector(buyTfEditClick) forControlEvents:UIControlEventEditingDidBegin];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.buyTf];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDetailScrollViewSetting:) name:changeDetailContentScrollView object:nil];
    [self loadLangyaBangData];
    
    [self setttingContentcrollerView];
    [self setUI];
    [self settingConstant];
    
    self.investAmountBgView.layer.cornerRadius = 4;
    self.investAmountBgView.layer.masksToBounds = YES;
}

- (void)dealloc {
    if (_tableViewTitleArray) {
        _tableViewTitleArray = nil;
    }
    if (_tableViewImageArray) {
        _tableViewImageArray = nil;
    }
    if (_producDetailstDict) {
        _producDetailstDict = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changeDetailContentScrollView object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self];//多项移除不建议 系统注册还有
}
- (void)setttingContentcrollerView
{
    //self.contentScrollerView.bounces = YES;//导致不能下拉刷新
    self.contentScrollerView.showsHorizontalScrollIndicator = NO;
    self.contentScrollerView.showsVerticalScrollIndicator = NO;//chuizhi
//    self.contentScrollerView.pagingEnabled = YES;
    self.contentScrollerView.delegate = self;
    self.contentScrollerView.contentSize = CGSizeMake(0, 1204);
}

- (void)settingConstant
{
    //猜想
    if (iPhone4) {
        //switchView
        self.slideSwitchViewHeightConstant.constant = 544-140;
    }
    
    if (iPhone5) {
        //switchView
        self.slideSwitchViewHeightConstant.constant = 544-101;
    }
//    
//    if (iPhone6_) {
//        //twoBigView
//        self.bidDescriptionView.constant = 54+4;
//        self.theTwoBigViewHeightConstant.constant = 214+9;
//        //slideTopView
//        self.slideTopViewHeightConstant.constant = 44;//+10
//        //switchView
//        self.slideSwitchViewHeightConstant.constant = 544+66;
//    }
}

- (void)setttingSlicderView
{
    self.slideSwitchView.slideSwitchViewDelegate =self;
    self.slideSwitchView.rootScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.slideSwitchView.tabItemNormalColor = [self colorFromHexRGB:@"3A3A3A"];
    self.slideSwitchView.tabItemSelectedColor = AppMianColor;
    
    self.projectDetail = [[ProjectDetailsViewController alloc] initWithNibName:@"ProjectDetailsViewController" bundle:nil];
    self.projectDetail.title = @"项目详情";
    self.projectDetail.bidString = _productBid;
    self.projectDetail.productdetail=self;
    
    self.projectMaterials = [[ProjectContractMaterialsViewController alloc] init];
    self.projectMaterials.title = @"项目材料";
    self.projectMaterials.bidString =  _productBid;
    self.projectMaterials.bidTypeId =  @"30";
    self.projectMaterials.productdetail=self;

    self.projectContract = [[ProjectContractMaterialsViewController alloc] init];
    self.projectContract.title = @"项目合同";
    self.projectContract.bidString =  _productBid;
    self.projectContract.bidTypeId =  @"29";
    self.projectContract.productdetail=self;
    
    //
    self.investedUser = [[InvestedUserViewController alloc] init];
    self.investedUser.title = @"投资记录";
    self.investedUser.bid = _productBid;
    self.investedUser.isOptimizationBid = self.isOptimizationBid;
    if ([self isLegalObject:_producDetailstDict[@"borrowAnnualYield"]]) {
        self.investedUser.InterestRate = [NSString stringWithFormat:@"%.2f%@", [_producDetailstDict[@"borrowAnnualYield"] floatValue], @"%"];
    } else {
        self.investedUser.InterestRate = @"";
    }
    self.investedUser.productdetail=self;
    
    [self.slideSwitchView buildUI];
}

#pragma mark - 详情、保障、人数页面跳转
- (IBAction)tapToJumpToDetailView:(UITapGestureRecognizer *)sender {

     [self jumpToWebview:[NSString stringWithFormat:@"%@bid/newProductDetail?at=%@&bid=%@", GeneralWebsite, getObjectFromUserDefaults(ACCESSTOKEN),_productBid] webViewTitle:@"项目详情"];
}

- (IBAction)tapToJumpToSecurtyView:(UITapGestureRecognizer *)sender {
   [self jumpToWebview:[NSString stringWithFormat:@"%@bid/safetyGuarantee?at=%@&bid=%@", GeneralWebsite, getObjectFromUserDefaults(ACCESSTOKEN),_productBid] webViewTitle:@"安全保障"];
}

-(InvestedUserViewController *)investedUser{
    if (_investedUser == nil) {
        _investedUser = [[InvestedUserViewController alloc] initWithNibName:@"InvestedUserViewController" bundle:nil];
        _investedUser.title = @"投资记录";
        _investedUser.bid = _productBid;
        _investedUser.isOptimizationBid = self.isOptimizationBid;
        if ([self isLegalObject:_producDetailstDict[@"borrowAnnualYield"]]) {
            _investedUser.InterestRate = [NSString stringWithFormat:@"%.2f%@", [_producDetailstDict[@"borrowAnnualYield"] floatValue], @"%"];
        } else {
            _investedUser.InterestRate = @"";
        }
        _investedUser.productdetail=self;
    }
    return _investedUser;
}

- (IBAction)tapToJumpToAmountView:(UITapGestureRecognizer *)sender {
    self.investedUser.bidTenderNum = bidTenderNum;
    [self.investedUser setBidTenderNum:bidTenderNum];
    [self customPushViewController:self.investedUser customNum:0];
}


#pragma mark - QCSlideSwitchView 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 4;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if(number == 0){
        return self.projectDetail;
    }else if(number == 1){
        return self.projectMaterials;
    }else if(number == 2){
        return self.projectContract;
    }else{
        return self.investedUser;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{

}

#pragma mark - scrollView代理方法


- (void)sendShowImageDataNotification
{
//    if (!_isShowImage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:showDetailContractMaterialsDataimage object:nil];
//        _isShowImage = YES;
//    }
}

- (void)changeDetailScrollViewSetting:(NSNotification *)notificat
{
    self.contentScrollerView.scrollEnabled = YES;
    [UIView animateWithDuration:0.3f animations:^{
        
//        if (self.contentScrollerView.contentOffset.y < 0 && _weakRefreshHeader.refreshState != SDRefreshViewStateRefreshing) {
//            self.contentScrollerView.contentOffset = CGPointMake(0, 0);
//        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
//    lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.contentScrollerView.contentOffset.y >= _contentScrollerView.contentSize.height -_contentScrollerView.frame.size.height) {
        self.contentScrollerView.contentOffset = CGPointMake(0, _contentScrollerView.contentSize.height - _contentScrollerView.frame.size.height);
    }
}

#pragma mark - action event
- (IBAction)newPeopleGiftButtonAction:(id)sender {
    [self jumpToWebview:[NSString stringWithFormat:@"%@sys/special2", GeneralWebsite] webViewTitle:@"三重礼"];
}

- (void)newPeopleGiftButton:(id)sender {
    [self jumpToWebview:[NSString stringWithFormat:@"%@sys/special2", GeneralWebsite] webViewTitle:@"三重礼"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
       return YES;
}

-(void)textFieldDidChange:(NSNotification *)obj{
    self.jisuanLab.hidden = NO;
    NSString *toBeString = self.buyTf.text;
    NSString *sstr;
    NSString *Deadline = @"";
    NSString *DeadlineNumber = @"";
    NSString *baseDeadlineNumber = @"";
    if ([self isLegalObject:_producDetailstDict[@"periodTimeUnit"]] && [self isLegalObject:_producDetailstDict[@"borroePeriod"]]) {
        if ([_producDetailstDict[@"periodTimeUnit"] intValue] == 1) {
            if ([self isLegalObject:_producDetailstDict[@"monthDay"]]) {
                if ([_producDetailstDict[@"monthDay"] integerValue] > 31) {
                    Deadline = @"天";
                    baseDeadlineNumber = @"monthDay";
                }else{
                    Deadline = @"个月";
                    baseDeadlineNumber = @"borroePeriod";
                }
            }else{
                Deadline = @"个月";
                baseDeadlineNumber = @"borroePeriod";
            }
        } else {
            Deadline = @"天";
            baseDeadlineNumber = @"borroePeriod";
        }
        DeadlineNumber = [NSString stringWithFormat:@"%zd", [_producDetailstDict[baseDeadlineNumber] integerValue]];
    }
    //    NSLog(@"传入计算收益视图参数 = %@",_producDetailstDict);
    NSDictionary *calculatorDict = @{ @"bidAmount": [NSString stringWithFormat:@"%.2f",
                                                     [_producDetailstDict[@"borrowAmount"] doubleValue]],
                                      @"bidProfitAmount": ![self isLegalObject:_producDetailstDict[@"bidProfitAmount"]] ? @"0" : [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"bidProfitAmount"] doubleValue]],
                                      @"Deadline": Deadline,
                                      @"DeadlineNumber": DeadlineNumber };
    if ([self.buyTf.text doubleValue] > 0) {
        self.incomView.alpha = 1;
        /*输入数/标的总额*总收益数*/
        self.jisuanLab.text = [NSString stringWithFormat:@"预计收益 %.2f元",([self.buyTf.text doubleValue] / [calculatorDict[@"bidAmount"] doubleValue]) * [calculatorDict[@"bidProfitAmount"] doubleValue]];
//        [self AttributedString:sstr andTextColor:[UIColor darkGrayColor] andTextFontSize:13.0f AndRange:sstr.length withlength:0 AndLabel:self.jisuanLab];

    }else{
        self.jisuanLab.text = @"0.00";
        self.jisuanLab.hidden = YES;
        self.incomView.alpha = 0;
    }

    int length = 0;
    if ([toBeString rangeOfString:@"."].location != NSNotFound) {
        length = (int)[toBeString rangeOfString:@"."].location + 3;
        NSLog(@"%d", length);
    }
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.buyTf markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.buyTf positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (length != 0 && toBeString.length > length) {
                self.buyTf.text = [toBeString substringToIndex:length];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (length != 0 && toBeString.length > length) {
            
            self.buyTf.text = [toBeString substringToIndex:length];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入两位小数
    NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
    [futureString insertString:string atIndex:range.location];
    NSInteger flag = 0;
    const NSInteger limited = 2;
    for (NSInteger i = futureString.length - 1; i >= 0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    
    //输入金额
    NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //剩余可投
    NSString * remainingMoneyStr = [Number3for1 forDelegateChar:self.surplus_borrowAmountLable.text];
    //最大可投
    NSString *tenderMaxAmountStr = [NSString stringWithFormat:@"%@",_producDetailstDict[@"tenderMaxAmount"]];
    
    NSString * theMinString = [tenderMaxAmountStr floatValue]==0?remainingMoneyStr
    :[tenderMaxAmountStr floatValue]>[remainingMoneyStr floatValue]?remainingMoneyStr
    :tenderMaxAmountStr;
    
    if (textField == self.buyTf) {
        
        if([string isEqualToString:@"\n"]) {
            //按回车关闭键盘
            [textField resignFirstResponder];
            return NO;
        } else if(string.length == 0) {
            //判断是不是删除键
            return YES;
            
        } else if ([tempStr floatValue]-[theMinString floatValue]>0){
                self.buyTf.text = theMinString;
                [self errorPrompt:3.0 promptStr:@"输入金额超出剩余可投/最大可投"];
            return NO;

        }/*else if(textField.text.length >= 12) {
            //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
            NSLog(@"输入的字符个数大于6，忽略输入");
            return NO;
        } else if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string isEqual:@"8"] && ![string  isEqual:@"9"]) {
            return NO;
        } */else {
            return YES;
        }
    }
    
    NSString *Deadline = @"";
    NSString *DeadlineNumber = @"";
    NSString *baseDeadlineNumber = @"";
    if ([self isLegalObject:_producDetailstDict[@"periodTimeUnit"]] && [self isLegalObject:_producDetailstDict[@"borroePeriod"]]) {
        if ([_producDetailstDict[@"periodTimeUnit"] intValue] == 1) {
            if ([self isLegalObject:_producDetailstDict[@"monthDay"]]) {
                if ([_producDetailstDict[@"monthDay"] integerValue] > 31) {
                    Deadline = @"天";
                    baseDeadlineNumber = @"monthDay";
                }else{
                    Deadline = @"个月";
                    baseDeadlineNumber = @"borroePeriod";
                }
            }else{
                Deadline = @"个月";
                baseDeadlineNumber = @"borroePeriod";
            }
        } else {
            Deadline = @"天";
            baseDeadlineNumber = @"borroePeriod";
        }
        DeadlineNumber = [NSString stringWithFormat:@"%zd", [_producDetailstDict[baseDeadlineNumber] integerValue]];
    }
    //    NSLog(@"传入计算收益视图参数 = %@",_producDetailstDict);
    NSDictionary *calculatorDict = @{ @"bidAmount": [NSString stringWithFormat:@"%.2f",
                                                     [_producDetailstDict[@"borrowAmount"] doubleValue]],
                                      @"bidProfitAmount": ![self isLegalObject:_producDetailstDict[@"bidProfitAmount"]] ? @"0" : [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"bidProfitAmount"] doubleValue]],
                                      @"Deadline": Deadline,
                                      @"DeadlineNumber": DeadlineNumber };
    if ([self.buyTf.text doubleValue] > 0) {
        /*输入数/标的总额*总收益数*/
        self.jisuanLab.text = [NSString stringWithFormat:@"%.2f",([self.buyTf.text doubleValue] / [calculatorDict[@"bidAmount"] doubleValue]) * [calculatorDict[@"bidProfitAmount"] doubleValue]];
    }else{
    self.jisuanLab.text = @"0.00";
    }
    return YES;
}


//计算器
- (IBAction)buttomCalculatorAction:(id)sender {
    NSString *Deadline = @"";
    NSString *DeadlineNumber = @"";
    NSString *baseDeadlineNumber = @"";
    if ([self isLegalObject:_producDetailstDict[@"periodTimeUnit"]] && [self isLegalObject:_producDetailstDict[@"borroePeriod"]]) {
        if ([_producDetailstDict[@"periodTimeUnit"] intValue] == 1) {
            if ([self isLegalObject:_producDetailstDict[@"monthDay"]]) {
                if ([_producDetailstDict[@"monthDay"] integerValue] > 31) {
                    Deadline = @"天";
                    baseDeadlineNumber = @"monthDay";
                }else{
                    Deadline = @"个月";
                    baseDeadlineNumber = @"borroePeriod";
                }
            }else{
            Deadline = @"个月";
            baseDeadlineNumber = @"borroePeriod";
            }
        } else {
            Deadline = @"天";
            baseDeadlineNumber = @"borroePeriod";
        }
        DeadlineNumber = [NSString stringWithFormat:@"%zd", [_producDetailstDict[baseDeadlineNumber] integerValue]];
    }
//    NSLog(@"传入计算收益视图参数 = %@",_producDetailstDict);
    NSDictionary *calculatorDict = @{ @"bidAmount": [NSString stringWithFormat:@"%.2f",
                                                     [_producDetailstDict[@"borrowAmount"] doubleValue]],
                                      @"bidProfitAmount": ![self isLegalObject:_producDetailstDict[@"bidProfitAmount"]] ? @"0" : [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"bidProfitAmount"] doubleValue]],
                                      @"Deadline": Deadline,
                                      @"DeadlineNumber": DeadlineNumber};
    if (!_calculatorView) {
        _calculatorView = [[CalculatorView alloc] initWithCalculatorView:self calculatorDict:calculatorDict];
    }
    [self showPopupWithStyle:CNPPopupStyleFullscreen popupView:_calculatorView];
}

//立即购买
- (IBAction)gotoBuyBidbuttonAction:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (btn.tag == 10000) {
        UIAlertView *BuyBidAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"此项目尚未到达投标时间，请耐心等待！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [BuyBidAlert show];
    } else if ([self isBlankString:getObjectFromUserDefaults(UID)]){
         //为空
            VerificationiPhoneNumberViewController *VerificationiPhoneNumberView = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
            VerificationiPhoneNumberView.pushviewNumber = 4;
            [self customPushViewController:VerificationiPhoneNumberView customNum:0];
        } else {
            [self.buyTf endEditing:YES];
            [UIView animateWithDuration:0.5 animations:^{
                self.bottomViewBCons.constant = 0;
            }];
            [self loadJudgeTradingPasswordAndCardData];
        }
    }

#pragma mark - 获取用户信息
- (void)getUserinformation {
    
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"bid": _producDetailstDict[@"bid"]};

    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getUserBalance", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getUserinformation];
                } withFailureBlock:^{
                    
                }];
                
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getUserinformation];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"%@",responseObject[@"item"]);
                _userInformationDict = [responseObject[@"item"] copy];
                self.userYuELab.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%@", _userInformationDict[@"balance"]]];

            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }fail:^{
         [self errorPrompt:3.0 promptStr:errorPromptString];
        }];
}

- (void)jumpBidBuyinformationViewController {
    
    NSLog(@"_producDetailstDict = %@",_producDetailstDict);
    NSLog(@"_userInformationDict = %@",_userInformationDict);
    bidBuyinformationViewController *bidBuyinformationView = [[bidBuyinformationViewController alloc] initWithNibName:@"bidBuyinformationViewController" bundle:nil];
    if ([self isLegalObject:_producDetailstDict[@"isRookie"]] && [_producDetailstDict[@"isRookie"] integerValue] == 1) {
        bidBuyinformationView.bidType = GreenhandBid;
    }
    //是否定时标
    if ([self isLegalObject:_producDetailstDict[@"isDirectional"]]) {
        if ([_producDetailstDict[@"isDirectional"] integerValue] == 1) {
            bidBuyinformationView.bidType = DirectionalBid;
            bidBuyinformationView.DirectionalMoneyString = [self isLegalObject:_producDetailstDict[@"directional"]] ? [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"directional"] doubleValue]] : @"500000.00";
        }
    } //是否定向标
    bidBuyinformationView.productBID = [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"bid"] integerValue]];
    if (_isOptimizationBid) {
        bidBuyinformationView.AssetsproductBID = _productBid;
        bidBuyinformationView.bidType = OptimizationBid;
    }
    bidBuyinformationView.bidNameString = _bidNameString;
    bidBuyinformationView.bidPasswordString = @"";
    if ([self isLegalObject:_producDetailstDict[@"tenderMaxAmount"]]) {
        if ([_producDetailstDict[@"tenderMaxAmount"] doubleValue] != 0) {
            bidBuyinformationView.QuotaMoneyString = [NSString stringWithFormat:@"%.0f", [_producDetailstDict[@"tenderMaxAmount"] doubleValue]];
        } else {
        }
    } else {
        bidBuyinformationView.QuotaMoneyString = @"0";
    }
    
    //最小可投 传值
    if ( [self isLegalObject:_producDetailstDict[@"tenderMinAmount"]]) {
        bidBuyinformationView.TenderMinAmountString = [NSString stringWithFormat:@"%@", _producDetailstDict[@"tenderMinAmount"]];
    }
    
    //判断新手标
    if (bidBuyinformationView.bidType == GreenhandBid) {
        if ([self isLegalObject:_userInformationDict[@"isIntegral"]]) {
            if ([_userInformationDict[@"isIntegral"] integerValue] == 1) {
                bidBuyinformationView.tfText = self.buyTf.text;
                
               [self customPushViewController:bidBuyinformationView customNum:0];
            }else{
                [self errorPrompt:3.0 promptStr:@"您已经不是新手了，把机会让给新人吧！"];
            }
        }
    }else{
        bidBuyinformationView.tfText = self.buyTf.text;
    [self customPushViewController:bidBuyinformationView customNum:0];
    }
}

//nTimeCountdown(当为定时标的时候倒计时)
- (void)inTimeCountdown {
    if (CountdownNumber > 0) {
        int hour = (int) (CountdownNumber / 3600);
        int minute = (int) (CountdownNumber - hour * 3600) / 60;
        int second = (int) (CountdownNumber - hour * 3600 - minute * 60);
        [self.ImmediatelyBuyButton setTitle:@"" forState:UIControlStateNormal];
        self.ImmediatelyBuyButton.tag = 10000;
        self.isShowtimeLable.hidden = NO;
        self.isShowtimeLable.text = [NSString stringWithFormat:@"%d小时%d分%d秒后开始投标", hour, minute, second];
        CountdownNumber--;
    } else {
        dispatch_source_cancel(_timingCountdownTimer);
        self.ImmediatelyBuyButton.tag = 11111;
        self.isShowtimeLable.hidden = YES;
        [self.ImmediatelyBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
}

#pragma mark - HTTP
- (void)loadProductdetailsData {
    NSDictionary *parameters = nil;
    NSString *postJSONWithUrlString = @"";
    if (_isOptimizationBid) {
        postJSONWithUrlString = [NSString stringWithFormat:@"%@bidap/portfoliosListDetail", GeneralWebsite];
        parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                        @"apId": _productBid
        };
    } else {
        postJSONWithUrlString = [NSString stringWithFormat:@"%@bid/bidDetail", GeneralWebsite];
        parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                        @"bid": _productBid,
                        @"version": @"4"};
    }
    [self showWithDataRequestStatus:@"加载中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:postJSONWithUrlString parameters:parameters success:^(id responseObject) {
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadProductdetailsData];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
                //界面数据的字典
                
                _producDetailstDict = [responseObject[@"item"] copy];
                 _touZnumLab.text =  [NSString stringWithFormat:@"%@人",_producDetailstDict[@"bidTenderNum"]];
                
                if ([_producDetailstDict[@"borrowedCompletionRate"] floatValue] == 100) {
                    self.isShowImage = YES;
                    self.projectContract.isShowPic = YES;
                    self.projectMaterials.isShowPic = YES;
                }
                
                [self getUserinformation];//同时加载用户信息 方便下面判断新手标是否可投
                //可以调计算器
                _calculatorButton.enabled = YES;
                if (_producDetailstDict != nil && [_producDetailstDict isKindOfClass:[NSDictionary class]]) {
                    //投资人列表
                    if (![_producDetailstDict[@"bidTenderNum"] isKindOfClass:[NSNull class]]) {
                        bidTenderNum = [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"bidTenderNum"] integerValue]];
                        _investedUser.bidTenderNum = bidTenderNum;
                    }
                    //界面赋值
                    [self ValuationToallcontrol];
                    
                    //详情
                    if ([self isLegalObject:_producDetailstDict[@"bid"]]){

                        /*材料
                        NSString * materialUrl = [NSString stringWithFormat:@"%@newEight/projectData?bid=%@&at=%@", GeneralWebsite, _producDetailstDict[@"bid"], getObjectFromUserDefaults(ACCESSTOKEN)];//bid null
                        NSLog(@"productMaterial = %@",materialUrl);
                        [self.productMaterial setloadviewRequestWithrequestURL:materialUrl]; */
                        
                    }
                    
                    //跟新进度条的状态
                    if ([self isLegalObject:_producDetailstDict[@"borrowedCompletionRate"]]) {
                        if ([_producDetailstDict[@"borrowedCompletionRate"] floatValue] > 0) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self startUpdataProgess];
                              
                            });
                        }
                    }
                }
                 [_weakRefreshHeader endRefreshing];
            } else {
                [self dismissWithDataRequestStatus];
                 [_weakRefreshHeader endRefreshing];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
        fail:^{
            [self dismissWithDataRequestStatus];
             [_weakRefreshHeader endRefreshing];
            [self initWithWDprojectErrorview:nil contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
        }];
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack {
    _producDetailstDict = nil;
    [self customPopViewController:0];
}

#pragma mark - CalculatorViewDelegate
- (void)initWithCalculatorCancelAction {
    [self dismissPopupController];
}

#pragma mark - setters && getters
- (void)setUI{
    [self.productActivityIndicatorView startAnimating];
    [self.backBtn setImage:[UIImage imageNamed:@"back_ Selected"] forState:UIControlStateHighlighted];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight * 0.35)];
    view.backgroundColor = AppMianColor;
//    [self setTheGradientWithView:view];
    [self.view insertSubview:view atIndex:0];
    
//    self.imageGIF.image = [UIImage sd_animatedGIFNamed:@"尖头"]; autoAppendingWith@2x
    self.imageGIF.image = [self setImageGIFWithPathForResource:@"尖头@3x" ofType:@"gif"];
    
    self.DetailBidTitleLabel.text = _bidNameString;
    self.BorrowProgress.progress = 0.0;
    bidTenderNum = @"0";
    self.ImmediatelyBuyButton.alpha = 0.3;
    self.ImmediatelyBuyButton.enabled = NO;
    
    NSString * string = @"(该标新人才能投资,每位新人限投1次新手标!)";
    [self AttributedString:string andTextColor:[UIColor colorWithHexString:@"FB9300"] andTextFontSize:10.0f AndRange:string.length-7 withlength:2 AndLabel:self.showNewPersonLabel];
    
    if (![self isBlankString:_productBid]) {
        [self loadProductdetailsData];
    }
    self.userYuELab.text = [Number3for1 formatAmount:[NSString stringWithFormat:@"%@", _userInformationDict[@"balance"]]];

//    [self setttingSlicderView];

    //定时器的初始化
    [self setTimer];
    [self setTimingCountdownTimer];
    [self setupHeader];
}

- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomViewBCons.constant = 0;
    }];
}

/**
 设置GIF
 @param name pngName
 @param ext gif
 @return image
 */
- (UIImage *)setImageGIFWithPathForResource:(NSString *)name ofType:(NSString *)ext
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    return image;
}

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.contentScrollerView];
    _weakRefreshHeader = refreshHeader;
    [_weakRefreshHeader settingTextIndicatorColorIsChange:YES];
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![self isBlankString:_productBid]) {
                //定时器的初始化
                [self setTimer];
                [self setTimingCountdownTimer];
                [self loadProductdetailsData];
            }
        });
    };
}

//页面定时器初始化
- (void)setTimer {
    //间隔还是2秒
    uint64_t interval = 0.001 * NSEC_PER_SEC;
    //创建Timer
    _progressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(_progressTimer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    //设置回调
    dispatch_source_set_event_handler(_progressTimer, ^() {
        [self updataProgressNum];
    });
    dispatch_source_set_cancel_handler(_progressTimer, ^{
        //        NSLog(@"进度条结束了");
    });
}

- (void)setTimingCountdownTimer {
    //间隔时间
    uint64_t interval = 1 * NSEC_PER_SEC;
    //创建Timer
    _timingCountdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(_timingCountdownTimer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    //设置回调
    dispatch_source_set_event_handler(_timingCountdownTimer, ^() {
        [self inTimeCountdown];
    });
    dispatch_source_set_cancel_handler(_timingCountdownTimer, ^{
        //        NSLog(@"定时标结束了");
    });
}

//进度状态更新
- (void)startUpdataProgess {
    _BorrowProgress.hidden = NO;
    _BorrowProgress.progress = 0.0;
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    dispatch_resume(_progressTimer);
}

- (void)updataProgressNum {
    _BorrowProgress.progress = _BorrowProgress.progress + 0.001;
    float borrowedCompletionRate = [_producDetailstDict[@"borrowedCompletionRate"] floatValue] / 100;
    if (borrowedCompletionRate == 0) {
        _BorrowProgress.progress = 0.0;
        //让_progressTimer暂停
        dispatch_source_cancel(_progressTimer);
    } else {
        
        if (_BorrowProgress.progress >= borrowedCompletionRate) {
            //让_progressTimer暂停
            dispatch_source_cancel(_progressTimer);
        }
        
        CGFloat showProgressLabelWidth = self.showProgressLabel.frame.size.width;
        CGFloat showProgressImageWidth = self.showProgressImage.frame.size.width;
        CGFloat progressOriginX = _BorrowProgress.progress * (iPhoneWidth);//百分比 0.899999
        CGFloat progressHundred = _BorrowProgress.progress * 100;//99.999999
        
        self.showProgressLabel.text = [NSString stringWithFormat:@"已售%.0f%%",progressHundred];

        if (progressOriginX < showProgressLabelWidth) {
            self.showProgressLabelLeadingConstant.constant = 15.0f;
        }else if((progressOriginX +showProgressLabelWidth) > iPhoneWidth){
            self.showProgressLabelLeadingConstant.constant = iPhoneWidth-15 - showProgressLabelWidth/2;
        }else{
            self.showProgressLabelLeadingConstant.constant = progressOriginX + 15 - showProgressLabelWidth/2;
        }
        
        
        if (progressOriginX+showProgressImageWidth > iPhoneWidth) {
            self.showProgressImageLeadingConstant.constant = iPhoneWidth -showProgressImageWidth/2;
        }else{
            self.showProgressImageLeadingConstant.constant = progressOriginX - showProgressImageWidth/2;
        }
    }
}

- (void)setOpenAutobid:(id)sender {
    //判断是否登录
    if ([self isBlankString:getObjectFromUserDefaults(UID)]) {
        VerificationiPhoneNumberViewController *verificationiPhoneNumber = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verificationiPhoneNumber.pushviewNumber = 10010; //用于记录是设置自动投标进去的
        [self customPushViewController:verificationiPhoneNumber customNum:0];
    } else {
        //查看自动投标详情
        AutoBidViewController *AutobidView = [[AutoBidViewController alloc] initWithNibName:@"AutoBidViewController" bundle:nil];
        AutobidView.backAssetsView = ^(NSDictionary *autoSettingDict) {
            
        };
        [self customPushViewController:AutobidView customNum:0];
    }
}

/**
  *  borrow_periodLable  periodTimeUnit = 0表示天标，否则算月标
  *  bidAttribute 标的属性  手机标  新手标  是否是手机标 1-是，否则则不是
  *  borrow_aprLable 标的年化率
  *  addborrow_aprLable  标的奖励
  *  borrowAmountLable 项目总额
  *  borrowedCompletionRateLable  借款进度
  *  surplus_borrowAmountLable  剩余可投
  *  tenderMinAmountLable   最小可投
  *  tenderMaxAmountLable   最大可投
  */
//给所有的控件赋值
- (void)ValuationToallcontrol {
    /*
     @property (weak, nonatomic) IBOutlet UILabel *reimbursementMeansLabel;//还款方式
     @property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;//标的描述信息
     
    repaymentStyle   0-月还息到期还本(先息后本),1-等额本息,2-按月分期    【备】2基本不用
    monthDay 到期本息
     1、本产品的还款方式为：到期本息，项目满标后开始计息，15天后可转让，到期后借款人一次性还本付息。
     2、本产品的还款方式为：等额本息，项目满标后开始计息，15天后可转让，借款人在还款期内每月偿还同等数额的资金（包括本金和利息）。
     3、本产品的还款方式为：先息后本，项目满标后开始计息，15天后可转让，借款人先按月支付利息，在到期日一次性归还本金。
     */
    
    NSLog(@"_producDetailstDict = %@",_producDetailstDict);
    
    //等额本息/到期还本
    if ([self isLegalObject:_producDetailstDict[@"repaymentStyle"]]) {
        if ([_producDetailstDict[@"repaymentStyle"] integerValue] == 0) {
            self.reimbursementMeansLabel.text = @"先息后本";
        }else {
            self.reimbursementMeansLabel.text = @"等额本息";
        }
    }

    //天标、月标   以及还款方式判断
    if ([self isLegalObject:_producDetailstDict[@"monthDay"]]) {
        if ([_producDetailstDict[@"monthDay"] integerValue] > 31) {
           self.borrow_periodLable.text = [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"monthDay"] integerValue]];
             self.RevenueCycleLabel.text = @"理财期限(天)";
             self.reimbursementMeansLabel.text = @"先息后本";
        }else{
            if ([self isLegalObject:_producDetailstDict[@"periodTimeUnit"]]) {
                if ([_producDetailstDict[@"periodTimeUnit"] integerValue] == 1) {
                    self.borrow_periodLable.text = [self isLegalObject:_producDetailstDict[@"borroePeriod"]] ? [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"borroePeriod"] integerValue]] : @"";
                    self.RevenueCycleLabel.text = @"理财期限(月)";
                    
                } else {
                    self.borrow_periodLable.text = [self isLegalObject:_producDetailstDict[@"borroePeriod"]] ? [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"borroePeriod"] integerValue]] : @"";
                    self.RevenueCycleLabel.text = @"理财期限(天)";
                    self.reimbursementMeansLabel.text = @"先息后本";
                }
            }
        }
    }else{/*防止monthDay 无数据*/
        if ([self isLegalObject:_producDetailstDict[@"periodTimeUnit"]]) {
            if ([_producDetailstDict[@"periodTimeUnit"] integerValue] == 1) {
                self.borrow_periodLable.text = [self isLegalObject:_producDetailstDict[@"borroePeriod"]] ? [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"borroePeriod"] integerValue]] : @"";
                self.RevenueCycleLabel.text = @"理财期限(月)";
            } else {
                self.borrow_periodLable.text = [self isLegalObject:_producDetailstDict[@"borroePeriod"]] ? [NSString stringWithFormat:@"%zd", [_producDetailstDict[@"borroePeriod"] integerValue]] : @"";
                self.RevenueCycleLabel.text = @"理财期限(天)";
                self.reimbursementMeansLabel.text = @"到期本息";
            }
        }
    }
    
    //还款方式 描述
    if ([self.reimbursementMeansLabel.text isEqualToString:@"到期本息"]) {
        self.descriptionLabel.text = @"本产品的还款方式为：到期本息，项目满标后开始计息，到期后借款人一次性还本付息。";
    }else if ([self.reimbursementMeansLabel.text isEqualToString:@"等额本息"]) {
        self.descriptionLabel.text = @"本产品的还款方式为：等额本息，项目满标后开始计息，借款人在还款期内每月偿还同等数额的资金（包括本金和利息）。";
    }else {
        self.descriptionLabel.text = @"本产品的还款方式为：先息后本，项目满标后开始计息，借款人先按月支付利息，在到期日一次性归还本金。";
    }
   
    if ([self isLegalObject:_producDetailstDict[@"borrowAmount"]]) {
         self.borrowAmountLable.text  = [Number3for1 forMoenyString:[NSString stringWithFormat:@"%@", _producDetailstDict[@"borrowAmount"]]];

//        NSString * projectMoneyAll = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f", [_producDetailstDict[@"borrowAmount"] doubleValue]]]; //项目总额
//        self.borrowAmountLable.text =  [NSString stringWithFormat:@"%@",projectMoneyAll];
        
    }

    if ([self isLegalObject:_producDetailstDict[@"borrowedCompletionRate"]]) {
        //剩余可投
        if ([_producDetailstDict[@"borrowedCompletionRate"] integerValue] == 100) {
            self.surplus_borrowAmountLable.text = @"0.00";
            //后添加   动态安保标
            [self addBaoquanBidimageView];
            self.textFiView.userInteractionEnabled = NO;
            self.textFiView.backgroundColor = [UIColor lightGrayColor];
            if ([_producDetailstDict[@"status"] isEqualToString:@"已结案"]) {
                [self.ImmediatelyBuyButton setTitle:@"已回款" forState:UIControlStateNormal];
            } else if ([_producDetailstDict[@"status"] isEqualToString:@"还款中"]) {
                [self.ImmediatelyBuyButton setTitle:@"还款中" forState:UIControlStateNormal];
            }else {
                [self.ImmediatelyBuyButton setTitle:@"已满标" forState:UIControlStateNormal];
            }
//            [self.ImmediatelyBuyButton setBackgroundColor:AppMianColor];
            self.ImmediatelyBuyButton.alpha = 0.3;
            self.ImmediatelyBuyButton.enabled = NO;
        } else {
            self.ImmediatelyBuyButton.alpha = 1.0;
            self.ImmediatelyBuyButton.enabled = YES;
            if ([self isLegalObject:_producDetailstDict[@"tenderAmount"]]) {
                if ([_producDetailstDict[@"tenderAmount"] doubleValue] < 1) {
                    NSString * str =  [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f", [_producDetailstDict[@"tenderAmount"] doubleValue]]];
                    self.surplus_borrowAmountLable.text = [NSString stringWithFormat:@"%@",str];
                    
                } else {
                    NSString * str1 = [Number3for1 formatAmount: [NSString stringWithFormat:@"%.02f", [_producDetailstDict[@"tenderAmount"] doubleValue]]];
                    self.surplus_borrowAmountLable.text = [NSString stringWithFormat:@"%@",str1];
                }
            } else {
                if ([_producDetailstDict[@"borrowedCompletionRate"] integerValue] == 100) {
                    self.surplus_borrowAmountLable.text = @"0.00";
                } else {
                    NSString * string  = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f", [_producDetailstDict[@"borrowAmount"] doubleValue] - [_producDetailstDict[@"borrowedAmount"] doubleValue]]];
                    self.surplus_borrowAmountLable.text = [NSString stringWithFormat:@"%@",string];
                }
            }
        }
    } else {
//        self.borrowedCompletionRateLable.text = @"0.00%"; //借款进度
    }
    
    //新手秒和秒杀标不能同时出现    ** 新人专享 / 固定收益
    if ([self isLegalObject:_producDetailstDict[@"isRookie"]]) {
        if ([_producDetailstDict[@"isRookie"] integerValue] == 1) {
            self.lineLable.hidden = NO;
            self.isNewExclusiveorOrFixedIncomeLabel.text = @"新人专享";
            self.showNewPersonLabel.hidden = NO;
            
            self.noviceImageView.hidden = NO;
            
        } else {
            self.lineLable.hidden = NO;
            self.isNewExclusiveorOrFixedIncomeLabel.text = @"固定收益";
            self.showNewPersonLabel.hidden = YES;
        }
    } else {
        self.lineLable.hidden = NO;
        self.isNewExclusiveorOrFixedIncomeLabel.text = @"固定收益";
        self.showNewPersonLabel.hidden = YES;
    }
   
    if ([self isLegalObject:_producDetailstDict[@"awardAmonut"]]) {
        if ([_producDetailstDict[@"awardAmonut"] doubleValue] > 0) {//奖励金额
            self.lineLable.hidden = NO;
            self.addborrow_aprLable.hidden = NO;
            self.addborrow_aprLable.text = [NSString stringWithFormat:@"+%.2f%@", [_producDetailstDict[@"awardAmonut"] doubleValue] * 100, @"%"];
            
            self.isNewExclusiveorOrFixedIncomeLabel.text = @"加息福利";
        }else{
            self.addborrow_aprLable.text = @"";
            self.addborrow_aprLable.hidden = YES;
        }
    }
    
    if ([self isLegalObject:_producDetailstDict[@"borrowAnnualYield"]]) {
        self.borrow_aprLable.text = [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"borrowAnnualYield"] floatValue]]; //标的年利率
    } else {
        self.borrow_aprLable.text = @"0.00"; //标的年利率
    }
    
    //判断是否定时标
    if ([self isLegalObject:_producDetailstDict[@"isTime"]]) {
        if ([_producDetailstDict[@"isTime"] integerValue] == 1) {
            NSString *startTimeStr = _producDetailstDict[@"startTime"];
            NSString *nowTimeStr = _producDetailstDict[@"nowTime"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *startTimedate = [formatter dateFromString:startTimeStr];
            NSDate *nowTimedate = [formatter dateFromString:nowTimeStr];
            NSString *startTimeIntervalSince = [NSString stringWithFormat:@"%ld", (long) [startTimedate timeIntervalSince1970]];
            NSString *nowTimeIntervalSince = [NSString stringWithFormat:@"%ld", (long) [nowTimedate timeIntervalSince1970]];
            if ([nowTimeIntervalSince integerValue] < [startTimeIntervalSince integerValue]) {
                CountdownNumber = [startTimeIntervalSince integerValue] - [nowTimeIntervalSince integerValue];
                //定时标开启定时器
                dispatch_resume(_timingCountdownTimer);
            }
        }
    }
    
    //最大可投金额
    if ([self isLegalObject:_producDetailstDict[@"tenderMaxAmount"]]) {
        if ([_producDetailstDict[@"tenderMaxAmount"] doubleValue] != 0) {
            if ([_producDetailstDict[@"tenderMaxAmount"] doubleValue] > [_producDetailstDict[@"borrowAmount"] doubleValue]) {
//                NSString * str1 = [Number3for1 formatAmount:[NSString stringWithFormat:@"%.02f", [_producDetailstDict[@"borrowAmount"] doubleValue]]];
            } else {
//                NSString * str2 = [Number3for1 formatAmount: [NSString stringWithFormat:@"%.02f元", [_producDetailstDict[@"tenderMaxAmount"] doubleValue]]];
            }
        }else { // == 0; 不限

        }
    }
    if ([_producDetailstDict[@"tenderAmount"] doubleValue] < 100) {
        self.buyTf.text = [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"tenderAmount"] doubleValue]];
        self.buyTf.userInteractionEnabled = NO;
    }

    //最小可投[NSString stringWithFormat:@"%@", _producDetailstDict[@"tenderMinAmount"]];
    if ( [self isLegalObject:_producDetailstDict[@"tenderMinAmount"]]) {
//        self.tenderMinAmountLable.text = [NSString stringWithFormat:@"%@元", _producDetailstDict[@"tenderMinAmount"]];
        //起投金额
        self.qitoujinerLabel.text = [NSString stringWithFormat:@"%@", _producDetailstDict[@"tenderMinAmount"]];
        self.buyTf.placeholder = [NSString stringWithFormat:@"%@元起投", _producDetailstDict[@"tenderMinAmount"]];
    }

    if ([self isLegalObject:_producDetailstDict[@"bidProfitAmount"]] && [_producDetailstDict[@"bidProfitAmount"] doubleValue] > 0) {
        self.buyButtonHorizontalConstraint.constant = 73;
        self.calculatorButton.hidden = NO;
    } else {
        [self.calculatorButton removeFromSuperview];
    }

    //发标时间
    self.sendTimeLabel.text = [self isLegalObject:_producDetailstDict[@"verifyTime"]]? [NSString stringWithFormat:@"%@",_producDetailstDict[@"verifyTime"]]:@"";
    
    //满标时间
    self.withTheTimeLabel.text = [self isLegalObject:_producDetailstDict[@"reverifyTime"]]? [NSString stringWithFormat:@"%@",_producDetailstDict[@"reverifyTime"]]:@"";
    
    //还款时间
    self.paymentTimeLabel.text = [self isLegalObject:_producDetailstDict[@"repayNextTime"]] ? [NSString stringWithFormat:@"%@",_producDetailstDict[@"repayNextTime"]]:@"";
    
    //结案时间
    self.closingTimeLabel.text = [self isLegalObject:_producDetailstDict[@"repayTime"]] ? [NSString stringWithFormat:@"%@",_producDetailstDict[@"repayTime"]]:@"";
    
    //》满标图片《
    if (self.withTheTimeLabel.text.length > 0) {
        self.withTheTimeImageView.image = [UIImage imageNamed:@"detail_round"];
    }
    
    //》还款图片 结案时间《
    if ([self isLegalObject:_producDetailstDict[@"status"]]) {
        if ([_producDetailstDict[@"status"] isEqualToString:@"已结案"]) {
            self.closingTimeImageView.image = [UIImage imageNamed:@"detail_round"];
            self.paymentTimeLabelImageView.image  = [UIImage imageNamed:@"detail_round"];
        }
    }
}

//项目详细数据字典
- (NSDictionary *)borrowerinformationDict {
    if (_producDetailstDict != nil) {
        NSDictionary *Dict = @{ @"sex": [_producDetailstDict[@"sex"] isKindOfClass:[NSNull class]] ? @"无记录" : [_producDetailstDict[@"sex"] stringValue],
                                @"isMarriage": [_producDetailstDict[@"marriage"] isKindOfClass:[NSNull class]] ? @"无记录" : [_producDetailstDict[@"marriage"] stringValue],
                                @"nativeplace": [_producDetailstDict[@"vArea"] isKindOfClass:[NSNull class]] ? @"无记录" : _producDetailstDict[@"vArea"],
                                @"isHaveHouse": [_producDetailstDict[@"ishave"] isKindOfClass:[NSNull class]] ? @"无记录" : [_producDetailstDict[@"ishave"] stringValue],
                                @"carinformation": [_producDetailstDict[@"name"] isKindOfClass:[NSNull class]] ? @"无记录" : _producDetailstDict[@"name"],
                                @"carNumber": [_producDetailstDict[@"plateNumber"] isKindOfClass:[NSNull class]] ? @"无记录" : _producDetailstDict[@"plateNumber"],
                                @"carMileage": [_producDetailstDict[@"mileage"] isKindOfClass:[NSNull class]] ? @"无记录" : [_producDetailstDict[@"mileage"] stringValue],
                                @"appraisement": [_producDetailstDict[@"appraisement"] isKindOfClass:[NSNull class]] ? @"无记录" : [NSString stringWithFormat:@"%.2f", [_producDetailstDict[@"appraisement"] doubleValue]],
                                };
        return Dict;
    }
    return nil;
}

- (UILabel *)bidTenderNumberLable {
    if (!_bidTenderNumberLable) {
        _bidTenderNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(iPhoneWidth - 85, 13, 52, 18)];
    }
    _bidTenderNumberLable.textAlignment = NSTextAlignmentRight;
    _bidTenderNumberLable.layer.masksToBounds = YES;
    _bidTenderNumberLable.text = [NSString stringWithFormat:@"%@个", bidTenderNum];
    _bidTenderNumberLable.font = TEXTFONT;
    _bidTenderNumberLable.textColor = [UIColor colorWithHexString:@"#FB9300"];
    return _bidTenderNumberLable;
}

- (void)addBaoquanBidimageView {
    
    UIImageView *baoquanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, iPhoneWidth, iPhoneWidth * 0.817)];
    baoquanImage.alpha = 0.8;
    [baoquanImage setImage:[UIImage imageNamed:@"saveBidImage.png"]];
    baoquanImage.backgroundColor = [UIColor clearColor];
    [self.contentScrollerView addSubview:baoquanImage];
    [UIView animateWithDuration:1.0 animations:^{
        baoquanImage.frame = CGRectMake((iPhoneWidth - 190) / 2, 59, 190, 148);
        baoquanImage.transform = CGAffineTransformRotate(baoquanImage.transform, -0.1);
    }completion:^(BOOL finished){
                         
    }];
}

- (IBAction)backBtnClicked:(id)sender {
    _producDetailstDict = nil;
    [self customPopViewController:0];
}


#pragma mark - 判断设置交易密码
- (void)loadJudgeTradingPasswordAndCardData{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
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
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
                //是否设置交易密码
                if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDict[@"pay"] integerValue] == 1) {
                    
                    //是否绑卡
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        _envelopeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"银行卡支付需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_envelopeAlert show];
                        
                    } else {
                        if ([_userInformationDict[@"tenderAmount"] doubleValue] >= [_producDetailstDict[@"tenderMinAmount"]doubleValue]) {
                            if ([self.buyTf.text doubleValue] < [_producDetailstDict[@"tenderMinAmount"]doubleValue]) {
                                [self errorPrompt:3.0 promptStr:[NSString stringWithFormat: @"%@元起投",_producDetailstDict[@"tenderMinAmount"]]];
                            } else {
                                [self pushSureView];
                            }
                        } else {
                            [self pushSureView];
                        }
                    }
                }else{
                    [self setPaymentPassWordController];
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
        }];
}

- (void)pushSureView {
     NSString *str;
    if (![self isPureFloat:self.buyTf.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入数字"];
        return;
    }
    if ([self.buyTf.text doubleValue] == 0) {
        [self errorPrompt:3.0 promptStr:@"请输入购买金额"];
        return;
    }
    if ([self.buyTf.text doubleValue] > [_producDetailstDict[@"tenderAmount"] doubleValue]) {
        [self errorPrompt:3.0 promptStr:@"可投金额不足"];
        return;
    }
    if ([self isLegalObject:_producDetailstDict[@"tenderMaxAmount"]]) {
        if ([_producDetailstDict[@"tenderMaxAmount"] doubleValue] != 0) {
            str = [NSString stringWithFormat:@"%.0f", [_producDetailstDict[@"tenderMaxAmount"] doubleValue]];
        } else {
            
        }
    } else {
        str = @"0";
    }

    if ([str doubleValue] > 0 && [self.buyTf.text doubleValue] > [str doubleValue]) {
        [self errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"每位用户限投%.0f元", [str doubleValue]]];
        return;
    }
    [self jumpBidBuyinformationViewController];

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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _envelopeAlert && buttonIndex != 0) {
        [self performSelector:@selector(pushBindingCardViewtroller) withObject:nil afterDelay:0.25];
    }
}

- (void)pushBindingCardViewtroller
{
    BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
    BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
    BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
        
    };
    BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
    [self customPushViewController:BindingBankCardView customNum:0];
}




- (void)getMyBankCardinformation{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    //加载框
    WS(weakSelf);
    //    [_viewController showWithDataRequestStatus:@"加载中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsiteT] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf getMyBankCardinformation];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf getMyBankCardinformation];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isKindOfClass:[NSNull class]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
                
                //自动投标
                if ([_UserInformationDict[@"status"] integerValue] == 2 ) {
                    autoBidAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"购买需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                    [autoBidAlert show];
                } else {
                 
                    [self jumpBidBuyinformationViewController ];
                }
            }
            
            /*branchState 为0的话  可以修改支行信息  为1 不可修改支行信息
             *state 为1锁住银行信息  为2已审核可以更改   为3 提现审核中不可修改
             *status 1有卡 2无卡  3替换
             *realStatus 0 身份信息通过  1不通过  2审核中
             */
            
                   } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                    }
    }fail:^{
        [self showErrorViewinMain];
    }];
}

- (void)loadLangyaBangData
{
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"bid": _productBid,};
    
    WS(weakSelf);//GeneralWebsite
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getLangYaBang",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadLangyaBangData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([self isLegalObject:responseObject[@"data"]] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *array = responseObject[@"data"];
                    NSLog(@"*******************************\n array = %@",array);
                    
                    if ([array count] > 0) {
//                        NSString *stringInt = [NSString stringWithFormat:@"%lu人投资",(unsigned long)array.count];
//                        _touZnumLab.text = stringInt;
//                        
                    }else{
                    //_touZnumLab.text = @"0人投资";
                    }
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }else{
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }fail:^{
        [self errorPrompt:3.0 promptStr:errorPromptString];
    }];
}

- (IBAction)alertView:(id)sender {
    
    theViewOen *vc = [[theViewOen alloc]initWiththeDelegate:self];
    
    [self showPopupWithStyle:CNPPopupStyleFullscreen popupView:vc];
}

-(void)center{
    [self dismissPopupController];
}

//xgy添加
- (void)buyTfEditClick{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomViewBCons.constant = 220;
    }];
}

@end
