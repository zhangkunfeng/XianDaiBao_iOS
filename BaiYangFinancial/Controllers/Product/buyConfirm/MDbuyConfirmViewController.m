//
//  MDbuyConfirmViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/18.
//  Copyright © 2016年 无名小子. All rights reserved.
//
#import "BindingBankCardViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "MDbuyConfirmViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "WithDrawDetailsViewController.h"
#import "myRedenvelopeListViewController.h"
#import "myRedenvelopeModel.h"
#import "remainingBalancePayView.h"
#import "setPaymentPassWorldViewController.h"
#import "XRPayPassWorldView.h"
#import "ForgetPassWdViewController.h"

@interface MDbuyConfirmViewController () <CustomUINavBarDelegate, UITableViewDataSource, UITableViewDelegate, remainingBalancePayViewDelegate,XRPayPassWorldViewDelegate,UITextFieldDelegate> {
    NSMutableArray *dataArray;
    NSString * redpackSource;
}

@property (weak, nonatomic) IBOutlet UILabel *bidName;
@property (weak, nonatomic) IBOutlet UILabel *bidBuyMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *balanceLable;
@property (weak, nonatomic) IBOutlet UILabel *getmyRedenvelopeLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *DisplayLable;
- (IBAction)buyButtonAction:(id)sender;
@property (strong, nonatomic) UITextField *buyConfirmTextField;
@property (strong, nonatomic)XRPayPassWorldView *payPassWorldView;

@property (weak, nonatomic) IBOutlet UILabel *realDiKouLabel;//抵扣 不变 label  需hidden
@property (weak, nonatomic) IBOutlet UILabel *diKouMoneyLabel;//抵扣金额

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) BOOL isHavePayPassworld;
@property (assign, nonatomic) BOOL isRequest;
@property (copy, nonatomic) NSDictionary *userInformationDict;
@property (assign, nonatomic) float DeductionMoney;
@property (copy, nonatomic) NSString *recordId; //红包id
@property (weak, nonatomic) IBOutlet UILabel *bidTitleNameLabel;

@end

@implementation MDbuyConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *buyConfirmView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"购买标的确认" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:buyConfirmView];

    self.recordId = @"";
    
    self.DeductionMoney = 0.0;

    redpackSource = @"";
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.activityIndicatorView startAnimating];

    [self setUI];
}

#pragma mark - Action 确认
- (IBAction)buyButtonAction:(id)sender {
    NSString *userMyassetsMoneyString = @"0.00";
    NSString *userMyBankMoneyString = @"0.00";
    //替换下,
         NSString * userSurplusMoney = [self.dict[@"userSurplusMoney"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([userSurplusMoney doubleValue] + self.DeductionMoney >= [self.dict[@"buyMoney"] doubleValue]) {

        userMyassetsMoneyString = [NSString stringWithFormat:@"%.2f", [self.dict[@"buyMoney"]  doubleValue] - self.DeductionMoney];
    } else {
        
//        NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSString *strUrl = [self.dict[@"userSurplusMoney"] stringByReplacingOccurrencesOfString:@"," withString:@""];
//        NSLog(@"-----> %@",strUrl);
        
        userMyassetsMoneyString = [NSString stringWithFormat:@"%.2f", [userSurplusMoney doubleValue]];

        userMyBankMoneyString = [NSString stringWithFormat:@"%.2f", [self.dict[@"buyMoney"] doubleValue] - self.DeductionMoney - [userSurplusMoney doubleValue]];


    }
//     NSLog(@"userMyassetsMoneyString (这个是) %@",userMyassetsMoneyString);
//     NSLog(@"%@",userMyBankMoneyString);

    remainingBalancePayView *payview = [[remainingBalancePayView alloc]
                                        initWithView:self.dict[@"buyMoney"]
                                   userMyassetsMoney:userMyassetsMoneyString
                                     userMyBankMoney:userMyBankMoneyString
                                deductionMoneyString:[NSString stringWithFormat:@"%.2f", self.DeductionMoney] theDelegate:self];
    [self showPopupWithStyle:CNPPopupStyleCentered popupView:payview];
}

#pragma mark - HTTP
- (void)getmyRedenvelopeList {
//    self.bidBuyMoneyLable.text = [NSString stringWithFormat:@"%d 元", [self.dict[@"buyMoney"] intValue]];
    self.bidTitleNameLabel.text = self.dict[@"bidName"];
    self.bidBuyMoneyLable.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:self.dict[@"buyMoney"]]];
    
    NSString *bid = @"";
    if (self.isOptimizationBid) {
        bid = @"apId";
    } else {
        bid = @"bid";
    }
 
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  bid: self.bidString,
                                  @"tenderAmount": self.dict[@"buyMoney"] };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/bidRedList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            NSArray *array = responseObject[@"data"];
            if ([dataArray count] > 0) {
                [dataArray removeAllObjects];
            }
            if ([array count] > 0) {
                for (int i = 0; i < [array count]; i++) {
                    myRedenvelopeModel *model = [[myRedenvelopeModel alloc] initWithmyRedenvelopeModel:[array objectAtIndex:i]];
                    [dataArray addObject:model];
                }
                //默认取第一个值
                redpackSource = [NSString stringWithFormat:@"%@",array[0][@"redpackSource"]];
            }
            self.isRequest = YES;
            [self.tableView reloadData];
        }
    }
        fail:^{

        }];
}

