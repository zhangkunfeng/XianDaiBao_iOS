//
//  SelfSetingViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/26.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "SelfSetingViewController.h"
#import "AutoBidViewController.h"
#import "BindingBankCardViewController.h"

@interface SelfSetingViewController ()
{
    //第一列数据
    NSMutableArray *_FirstcomponentArray;
    //第二列数据
    NSMutableArray *_SecondcomponentArray;
    //在此view上添加pickerView
    UIView *_backView;
    //单独添加取消和确定按钮的view
    UIView *_backBtnview;
    UIPickerView *_pickerView;
    NSDictionary *_accinfoDict;
    NSString *_firstComponet;
    NSString *_secondComponet;
    NSDictionary *_UserInformationDict;//用户信息
    
}
@end

@implementation SelfSetingViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"自动投标"];
    [AFNetworkTool cancelAllHTTPOperations];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"自动投标"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"自动投标" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
    [self.minAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    _FirstcomponentArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _SecondcomponentArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < 37; i++) {
        NSString *FirstcomponentString = [NSString stringWithFormat:@"%d",i];
        [_FirstcomponentArray addObject:FirstcomponentString];
    }
    
    for (int j = 1; j < 37; j++) {
        NSString *SecondcomponentString = [NSString stringWithFormat:@"%d",j];
        [_SecondcomponentArray addObject:SecondcomponentString];
    }
    [_SecondcomponentArray addObject:@"0"];
    
    
//    NSLog(@"%@",self.minMonthString);
//     NSLog(@"%@",self.maxMonthString);
//     NSLog(@"%@",self.minAmountString);
    //给月份赋值
    self.leftMonthLab.text = self.minMonthString; //self.minMonthString = 1个月
    self.rightMonthLab.text = self.maxMonthString;//self.maxMonthString = 3个月
    self.minAmount.text = self.minAmountString; //self.minAmountString = 467,834,567.00元
    
    if ([self isLegalObject:self.minMonthString]) {
        _firstComponet = [self.minMonthString substringWithRange:NSMakeRange(0, self.minMonthString.length - 2)];
        if ([self.leftMonthLab.text isEqualToString:@"不限"]) {
            _firstComponet = @"0";
        }
    }else{
        _firstComponet = @"0";
    }
    
    if ([self isLegalObject:self.maxMonthString]) {
        _secondComponet = [self.maxMonthString substringWithRange:NSMakeRange(0, self.maxMonthString.length - 2)];
        if ([self.rightMonthLab.text isEqualToString:@"不限"]) {
            _secondComponet = @"0";
        }
    }else{
        _secondComponet = @"1";
    }
    
}
//限制输入
- (void)textFieldDidChange:(UITextField *)textField
{
    
    
    if (textField == self.minAmount) {
        if (textField.text.length > 10) { //此时无,号  123322333  限1亿以下
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

#pragma mark - 点击屏幕让键盘下去
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self removeBackView];
    self.chooseMonthBtn.userInteractionEnabled = YES;
}
//TODO:页面返回按钮
- (void)goBack
{
    [self customPopViewController:0];
}
//TODO:选择月份按钮
- (IBAction)chooseMonth:(id)sender {
     _firstComponet = @"0";
    _secondComponet = @"1";
    _backView=[[UIView alloc] initWithFrame:CGRectMake(0, iPhoneHeight-162-35, iPhoneWidth,197)];
    _backBtnview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth,35)];
    _backBtnview.backgroundColor=[UIColor colorWithRed:215/255.0 green:240/255.0 blue:255/255.0 alpha:1.0];
    [_backView addSubview:_backBtnview];
    _pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,35, iPhoneWidth,162)];
    _pickerView.delegate=self;
    _pickerView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:_pickerView];
    [self.view addSubview:_backView];
    [self creatButton];
    
}
//TODO:创建取消确定按钮
- (void)creatButton{
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame=CGRectMake(20,8,50,20);
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTintColor:AppBtnColor];
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backBtnview addSubview:leftBtn];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.tag = 10086;
    [rightBtn setTintColor:AppBtnColor];
    rightBtn.frame=CGRectMake(iPhoneWidth-70,8,50,20);
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [rightBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [_backBtnview addSubview:rightBtn];
}
#pragma mark - UIPickerViewDataSoure
//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _FirstcomponentArray.count;
    }else{
        return _SecondcomponentArray.count;
    }
}
#pragma mark - UIPickerViewDelegate
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0){
        if ([[_FirstcomponentArray objectAtIndex:row] isEqualToString:@"0"] ) {
            return @"不限";
        }else{
            return [NSString stringWithFormat:@"%@个月",[_FirstcomponentArray objectAtIndex:row]];
        }
    }else if(component == 1){
        if ([[_SecondcomponentArray objectAtIndex:row] isEqualToString:@"0"] ) {
            return @"不限";
        }else{
            return [NSString stringWithFormat:@"%@个月",[_SecondcomponentArray objectAtIndex:row]];
        }
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            10086];
    btn.enabled = NO;
    if (component == 0) {
        _firstComponet = [_FirstcomponentArray objectAtIndex:row];
        if (row != 0) {
            _secondComponet = [_SecondcomponentArray objectAtIndex:row - 1];
            [pickerView selectRow:row-1 inComponent:1 animated:YES];//设置某列选择某行
        }
    }else{
        _secondComponet = [_SecondcomponentArray objectAtIndex:row];
        if ([_firstComponet integerValue] > [_secondComponet integerValue]) {
            if ([_secondComponet isEqualToString:@"0"]) {
                
            }else{
                _firstComponet = [_FirstcomponentArray objectAtIndex:row+1];
                [pickerView selectRow:row+1 inComponent:0 animated:YES];
            }
        }
    }
    if ([_firstComponet integerValue] <= [_secondComponet integerValue]) {
        btn.enabled = YES;
    }
    if ([_secondComponet integerValue] == 0){
        btn.enabled = YES;
    }
}

