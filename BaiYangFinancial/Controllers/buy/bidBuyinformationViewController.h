//
//  bidBuyinformationViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/11.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef NS_ENUM(NSInteger, WDBidType) {
    bidTypeCustom = 0,
    OptimizationBid, //优选标
    GreenhandBid,    //新手标
    DirectionalBid,  //定向标
};

@interface bidBuyinformationViewController : BaseViewController <CustomUINavBarDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *allSendButton; //全投按钮
- (IBAction)userButtonAction:(id)sender;                      //确认按钮点击事件
//- (IBAction)allinvestButtonAction:(id)sender;                 //全投按钮

@property (nonatomic, assign) WDBidType bidType; //标的类型

@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UILabel *SurplusMoneyLable;           //剩余可投
@property (weak, nonatomic) IBOutlet UILabel *userSurplusMoneyLable;       //账户余额
@property (weak, nonatomic) IBOutlet UITextField *InvestmentAmountTF;      //投资金额输入框
@property (weak, nonatomic) IBOutlet UILabel *QuotaMoneyLable;             //每位用户限投
@property (weak, nonatomic) IBOutlet UILabel *limitsinvestMoneyLeftstring; //每位用户限投说明

@property (nonatomic, retain) NSString *DirectionalMoneyString; //定向标的金额
@property (nonatomic, retain) NSString *productBID;             //标id
@property (nonatomic, retain) NSString *AssetsproductBID;       //资产包标id
@property (nonatomic, retain) NSString *bidNameString;          //标的名称
@property (nonatomic, retain) NSString *bidPasswordString;      //标的密码
@property (nonatomic, retain) NSString *QuotaMoneyString;       //标的限投金额

@property (nonatomic, retain) NSString *TenderMinAmountString;  //最小起投
@property (weak, nonatomic) IBOutlet UILabel *investmentLab; // 投资金额
@property (weak, nonatomic) IBOutlet UILabel *userMoenyLab;//余额支出

@property (weak, nonatomic) IBOutlet UILabel *redBsetLab; //红包
@property (weak, nonatomic) IBOutlet UILabel *setMoenyLasb; // 还需支付
//- (id)initWithsetBank:(NSString *)bankCardIcon bankCardName:(NSString *)bankCardNameStr bankCardNumber:(NSString *)bankCardNumberStr bankCardStyle:(NSString *)bankCardStyleStr;

@property (nonatomic,strong)NSString *tfText;

@end
