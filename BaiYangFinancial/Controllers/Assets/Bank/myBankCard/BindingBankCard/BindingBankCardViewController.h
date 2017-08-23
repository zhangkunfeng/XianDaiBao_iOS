//
//  BindingBankCardViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"


typedef void (^backRefreshmybank)(BOOL isRefresh);

typedef NS_ENUM(NSInteger, BankPayFromChannel) {
    BankPayFromBindingCard = 0, //绑定银行卡
    BankPayFromRecharge,  //充值    似乎没有使用
    BankPayFromTender,   //投标
    BankPayFromUndertake,//承接
    regYes
};

@interface BindingBankCardViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, CustomUINavBarDelegate>
@property (nonatomic, copy) NSDictionary *bankDict;            //选择的银行
@property (nonatomic, copy) NSDictionary *bankPayDict;         //上级界面传过来连连支付需要的数据
@property (nonatomic, copy) NSDictionary *UserInformationDict; //上个界面传下来的用户信息
@property (nonatomic, assign)BankPayFromChannel bankPayChannel;//判断从哪进来的
@property (nonatomic, assign) NSInteger pushNumber;            //11 为银行卡支付  22 为绑定银行卡 33 为充值时卡的信息没有完善的 44承接的时候没钱调来支付  55是我的资产提现进来的
@property (nonatomic, copy) NSString *RechargeMoneyString;     //充值金额
@property (nonatomic, copy) NSString *AvailableBalanceString;  //可用金额
@property (nonatomic, copy) NSString *tranferId;               //承接转让id

@property (nonatomic, copy) NSString *redpackSource;  //传过来 混合支付红包平台选择

@property (nonatomic, copy) NSString *payAounmtMoneyString; //支付总金额
@property (nonatomic, copy) NSString *userMoney;            //账户余额支付
@property (nonatomic, copy) NSString *bankPaymoney;         //银行卡支付金额
@property (nonatomic, copy) NSString *productBID;           //标的id
@property (nonatomic, copy) NSString *bidNameString;        //标的名称
@property (nonatomic, copy) NSString *bidPasswordString;    //标的密码
@property (nonatomic, copy) NSString *recordId;             //红包id
@property (nonatomic, copy) NSString *recordMoneyString;    //红包金额

@property (weak, nonatomic) IBOutlet UIView *RechargeView;           //显示充值金额界面
@property (weak, nonatomic) IBOutlet UILabel *AvailableBalanceLable; //显示可用余额框
@property (weak, nonatomic) IBOutlet UITextField *RechargeMoneyTF;   // 充值金额

/**
 *  银行卡支付的时候展示
 */
@property (weak, nonatomic) IBOutlet UIView *buyBidshowView;     //购买时显示支付余额
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLable;     //余额支付金额
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLable;    //账户余额支付金额
@property (weak, nonatomic) IBOutlet UILabel *bankPayMoneyLable; //银行卡支付金额
@property (weak, nonatomic) IBOutlet UILabel *recordMoneyLable;  //红包抵扣金额

@property (weak, nonatomic) IBOutlet UITableView *ShowTableview;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *safeView;                                            //资金安全View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RechargePriceNumberFeildWidthConstraint; //充值金额的输入框宽度

- (IBAction)goToPayment:(id)sender; //下一步的按钮处理按钮事件

/**
 *  界面约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RechargeViewheightConstraint;   //充值金额的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyBidshowViewheightConstraint; //购买时显示支付金额界面的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonTopTableviewConstraintHieght; //下一步按钮距离上面表的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableViewheightConstraint;          //表的高度

@property (nonatomic, copy) backRefreshmybank isRefresh;

@property (nonatomic, assign) BOOL isOptimizationBid;

@end
