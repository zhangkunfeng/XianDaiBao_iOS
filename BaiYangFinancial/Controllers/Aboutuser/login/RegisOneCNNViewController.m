//
//  RegisOneCNNViewController.m
//  BaiYangFinancial
//
//  Created by 民华 on 2017/6/29.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "RegisOneCNNViewController.h"
#import "VerificationiPhoneCodeViewController.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@interface RegisOneCNNViewController ()

//宣传图片  新手注册图片
@property (weak, nonatomic) IBOutlet UIImageView *PropagandaImage;



@end

@implementation RegisOneCNNViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pushviewNumber = 0;
        _remainTime = GetCodeMaxTime;
    }
    return self;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进来就获取焦点
    //    [self.iPhoneNumberTextField becomeFirstResponder];
    //    self.iPhoneNumberTextField.layer.borderWidth = 1.0f;
    //    self.iPhoneNumberTextField.layer.borderColor = LineBackGroundColor.CGColor;
    [self talkingDatatrackPageBegin:@"注册"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self dismissWithDataRequestStatus];
    [self talkingDatatrackPageEnd:@"注册"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iPhoneNumberTextField.text = _telePhone;
   [self.iPhoneNumberTextField addTarget:self action:@selector(textFieldChandeT:) forControlEvents:UIControlEventEditingChanged];
    
    //下载图片
    [self downloadView];
    
    
    NSString *titleStr = @"";
    if (self.pushviewNumber == 2) {
        titleStr = @"绑定手机号码";
        self.PropagandaImage.hidden = YES;
        self.WeidaiProtocolButton.hidden = YES;
    }else{
        titleStr = @"登录、注册";
    }
    
    CustomMadeNavigationControllerView *VerificationView = [[CustomMadeNavigationControllerView alloc] initWithTitle:titleStr showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:VerificationView];

    [self setiphoneNumber];
    
}

-(void)downloadView{

    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/queryList?at=%@&type=11", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = (NSArray *) data;
                if (dataArray.count > 0) {
                    NSDictionary * dict = dataArray.firstObject;
                    if ([self isLegalObject:dict[@"path"]]) {
                        [self.PropagandaImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"path"]]] placeholderImage:[UIImage imageNamed:@"注册1_03.png"]];//占位图xib已携带 可删
                    }else{
                        self.PropagandaImage.image = [UIImage imageNamed:@"注册1_03.png"];
                    }
                }
            }
            
        }else{
            self.PropagandaImage.image = [UIImage imageNamed:@"注册1_03.png"];
        }
    }
                              fail:^{
                                  self.PropagandaImage.image = [UIImage imageNamed:@"注册1_03.png"];
                              }];

    
}

-(void)setiphoneNumber{
    UIImageView *UserNameleftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_REGISTER_PHONE]];
    self.iPhoneNumberTextField.leftView = UserNameleftImageView;
    self.iPhoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;

}

NSInteger j;


-(void)textFieldChandeT:(UITextField *)textField
{
    if (textField == self.iPhoneNumberTextField) {
        
        if (textField.text.length > j) {
            if (textField.text.length == 4 || textField.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length-1)];
                textField.text = str;
            }if (textField.text.length >= 13 ) {//输入完成
                textField.text = [textField.text substringToIndex:13];
                //                [textField resignFirstResponder];
            }
            j = textField.text.length;
        }else if (textField.text.length < j){//删除
            if (textField.text.length == 4 || textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            j = textField.text.length;
        }
        
    }

}
#pragma mark - 点击屏幕空白区域收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)goBack{
    [self.view endEditing:YES];
    
    if (self.pushviewNumber == 10086) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SendToMyAssets object:nil];
    }
    if (self.pushviewNumber == 1234) {
        //没必要再请求 发送通知
        [self customPopViewController:0];
        return;
    }
    
    if (self.pushviewNumber == 888) {  //首页返回处理
        [self customPopViewController:0];
        return;
    }
    
    if (self.pushviewNumber == 0) {  //首页cell值异常
        [self customPopViewController:0];
        return;
    }
    
    [self customPopViewController:3];

    
   }
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = AppMianColor.CGColor;
    //    if (![self isBlankString:textField.text]) {
    //        [self ShowiPhoneNumberLableHeight];
    //    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = LineBackGroundColor.CGColor;
    //    [self dismissiPhoneNumberLableHeight];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self VerifiIphone];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.showiPhoneNumberLable.text = nil;
    return YES;
}

