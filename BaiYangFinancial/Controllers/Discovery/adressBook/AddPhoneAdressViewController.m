//
//  AddPhoneAdressViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/25.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "AddPhoneAdressViewController.h"
//#import "MyInviteHongBaoViewController.h"
#import "BYInviteEnvelopeViewController.h"
#import "AddressBookCell.h"
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"


//#define kColor [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
#define AddPhoneAdressTitleText @"添加手机联系人"

@interface AddPhoneAdressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *addPhoneTableView;
@property (strong, nonatomic) UIImageView *noFriendsView;
@property (copy,   nonatomic) NSDictionary * searchDict;
@property (strong, nonatomic) UIView * InviteView;
@property (assign, nonatomic) BOOL isShowViewCount;
@property (nonatomic, strong) UIAlertView * bankAlertView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *NavigationView;

- (IBAction)backBtnClicked:(id)sender;

@end

@implementation AddPhoneAdressViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:AddPhoneAdressTitleText];
    //移除错误界面
    [self hideMDErrorShowView:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:AddPhoneAdressTitleText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavigationViewOthers];
    [self.view addSubview:self.addPhoneTableView];
    [self.view addSubview:self.noFriendsView];
    [self.view addSubview:self.InviteView];
//    [self setTheGradientWithView:self.NavigationView];
    _searchDict = [NSDictionary dictionary];
}

- (void)settingNavigationViewOthers
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.searchTextField.tintColor = [UIColor whiteColor];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号搜索" attributes:attributes];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];//限制输入
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.searchTextField) {
        [_noFriendsView removeFromSuperview];
        if (textField.text.length < 11) {
            //暂且不弄
        }
        
        if ([textField.text isEqualToString:getObjectFromUserDefaults(MOBILE)]) {
            [self errorPrompt:3.0 promptStr:@"自己手机号无法查看哦"];
        }
        
        if ((textField.text.length > 11 || textField.text.length == 11 ) && ![textField.text isEqualToString:getObjectFromUserDefaults(MOBILE)]) {
            textField.text = [textField.text substringToIndex:11];
            [self loadData];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchTextField resignFirstResponder];
}

//点击 done 触发事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ([textField.text doubleValue] == 0) {
        [self errorPrompt:3.0 promptStr:@"请输入手机号搜索"];
        return 0;
    }
    if (textField.text.length < 11) {
       [self errorPrompt:3.0 promptStr:@"请输入11位手机号"];
        return 0;
    }
    if ([textField.text isEqualToString:getObjectFromUserDefaults(MOBILE)]) {
        [self errorPrompt:3.0 promptStr:@"自己手机号无法查看哦"];
        return 0;
    }
    
    [self loadData];
    
    return YES;
}

/**
 *  检索手机号 查找要添加的好友接口
 */
- (void)loadData
{
    NSDictionary * parameters = @{@"uid"  : getObjectFromUserDefaults(UID),
                                  @"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"mobile" : self.searchTextField.text};
    NSLog(@"%@",parameters);
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/queryMobile",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadData];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadData];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    NSLog(@"添加手机联系人返回数据 = %@",responseObject);
                    if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]){
                        _searchDict = [responseObject[@"item"] copy];
                        _InviteView.hidden = YES;
                        _addPhoneTableView.hidden = NO;
                        [_addPhoneTableView reloadData];
                    }else{//搜索不到情况下
                        _InviteView.hidden = NO;
                        _addPhoneTableView.hidden = YES;
                    }
                } else {
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        }
                                  fail:^{
                                      [self errorPrompt:3.0 promptStr:errorPromptString];
                                  }];
    

}

- (UITableView *)addPhoneTableView {
    if (!_addPhoneTableView) {
        _addPhoneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) style:UITableViewStylePlain];
//        _addPhoneTableView.backgroundColor = kColor;
        _addPhoneTableView.backgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        _addPhoneTableView.delegate = self;
        _addPhoneTableView.dataSource = self;
        _addPhoneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
    }
    return _addPhoneTableView;
}

- (UIImageView *)noFriendsView {
    if (!_noFriendsView) {
        _noFriendsView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_addPhoneTableView.frame)-111)/2, (iPhoneHeight-64-111-25)/2, 111, 111)];
        imageV.image = [UIImage imageNamed:@"NoData"];
        [_noFriendsView addSubview:imageV];
        
        UILabel * label = [[UILabel alloc ] initWithFrame:CGRectMake(CGRectGetMinX(imageV.frame), CGRectGetMaxY(imageV.frame) + 10, 111, 25)];
        label.text = @"还没有好友哦";
        [_noFriendsView addSubview:label];
    }
    return _noFriendsView;
}