//支付定单  (此处是 账户余额够的情况下支付，所以不是要调用充值，故展示投标成功页面）
- (void)payOrder {
    if ([self isBlankString:getObjectFromUserDefaults(ACCESSTOKEN)] || [self isBlankString:getObjectFromUserDefaults(UID)]) {
        return;
    }
    NSString *bankId = @"";
    if (![_userInformationDict[@"bankId"] isEqual:[NSNull null]]) {
        bankId = [NSString stringWithFormat:@"%zd", [_userInformationDict[@"bankId"] integerValue]];
    }

    NSString *urlString = @"";
    if ([self.dict[@"bidType"] isEqualToString:@"优选计划"]) {
        urlString = @"bank/sdInvestBid";
    } else {
        urlString = @"bank/sdBid";//
    }
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID),
                                  @"bid": self.dict[@"bidID"],
                                  @"payPassword":[NetManager TripleDES:self.payPassWorldView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"tenderAmount": self.dict[@"buyMoney"],
                                  @"source": @"101",
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"bidPassword": [NetManager TripleDES:self.dict[@"bidPassword"] encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                  @"name": [self isBlankString:_userInformationDict[@"userName"]] ? @"" : _userInformationDict[@"userName"],
                                  @"id_no": [self isBlankString:_userInformationDict[@"idNumber"]] ? @"" : _userInformationDict[@"idNumber"],
                                  @"card_no": [self isBlankString:_userInformationDict[@"account"]] ? @"" : _userInformationDict[@"account"],
                                  @"bankId": bankId,
                                  @"rechargeAmount": @"0",
                                  @"recordId": self.recordId,
                                  @"redpackSource":redpackSource
    };
//     [self showInpayingLoadingView:self];  支付动画   暂不启用
     [self showWithDataRequestStatus:@"安全支付中..."];
    WS(weakSelf);
       [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@", GeneralWebsite, urlString] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf payOrder];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf payOrder];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                 [self hideInpayingLoadingView];支付动画   暂不启用
                [self dismissWithDataRequestStatus];
                WithDrawDetailsViewController *WithDrawDetailsView = [[WithDrawDetailsViewController alloc] initWithNibName:@"WithDrawDetailsViewController" bundle:nil];
                WithDrawDetailsView.payMonryString = self.dict[@"buyMoney"];
                WithDrawDetailsView.bidNameString = self.dict[@"bidName"];
                WithDrawDetailsView.pushNumber = 0;
                WithDrawDetailsView.titleString = @"投标申请";
                [self customPushViewController:WithDrawDetailsView customNum:0];
            } else {
//                [self hideInpayingLoadingView];支付动画   暂不启用
                [self dismissWithDataRequestStatus];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
        fail:^{
//            [self hideInpayingLoadingView];
            [self errorPrompt:3.0 promptStr:errorPromptString];
        }];
}

//获取用户信息（支付定单的时候需要）
- (void)getUserInformation {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
    };
    [self showWithDataRequestStatus:@"安全验证中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf getUserInformation];
            }
                withFailureBlock:^{

                }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf getUserInformation];
            }
                withFailureBlock:^{

                }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _userInformationDict = [responseObject[@"item"] copy];
                [self okThisOrderPayway];
            }
        } else {
            [self dismissWithDataRequestStatus];
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
        fail:^{
            [self dismissWithDataRequestStatus];
        }];
}