//TODO:取消按钮点击事件
- (void)cancelBtnClick{
    [self removeBackView];
}
//TODO:确定按钮点击事件
- (void)okBtnClick{
    if ([_firstComponet isEqualToString:@"0"]) {
        self.leftMonthLab.text = @"不限";
    }else{
        self.leftMonthLab.text = [NSString stringWithFormat:@"%@个月",_firstComponet];
    }
    if ([_secondComponet isEqualToString:@"0"]) {
        self.rightMonthLab.text = @"不限";
    }else{
        self.rightMonthLab.text = [NSString stringWithFormat:@"%@个月",_secondComponet];
    }
    
    [self removeBackView];
}
- (void)removeBackView{
    [_backView removeFromSuperview];
}
#pragma mark - 设置自动投标的时候先获取用户的信息
- (void)getMyBankCardinformation{
    [self okBtnClick];
    NSDictionary *parameters = @{@"uid":               getObjectFromUserDefaults(UID),
                                 @"sid":                getObjectFromUserDefaults(SID),
                                 @"state":              @"1",
                                 @"at":                 getObjectFromUserDefaults(ACCESSTOKEN)
                                 };
    [self showWithDataRequestStatus:@"设置中..."];
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getMyBankCardinformation];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getMyBankCardinformation];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                if ([responseObject[@"item"][@"realStatus"] integerValue] == 0) {
                    [self loadSaveData];
                }else{
                    [self dismissWithDataRequestStatus];
                    if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                        _UserInformationDict = [responseObject[@"item"] copy];
                        //没有认证过去认证
                        UIAlertView *exitAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"设置自动投标需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        [exitAlert show];
                    }
                }
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    } fail:^{
        [self errorPrompt:3.0 promptStr:@"设置失败，亲重试"];
    }];
}

