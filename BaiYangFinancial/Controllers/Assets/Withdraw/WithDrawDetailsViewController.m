//
//  WithDrawDetailsViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/4.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "MainViewController.h"
#import "WithDrawDetailsViewController.h"
#import "shareView.h"
#import "TalkingDataAppCpa.h"
#import <UShareUI/UShareUI.h>

@interface WithDrawDetailsViewController () <shareViewDelegate>

@property (copy, nonatomic) NSDictionary *shareDictionary;
@property (copy, nonatomic) NSDictionary *successViewDataDict;

@property (strong, nonatomic) shareView *shareView;

@end

@implementation WithDrawDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:_titleString showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    //初始化pushNumber为投标
    [self setViewController];

//    [self addSafetyViewToSubview:self.fundsafetyView];

    //    [self performSelector:@selector(showshareView) withObject:nil afterDelay:0.5];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.pushNumber == 0 && _shareView) {
        [self dismissShareView];
    }
}

- (void)showshareView {
    if (!_shareView) {
        _shareView = [[shareView alloc] initWithShareViewDelegate:self];
        [self showPopupWithStyle:CNPPopupStyleCentered popupView:_shareView];
    }
    
    if (getDictionaryFromUserDefaults(InvestmentSuccessDataDict)) {
        [_shareView setDataWithShareView];
    }
}

- (void)setViewController {
    self.MoneNumberLable.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:self.payMonryString]];
    if (self.pushNumber == 0) {
        [self getShareInfo];
        self.titleLable.text = @"投标申请成功,正在审核中!";
        self.finishIntroductionsLable.text = @"申请成功";
        self.tixianTitleLable.text = @"投标金额";
        self.NaneLeftLable.text = @"标名";
        self.middleIntroductionsLable.text = @"安全审核";
        self.tenderBidIntroductionsLable.hidden = NO;
        self.tenderBidIntroductionsLable.text = @"申请标的需要1-10分钟。请耐心等待。由于投标人数众多,最终投标数额以审核金额为准。";
        self.nameStringLable.text = _bidNameString;
        
        self.bankLabel.text = @"";
        self.bankName.text  = @"";
        self.bankNum.text   = @"";
        
        [self XROnCustEvent3InvestmentSuccess];//投资成功  检测
      
    } else if (self.pushNumber == 1) {
        self.titleLable.text = @"提现申请已提交银行处理...";
        self.tixianTitleLable.text = @"提现金额";
        self.NaneLeftLable.text = @"姓名";
        self.tenderBidIntroductionsLable.hidden = NO;
        self.tenderBidIntroductionsLable.text = @"由于银行系统的客观时间,到账时间会有延迟!";
        self.BankView.hidden = NO;
        self.bankNameLable.text = _userInfodict[@"bank"];
        self.bankCode.text = _userInfodict[@"accountHidden"];
        self.nameStringLable.text = _userInfodict[@"userNameHidden"];
        
        [self XROnCustEvent4WithdrawalsSuccess];//提现成功  检测
        
    } else if (self.pushNumber == 33) {
        [self getShareInfo];
        self.titleLable.text = @"承接申请成功，正在审核中！";
        self.tixianTitleLable.text = @"承接金额";
        self.finishIntroductionsLable.text = @"承接成功";
        self.tenderBidIntroductionsLable.text = @"承接标的需要系统审核，请您到债权转让中查看承接是否成功。";
        self.NaneLeftLable.text = @"标名";
        self.nameStringLable.text = _bidNameString;
        self.tenderBidIntroductionsLable.hidden = NO;
        self.bankLabel.text = @"";
        self.bankName.text  = @"";
        self.bankNum.text   = @"";
        
    } else if (self.pushNumber == 5) {
        self.titleLable.text = @"还款申请已提交银行处理中...";
        self.tixianTitleLable.text = @"还款金额";
        self.NaneLeftLable.text = @"姓名";
        self.nameStringLable.text = _userInfodict[@"userNameHidden"];
        self.middleIntroductionsLable.text = @"银行划账";
        self.tenderBidIntroductionsLable.hidden = NO;
        self.tenderBidIntroductionsLable.text = @"由于银行系统的客观时间,到账会在3分钟内完成!";
        self.BankView.hidden = NO;
        self.bankNameLable.text = _userInfodict[@"bank"];
        self.bankCode.text = _userInfodict[@"accountHidden"];
        
        [self XROnCustEvent2RechargeSuccess];//充值成功 检测
        
    } else {
        self.titleLable.text = @"充值申请已提交银行处理中...";
        self.tixianTitleLable.text = @"充值金额";
        self.NaneLeftLable.text = @"姓名";
        self.nameStringLable.text = _userInfodict[@"userNameHidden"];
        self.middleIntroductionsLable.text = @"银行划账";
        self.tenderBidIntroductionsLable.hidden = NO;
        self.tenderBidIntroductionsLable.text = @"由于银行系统的客观时间,到账会在3分钟内完成!";
        self.BankView.hidden = NO;
        self.bankNameLable.text = _userInfodict[@"bank"];
        self.bankCode.text = _userInfodict[@"accountHidden"];
        
        [self XROnCustEvent2RechargeSuccess];//充值成功 检测
    }
    
    
    NSString * payType = @"";
    switch (self.pushNumber) {// 0 是投标  1  是体现 2充值
        case 0:
            payType = @"投标";
            break;
        case 1:
            payType = @"提现";
            break;
        case 2:
            payType = @"充值";
            break;
        case 5:
            payType = @"还款";
            break;
        default:
            break;
    }
    if (self.pushNumber != 33) {
        /**
         *  @method onPay           支付
         *  @param  account         帐号            类型:NSString
         *  @param  orderId         订单id          类型:NSString
         *  @param  amount          金额            类型:int
         *  @param  currencyType    币种            类型:NSString
         *  @param  payType         支付类型         类型:NSString
         */
        [TalkingDataAppCpa onPay:getObjectFromUserDefaults(MOBILE) withOrderId:[NSString stringWithFormat:@"%@%@",[self getCurrentTimeString],getObjectFromUserDefaults(UID)] withAmount:[self.payMonryString intValue] withCurrencyType:@"CNY" withPayType:payType];
    }
    
}