#pragma mark - remainingBalancePayViewDelegate
- (void)gotoPayButtonAction {
    if (!_isHavePayPassworld) {
        [self cancelButtonAction];
        setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
        setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
            if (ishavePW) {
                _isHavePayPassworld = YES;
            }
        };
        [self customPushViewController:setPaymentPassWorldView customNum:1];
    } else {
        [self cancelButtonAction];
        if ([self isLegalObject:_userInformationDict]) {
            [self okThisOrderPayway];
        } else {
            [self getUserInformation];
        }
    }
}

- (void)cancelButtonAction {
    [self dismissPopupController];
}

#pragma mark - XRPayPassWorldViewDelegate
- (void)sureTappend{//账户余额够输入支付密码代理
    [self.payPassWorldView.textField resignFirstResponder];
    if ([self isBlankString:self.payPassWorldView.textField.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入支付密码"];
    } else {
        [self dismissPopupController];
        [self payOrder];
    }
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
/* 无效
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //就唯一 textfiled
//    if (textField == _buyConfirmTextField) {
        NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.diKouMoneyLabel.text = [NSString stringWithFormat:@"%@",tempStr];
//    }
    return YES;
}
*/

#pragma mark - CustomUINavBarDelegate
- (void)goBack {
    [self customPopViewController:0];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"buyConfirmViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @" 使用红包";
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cell.textLabel setTextColor:[self colorFromHexRGB:@"3A3A3A"]];
    [cell.contentView addSubview:self.buyConfirmTextField];
    if (self.isRequest) {
        [self.getmyRedenvelopeLable removeFromSuperview];
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
        if ([dataArray count] == 0) {
            _buyConfirmTextField.placeholder = @"无可用红包";
            _diKouMoneyLabel.hidden = YES;//抵扣hideen
            _realDiKouLabel.hidden  = YES;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.tableView.userInteractionEnabled = YES;

            myRedenvelopeModel *model = [dataArray objectAtIndex:indexPath.row];
            if ([self.dict[@"buyMoney"] doubleValue] * model.RedenvelopeMaxRatio / 100 < [model.RedenvelopeMoney floatValue]) {
                self.DeductionMoney = [self.dict[@"buyMoney"] doubleValue] * model.RedenvelopeMaxRatio / 100;
            } else {
                self.DeductionMoney = [model.RedenvelopeMoney floatValue];
            }
            self.recordId = model.RedenvelopeID;
            [_buyConfirmTextField setTextColor:[self colorFromHexRGB:/*@"FA6522"*/@"3A3A3A"]];
            [_buyConfirmTextField setText:[NSString stringWithFormat:@"%@元红包", model.RedenvelopeMoney]];
            _diKouMoneyLabel.text  = [NSString stringWithFormat:@"%@元", model.RedenvelopeMoney];
            _diKouMoneyLabel.hidden = NO;//抵扣
            _realDiKouLabel.hidden  = NO;
        }
    }
    [self setCellSeperatorToLeft:cell];

    [self.DisplayLable setText:[NSString stringWithFormat:@"%.2f", self.DeductionMoney]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myRedenvelopeListViewController *myRedenvelopeListView = [[myRedenvelopeListViewController alloc] init];
    myRedenvelopeListView.dataArray = [dataArray copy];
    myRedenvelopeListView.block_RedenvelopeList = ^(NSDictionary *dict) {
        if ([self isLegalObject:dict]) {
            self.recordId = dict[@"RedenvelopeID"];
            [_buyConfirmTextField setText:[NSString stringWithFormat:@"%@元红包", dict[@"RedenvelopeMoney"]]];
            /*新增*/
            _diKouMoneyLabel.text = [NSString stringWithFormat:@"%@元", dict[@"RedenvelopeMoney"]];
            
            if ([self.dict[@"buyMoney"] doubleValue] * [dict[@"RedenvelopeMaxRatio"] floatValue] / 100 < [dict[@"RedenvelopeMoney"] floatValue]) {
                self.DeductionMoney = [self.dict[@"buyMoney"] doubleValue] * [dict[@"RedenvelopeMaxRatio"] doubleValue] / 100;
            } else {
                self.DeductionMoney = [dict[@"RedenvelopeMoney"] floatValue];
            }
            [self.DisplayLable setText:[NSString stringWithFormat:@"%.2f", self.DeductionMoney]];
            //传过来redpackSource值
            redpackSource = [NSString stringWithFormat:@"%@",dict[@"redpackSource"]];
        } else {
            self.recordId = @"";
            [_buyConfirmTextField setText:@"不使用红包"];
            /*新增*/
            _diKouMoneyLabel.text = @"0元";
            [self.DisplayLable setText:@"0.00"];
            self.DeductionMoney = 0.00;
        }
    };
    [self customPushViewController:myRedenvelopeListView customNum:0];
}

//确定支付方式（账户余额支付还是混合支付）
- (void)okThisOrderPayway {
    
    if ([_userInformationDict[@"status"] integerValue] != 1) {
        BindingBankCardViewController *bindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        bindingBankCardView.UserInformationDict = [_userInformationDict copy];
        bindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        bindingBankCardView.isRefresh = ^(BOOL isRefresh){
          
        };
        [self customPushViewController:bindingBankCardView customNum:0];
    }else{
        //替换下,
        NSString * userSurplusMoney = [self.dict[@"userSurplusMoney"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([userSurplusMoney doubleValue] + self.DeductionMoney >= [self.dict[@"buyMoney"] doubleValue]) {//账户余额直接支付
            self.payPassWorldView.textField.text = @"";
            [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPassWorldView];
        } else { //投标充值
            BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
            BindingBankCardView.payAounmtMoneyString = [NSString stringWithFormat:@"%.2f", [self.dict[@"buyMoney"] doubleValue]];
            BindingBankCardView.userMoney = userSurplusMoney;
            BindingBankCardView.bankPaymoney = [NSString stringWithFormat:@"%.2f", [self.dict[@"buyMoney"] doubleValue] - [userSurplusMoney doubleValue] - self.DeductionMoney];
            BindingBankCardView.productBID = self.dict[@"bidID"];
            BindingBankCardView.bidNameString = self.dict[@"bidName"];
            BindingBankCardView.bidPasswordString = self.dict[@"bidPassword"];
            BindingBankCardView.UserInformationDict = [_userInformationDict copy];
            BindingBankCardView.bankPayChannel = BankPayFromTender;
            BindingBankCardView.recordMoneyString = [NSString stringWithFormat:@"%.2f", self.DeductionMoney];
            if ([self.dict[@"bidType"] isEqualToString:@"优选计划"]) {
                BindingBankCardView.isOptimizationBid = YES;
            }
            BindingBankCardView.recordId = self.recordId;
            BindingBankCardView.redpackSource = redpackSource;
            [self customPushViewController:BindingBankCardView customNum:0];
        }
    }
}

#pragma mark - setters && getters
- (void)setUI {
    self.tableView.userInteractionEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    UIButton *button = (UIButton *) [self.view viewWithTag:1000];
    button.layer.cornerRadius = 5.0;

    self.bidName.text = self.dict[@"bidName"];
    self.balanceLable.text = [NSString stringWithFormat:@"%@ 元", self.dict[@"userSurplusMoney"]];
    self.bidBuyMoneyLable.text = [NSString stringWithFormat:@"%d 元", [self.dict[@"buyMoney"] intValue]];
    self.bidBuyMoneyLable.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:self.dict[@"buyMoney"]]];
    if ([self.dict[@"isHavePassWorld"] integerValue] == 1) {
        self.isHavePayPassworld = YES;
    }
}

- (UITextField *)buyConfirmTextField {
    if (!_buyConfirmTextField) {
        _buyConfirmTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPhoneWidth * 0.25, 0, iPhoneWidth * 0.75 - 40, 44)];
        [_buyConfirmTextField setTextAlignment:NSTextAlignmentRight];
        [_buyConfirmTextField setFont:[UIFont systemFontOfSize:15.0f]];
        [_buyConfirmTextField setUserInteractionEnabled:NO];
    }
    return _buyConfirmTextField;
}

- (XRPayPassWorldView *)payPassWorldView{
    if (!_payPassWorldView) {
        _payPassWorldView = [[XRPayPassWorldView alloc] init];
        _payPassWorldView.delegate = self;
    }
    [_payPassWorldView.textField becomeFirstResponder];

    return _payPassWorldView;
}

@end