#pragma mark - 加载保存修改数据
- (void)loadSaveData{
    [self.view endEditing:YES];
    
    if ([self isBlankString:self.leftMonthLab.text]) {
    }else if ([self isBlankString:self.rightMonthLab.text]){   
    }else{
        NSString *minAmountString = @"";
        if ([self.minAmount.text isEqualToString:@"不限"]) {
            minAmountString = @"0";
        }else{
//            NSLog(@"self.minAmount.text = %@",self.minAmount.text);
            NSString * minAmountText = [Number3for1 forDelegateChar:self.minAmount.text];
            minAmountString = [minAmountText substringWithRange:NSMakeRange(0, minAmountText.length - 1)];
        }
//        NSLog(@"1. minAmountString = %@",minAmountString);
        NSDictionary *parameters = @{
                                     @"uid":                    getObjectFromUserDefaults(UID),
                                     @"sid":                    getObjectFromUserDefaults(SID),
                                     @"at":                     getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"timeLimitMonthMin":      _firstComponet,
                                     @"timeLimitMonthMax":      _secondComponet,
                                     @"minAmount":              minAmountString,
                                     @"enabled":                _isOpenAutoBid,
                                     };
        WS(weakSelf);
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/setAutoBid",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadSaveData];
        } withFailureBlock:^{
            
        }];
                }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadSaveData];
                } withFailureBlock:^{
                    
                }];
                }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                    [self showWithSuccessWithStatus:@"设置成功"];
                    [self performSelector:@selector(goBack) withObject:nil afterDelay:3.0f];
                    //回调函数  修改上个界面的值   点击设置时回调传值
                    self.backAutoBidViewValue(_firstComponet,_secondComponet,minAmountString);
                }else{
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        } fail:^{
        }];
    }
}
//保存修改按钮
- (IBAction)saveButton:(id)sender {
    //如果最小金额为空，则保存修改时自动填入上次设置的金额
    if ([self isBlankString:self.minAmount.text]) {
//        NSLog(@"2. self.minAmount.text = %@",self.minAmount.text);//空
//         NSLog(@"5. self.minAmountString = %@",self.minAmountString);//54,643,654,344.00元
        NSString * minAmoutStringZ = [Number3for1 forDelegateChar:self.minAmountString];
        self.minAmount.text =[minAmoutStringZ substringWithRange:NSMakeRange(0, minAmoutStringZ.length - 1)];
    }
//    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"是否确定保存修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alertView show];
    
    [self getMyBankCardinformation];
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] initWithNibName:@"BindingBankCardViewController" bundle:nil];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh){
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != 0) {
//        [self loadSaveData];
//    }
//}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.chooseMonthBtn.userInteractionEnabled = NO;
    [self removeBackView];
//    NSLog(@"3. self.minAmount.text = %@",self.minAmount.text);//467,834,567.00元
    NSString * minAmountLabelText = [Number3for1 forDelegateChar:self.minAmount.text];
    if ([minAmountLabelText doubleValue] > 0) {
        NSString * minAmountString = [Number3for1 forDelegateChar:self.minAmount.text];
        self.minAmount.text = [NSString stringWithFormat:@"%.0f",[minAmountString doubleValue]];
    }else if ([_minAmountString isEqualToString:@"不限"]){
        self.minAmount.text = @"";
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.minAmount) {
        if([string isEqualToString:@"\n"]) {
            //按回车关闭键盘
            [textField resignFirstResponder];
            return NO;
        } else if(string.length == 0) {
            //判断是不是删除键
            return YES;
        } else if(textField.text.length >= 10) {
            //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
            NSLog(@"输入的字符个数大于6，忽略输入");
            return NO;
        } else if (![string  isEqual:@"0"] && ![string  isEqual:@"1"] && ![string  isEqual:@"2"] && ![string  isEqual:@"3"] && ![string  isEqual:@"4"] && ![string  isEqual:@"5"] && ![string  isEqual:@"6"] && ![string  isEqual:@"7"] && ![string  isEqual:@"8"] && ![string  isEqual:@"9"]) {
            return NO;
        } else {
            return YES;
        }
     
    }
    return YES;

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self isBlankString:textField.text]) {
        self.minAmount.text = _minAmountString;
    }else{
        if ([self.minAmount.text doubleValue] > 0) {
//            self.minAmount.text = [NSString stringWithFormat:@"%@元",self.minAmount.text];
//            NSLog(@"%@",self.minAmount.text); //467834567
            self.minAmount.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:self.minAmount.text]];
        }else{
            self.minAmount.text = @"不限";
        }
    }
}
@end