- (void)dismissiPhoneNumberLableHeight{
    [UIView animateWithDuration:0.5 animations:^{
        self.isShowiPhoneNumberLableHeight.constant = 0;
        self.showiPhoneNumberLable.hidden = YES;
        [self.view layoutIfNeeded];
    }];
}

- (void)ShowiPhoneNumberLableHeight{
    
    if (self.isShowiPhoneNumberLableHeight.constant < 40) {
        self.isShowiPhoneNumberLableHeight.constant += 2;
        [NSTimer scheduledTimerWithTimeInterval: 0.1/40
                                         target:self
                                       selector:@selector(ShowiPhoneNumberLableHeight)
                                       userInfo:nil
                                        repeats:NO];
    }else if(self.isShowiPhoneNumberLableHeight.constant == 40){
        self.showiPhoneNumberLable.hidden = NO;
        [self.view layoutIfNeeded];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)VerificationiPhoneButtonAction:(id)sender {
    [self VerifiIphone];
}

-(void)VerifiIphone{
    [self.iPhoneNumberTextField resignFirstResponder];
    NSString * phoneStr = [self clearPhoneNumerSpaceWithString:self.iPhoneNumberTextField.text];
    if (self.pushviewNumber == 2) {
        if ([self isBlankString:phoneStr]) {
            [self errorPrompt:3.0 promptStr:@"请输入手机号码/用户名"];
        }
        else if (![self isLegalNum:phoneStr]){
            [self errorPrompt:3.0 promptStr:@"手机号错误"];
        }
        else{
            [self gotoVerifyIphoneView:@"1"];
        }
    }else{//登录走下面
        if ([self isBlankString:phoneStr]) {
            [self errorPrompt:3.0 promptStr:@"请输入手机号码/用户名"];
        }else{
            self.getCodeButton.enabled = NO;
            [self showWithDataRequestStatus:@"加载中..."];
            WS(weakSelf);
            NSString * phoneStr = [self clearPhoneNumerSpaceWithString:self.iPhoneNumberTextField.text];
            NSDictionary *parameters = @{@"at":   getObjectFromUserDefaults(ACCESSTOKEN),
                                         @"mobile": phoneStr
                                         };
            [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/writeMobile",GeneralWebsite] parameters:parameters success:^(id responseObject) {
                if (![self isBlankString:responseObject[@"r"]]) {
                    if ([[responseObject objectForKey:@"r"] integerValue] > 0) {
                        if ([[responseObject objectForKey:@"r"] integerValue] == 1) {
                            if (![self isLegalNum:phoneStr]) {
                                self.getCodeButton.enabled = YES;
                                [self errorPrompt:3.0 promptStr:@"请使用正确地手机号码注册"];
                            }else{
                                [self gotoVerifyIphoneViewOne:[responseObject objectForKey:@"r"]];
                            }
                        }else if([responseObject[@"r"] integerValue] == 2){ //正常登录走
                            
                            
                            NSLog(@"已注册 ");
                            [self dismissWithDataRequestStatus];
                            self.getCodeButton.enabled = YES;
                            //[self gotoVerifyIphoneView:[responseObject objectForKey:@"r"]];
                        }else if ([responseObject[@"r"] integerValue] == 3){
                            self.getCodeButton.enabled = YES;
                            [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
                        }
                    }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                        [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                            [weakSelf VerifiIphone];
                        } withFailureBlock:^{
                            
                        }];
                    }else{
                        self.getCodeButton.enabled = YES;
                        [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
                    }
                }
            } fail:^{
                self.getCodeButton.enabled = YES;
                [self showErrorViewinMain];
            }];
        }
    }


}

