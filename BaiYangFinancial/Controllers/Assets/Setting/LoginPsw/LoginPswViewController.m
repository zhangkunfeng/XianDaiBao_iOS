//
//  LoginPswViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "LoginPswViewController.h"

@interface LoginPswViewController ()

@end

@implementation LoginPswViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self resetSideBack];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"登录密码修改" showBackButton:YES showRightButton:YES rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
    [self.oldPassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.NewpassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.againPassworldTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField //限制输入
{
    if  (textField == self.oldPassworldTF
        |textField == self.NewpassworldTF
        |textField == self.againPassworldTF)
    {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
        
    }
    // Check for total length
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 20) {
        return NO;//限制长度
    }
    return YES;
    

}


//TODO:返回按钮
- (void)goBack{
    [self customPopViewController:0];
}
//TODO:保存按钮
- (IBAction)SaveButton:(id)sender {
    if ([self isBlankString:self.oldPassworldTF.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入原密码"];
    }else if ([self isBlankString:self.NewpassworldTF.text]){
        [self errorPrompt:3.0 promptStr:@"请输入新密码"];
    }else if (self.NewpassworldTF.text.length < 6){
        [self errorPrompt:3.0 promptStr:@"新密码不少于6位"];
    }else if (self.NewpassworldTF.text.length > 20){
        [self errorPrompt:3.0 promptStr:@"新密码不多于20位"];
    }else if (![self.NewpassworldTF.text isEqualToString:self.againPassworldTF.text]){
        [self errorPrompt:3.0 promptStr:@"两次输入不一致"];
    }else if ([self.oldPassworldTF.text isEqualToString:self.NewpassworldTF.text]){
        [self errorPrompt:3.0 promptStr:@"不能和原密码一致"];
    }else{
        [self saveLoginPassworld];
    }
}

- (void)saveLoginPassworld{
    [self.view endEditing:YES];
    NSDictionary *parameters = @{@"uid":          getObjectFromUserDefaults(UID),
                                 @"sid":          getObjectFromUserDefaults(SID),
                                 @"at":           getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"newpassword": /* [WDEncrypt md5FromString:self.NewpassworldTF.text] */   [NetManager TripleDES:self.NewpassworldTF.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 @"oldpassword":  /*[WDEncrypt md5FromString:self.oldPassworldTF.text]*/ [NetManager TripleDES:self.oldPassworldTF.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],
                                 @"tag":          [WDEncrypt base64EncodedStringFromString:self.NewpassworldTF.text]
                                 };
    //加载动画
    WS(weakSelf);
    [self showWithDataRequestStatus:@"设置密码中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/modifyPwd",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf saveLoginPassworld];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
               [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf saveLoginPassworld];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self showWithSuccessWithStatus:@"登录密码修改成功"];
                
                removeObjectFromUserDefaults(UID);
                removeObjectFromUserDefaults(SID);
                removeObjectFromUserDefaults(gestureFinalSaveKey);
                removeObjectFromUserDefaults(InviteCode);
                //            self.exitLogin(YES);
                [self customPopViewController:3];
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginBackMainView object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscoveryView object:@"退出刷新发现"];
                
                [self performSelector:@selector(goBack) withObject:nil afterDelay:3.0f];
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:@"设置失败，请重试"];
        
    }];
}

//TODO:点击屏幕让键盘下去
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