- (NSString *)getCurrentTimeString
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (void)goBack {
    //发个通知隐藏登陆背景
    //    [[NSNotificationCenter defaultCenter] postNotificationName:LoginFinishLoginFinish object:nil];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //刷新理财产品
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshProductList object:nil];
    [self customPopViewController:3]; 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 完成按钮的点击方法
- (IBAction)FinishButtonAction:(id)sender {
    //    shareView *shareV = [[shareView alloc] initWithShareViewDelegate:self];
    //    [self showPopupWithStyle:CNPPopupStyleCentered popupView:shareV];
    [self goBack];
}

- (void)getShareInfo {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/shareUrl", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                _shareDictionary = [responseObject[@"item"] copy];
                [self loadShareViewData];
//                [self showshareView];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getShareInfo];
        } withFailureBlock:^{
            
        }];
            }
        }
    }
        fail:^{

        }];
}

/**
 {
	r = 1,
	data = (
 )
 ,
	msg = 成功！,
	item = {
	amount = 30,
	updatetime = 2016-10-17,
	img = ,
	text1 = 邀请好友注册并在30天内完成1000元投资，即得30元红包，红包无上限哦~,
	text2 = 邀请好友投资，即享 30 元现金红包
 },
	total = 0
 }
 */
- (void)loadShareViewData
{
//    [self showshareView];//test
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/tender/getTenderSuccessConfig?at=%@", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            _successViewDataDict = [responseObject[@"item"] copy];
            
            if (getDictionaryFromUserDefaults(InvestmentSuccessDataDict)) {
                NSDictionary * userDefaultDict = getDictionaryFromUserDefaults(InvestmentSuccessDataDict);
                if (![userDefaultDict[@"updatetime"] isEqualToString:_successViewDataDict[@"updatetime"]]) {
                    removeDictionaryFromUserDefaults(InvestmentSuccessDataDict);
                    saveDictionaryToUserDefaults(_successViewDataDict, InvestmentSuccessDataDict);
                }
            } else{
                saveDictionaryToUserDefaults(_successViewDataDict, InvestmentSuccessDataDict);
            }
            [self showshareView];
        }else{
            
        }
    }
                              fail:^{
                                  
                              }];
}
- (void)UMengShare {
    [self dismissShareView];

    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[self loadShareDictionaryDataWithType:ShareDictType_shareTitle] descr:[self loadShareDictionaryDataWithType:ShareDictType_shareDesc] thumImage:[self loadShareDictionaryDataWithType:ShareDictType_iconImage]];
    //设置网页地址
    shareObject.webpageUrl = [self loadShareDictionaryDataWithType:ShareDictType_shareLink];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

- (id)loadShareDictionaryDataWithType:(ShareDictType)type
{
    NSDictionary * shareDict = _shareDictionary;
    switch (type) {
        case ShareDictType_shareTitle:
        {
            return [self isLegalObject:shareDict[@"title"]] ? [NSString stringWithFormat:@"%@",shareDict[@"title"]]:@"";
        }
            break;
            
        case ShareDictType_shareLink:
        {
            return [self isLegalObject:shareDict[@"link"]] ? [NSString stringWithFormat:@"%@",shareDict[@"link"]]:@"";
        }
            break;
            
        case ShareDictType_iconImage:
        {
            UIImage * image;
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self isLegalObject:shareDict[@"imgUrl"]] ? [NSString stringWithFormat:@"%@",shareDict[@"imgUrl"]]:@""]]];
            image  = image ? image : [UIImage imageNamed:@"120-120"];
            return image;
        }
            break;
            
        case ShareDictType_shareDesc:
        {
            NSString *shareText = @"";
            if ([shareDict[@"desc"] length] > 0) {
                shareText = shareDict[@"desc"];
                //去除字符串中的标识符
                if ([shareText rangeOfString:@"\n"].location != NSNotFound) {
                    shareText = [shareText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                }
                if ([shareText rangeOfString:@"\r"].location != NSNotFound) {
                    shareText = [shareText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                }
            }
            return shareText;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
/*不知*/
- (void)dismissPopupControllerForCustomShareView {
    [self showWithSuccessWithStatus:@"链接复制成功"];
    [self dismissPopupController];
}
/*不知*/
- (void)dismissForCustomShareViewInshareing {
    [self dismissPopupController];
}

- (void)dismissShareView {
    [self.popupViewController dismissPopupControllerAnimated:YES];
    if (_shareView) {
        _shareView = nil;
    }
}

- (IBAction)withDrawTimeButtonAction:(id)sender {
    [self jumpToWebview:AboutDetailURL webViewTitle:@"提现到账时间"];
}

@end