- (UIView *)InviteView
{
    if (!_InviteView) {
        _InviteView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, iPhoneWidth, 50)];
        _InviteView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InviteViewTapLater:)];
        [_InviteView addGestureRecognizer:tap];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, iPhoneWidth-20, 50)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0f];
        NSString * str = @"TA还不是贤钱宝用户,邀请 TA 一起来理财,获得红包奖励.";
        [self AttributedString:str andTextColor:[UIColor blueColor] andTextFontSize:15.0f AndRange:11 withlength:12 AndLabel:label];
        _InviteView.hidden = YES;
        [_InviteView addSubview:label];
    }
    return _InviteView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchDict.count ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:[AddressBookCell AdressBookTableViewID]];
    if (!cell) {
        cell = [AddressBookCell AdressBookTableViewCell];
    }
    
    [cell.AddBtn addTarget:self action:@selector(cellStatusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.AddBtn setTitle:@"添加" forState:UIControlStateNormal];
    if ([self isLegalObject:_searchDict[@"bookName"]]) {
        cell.NameLabel.text = [NSString stringWithFormat:@"%@", _searchDict[@"bookName"]];
        cell.IconLabel.text = cell.NameLabel.text.length>0?[cell.NameLabel.text substringToIndex:1]:@"-";
    }
    cell.MobileLabel.text = [NSString stringWithFormat:@"%@",[self isLegalObject:_searchDict[@"mobile"]]?_searchDict[@"mobile"]:@"-"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AddressBookCell AdressBookTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)cellStatusBtnClicked:(UIButton*)btn
{
    [self goToNextAddFriendsInterfaceWithBtn:btn];
}

/**
 *  请求加为好友接口
 */
- (void)goToNextAddFriendsInterfaceWithBtn:(UIButton *)btn
{
    NSString * friendMobile = _searchDict[@"mobile"] ? _searchDict[@"mobile"] : @"";
    
    NSDictionary * parameters = @{@"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid"  : getObjectFromUserDefaults(UID),
                                  @"friendMobile" : friendMobile, };
//    NSLog(@"%@",parameters);
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/followFriend",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf goToNextAddFriendsInterfaceWithBtn:btn];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf goToNextAddFriendsInterfaceWithBtn:btn];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                //返回值：{‘r’:’1’,’msg’:’信息’}
                NSLog(@"提交后台返回数据 = %@",responseObject);
                
                [btn setEnabled:NO];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setTitle:@"等待验证" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (void)InviteViewTapLater:(UITapGestureRecognizer *)tap
{
    [self isBingBankForHoneBaoViewController];
}

- (IBAction)backBtnClicked:(id)sender {
    [self customPopViewController:0];
}

#pragma mark - 邀请送红包 按钮 请求判断
- (void)isBingBankForHoneBaoViewController
{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    [self showWithDataRequestStatus:@"获取中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/shareUrl", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
//            MyInviteHongBaoViewController * invite = [[MyInviteHongBaoViewController alloc] init];
//            [self customPushViewController:invite customNum:0];
            
            BYInviteEnvelopeViewController * invite = [[BYInviteEnvelopeViewController alloc] init];
            [self customPushViewController:invite customNum:0];
            
        } else if ([responseObject[@"r"] isEqualToString:@"-9"]) {
            [self dismissWithDataRequestStatus];
            _bankAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邀请好友理财需要实名认证,请实名认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上绑卡", nil];
            [_bankAlertView show];
        }else if([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf isBingBankForHoneBaoViewController];
            } withFailureBlock:^{
                
            }];
        }else if([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf isBingBankForHoneBaoViewController];
            } withFailureBlock:^{
                
            }];
        }else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self showErrorViewinMain];
                              }];
}

#pragma mark - UIAlertViewDelegate
//邀请红包专用alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == _bankAlertView && buttonIndex != 0) {
        NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                      @"sid": getObjectFromUserDefaults(SID),
                                      @"state": @"1",
                                      @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
        [self showWithDataRequestStatus:@"获取信息中..."];
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
                BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
                BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
                BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
                    
                };
                BindingBankCardView.UserInformationDict = (NSDictionary *) [responseObject[@"item"] copy];
                [self customPushViewController:BindingBankCardView customNum:0];
            } else {
                [self dismissWithDataRequestStatus];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
                                  fail:^{
                                      [self dismissWithDataRequestStatus];
                                      [self errorPrompt:3.0 promptStr:errorPromptString];
                                  }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