-(void)gotoVerifyIphoneViewOne:(NSString *)valueStr{

    if ([valueStr isEqualToString:@"1"]) {
        [self dismissWithDataRequestStatus];
        self.getCodeButton.enabled = YES;
        VerificationiPhoneCodeViewController *VerificationCode = [[VerificationiPhoneCodeViewController alloc] initWithNibName:@"VerificationiPhoneCodeViewController" bundle:nil];
        VerificationCode.iphoneNumberString =[self clearPhoneNumerSpaceWithString: self.iPhoneNumberTextField.text];
        VerificationCode.timeout = _remainTime;
        if (self.pushviewNumber == 2) {
            VerificationCode.isBindingiPhone = YES;
            VerificationCode.loginName = _loginName;
        }
        VerificationCode.isFindPassworld = 0;
       [self customPushViewController:VerificationCode customNum:0];
    }else{
    
        self.getCodeButton.enabled = YES;
        [self dismissWithDataRequestStatus];
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginView.pushviewNumber = self.pushviewNumber;
        loginView.iPhoneNumberString = [self clearPhoneNumerSpaceWithString:self.iPhoneNumberTextField.text];
        [self customPushViewController:loginView customNum:0];

    }
    
}


-(void)gotoVerifyIphoneView:(NSString *)valueStr{
    if ([valueStr isEqualToString:@"1"]) {//进入注册流程   下面else进登录
        NSDictionary *parameters = @{@"at":         getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"mobile":     [self clearPhoneNumerSpaceWithString:self.iPhoneNumberTextField.text]
                                     };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/getSmsCode",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf gotoVerifyIphoneView:valueStr];
                    } withFailureBlock:^{
                        
                    }];
                }else if ([[responseObject objectForKey:@"r"] isEqualToString:verificationOK]) {
                    [self dismissWithDataRequestStatus];
                    self.getCodeButton.enabled = YES;
                    VerificationiPhoneCodeViewController *VerificationCode = [[VerificationiPhoneCodeViewController alloc] initWithNibName:@"VerificationiPhoneCodeViewController" bundle:nil];
                    VerificationCode.iphoneNumberString =[self clearPhoneNumerSpaceWithString: self.iPhoneNumberTextField.text];
                    VerificationCode.timeout = _remainTime;
                    if (self.pushviewNumber == 2) {
                        VerificationCode.isBindingiPhone = YES;
                        VerificationCode.loginName = _loginName;
                    }
                    VerificationCode.isFindPassworld = 0;
//                    VerificationCode.BackTimeNumber = ^(int TimeNumber){
//                        _remainTime = TimeNumber;
//                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//                        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//                        dispatch_source_set_event_handler(_timer, ^{
//                            if(_remainTime <= 0){ //倒计时结束，关闭
//                                //结束后重新复制
//                                _remainTime = GetCodeMaxTime;
//                                dispatch_source_cancel(_timer);
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    //设置界面的按钮显示 根据自己需求设置
//                                    [_getCodeButton setTitle:@"点击发送验证码" forState:UIControlStateNormal];
//                                    _getCodeButton.userInteractionEnabled = YES;
//                                    [_getCodeButton setBackgroundColor:AppBtnColor];
//                                });
//                            }else{
//                                //            int minutes = timeout / 60;
//                                int seconds = _remainTime % 600;
//                                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    //设置界面的按钮显示 根据自己需求设置
//                                    [_getCodeButton setTitle:[NSString stringWithFormat:@"(%@s)重新获取验证码",strTime] forState:UIControlStateNormal];
//                                    _getCodeButton.userInteractionEnabled = NO;
//                                    [_getCodeButton setBackgroundColor:LineBackGroundColor];
//                                });
//                                _remainTime--;
//                            }
//                        });
//                        dispatch_resume(_timer);
//                    };
                    [self customPushViewController:VerificationCode customNum:0];
                }else{
                    self.getCodeButton.enabled = YES;
                    [self errorPrompt:3.0 promptStr:[responseObject objectForKey:@"msg"]];
                    
                }
            }
        } fail:^{
            [self dismissWithDataRequestStatus];
            self.getCodeButton.enabled = YES;
            [self showErrorViewinMain];
            
        }];
    }else{//正常登录步骤
        self.getCodeButton.enabled = YES;
        [self dismissWithDataRequestStatus];
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginView.pushviewNumber = self.pushviewNumber;
        loginView.iPhoneNumberString = [self clearPhoneNumerSpaceWithString:self.iPhoneNumberTextField.text];
        [self customPushViewController:loginView customNum:0];
    }

}

#pragma mark ----获得手机客户端ip地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


@end
