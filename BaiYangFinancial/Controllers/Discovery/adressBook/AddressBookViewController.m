//
//  AddressBookViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/24.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "AddressBookViewController.h"
#import <AdSupport/AdSupport.h> //获取设备号
#import "AddressBookCell.h"
#import "SXAddressBookManager.h"
//#import "MyInviteHongBaoViewController.h"
#import "BYInviteEnvelopeViewController.h"
@import Contacts;
@interface AddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * adressBookArray;//通讯录数组
@property (nonatomic, strong) NSMutableArray * arrayLetters; //索引
@property (nonatomic, strong) NSMutableArray * arraySectionTitle; //标题

@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, strong) NSArray<SXPersonInfoEntity *>*personEntityArray;
@property (nonatomic, strong) NSMutableArray * adressBookArray_background;//通讯录数组(后台)
@property (nonatomic, strong) NSMutableArray * adressBookArray_cell;//通讯录数组(cell)
@property (nonatomic, copy)   NSString *jsonAdressBookArrayStirng;//json 类型字符串传后台
@end
#define AdressBookTitleText @"查看手机通讯录"
@implementation AddressBookViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:AdressBookTitleText];
    [self hideMDErrorShowView:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:AdressBookTitleText];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _colorIndex = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
    
    CustomMadeNavigationControllerView *addressBookView = [[CustomMadeNavigationControllerView alloc] initWithTitle:AdressBookTitleText showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:addressBookView];
    
    _adressBookArray = [NSMutableArray arrayWithCapacity:0];//关键 否则不存值
    _adressBookArray_background  = [NSMutableArray arrayWithCapacity:0];
    _adressBookArray_cell  = [NSMutableArray arrayWithCapacity:0];

    
    [self createTabeleView];
    
    [self checkStatusAndReadData];
}


- (void)initArray
{
    _adressBookArray_cell = [NSMutableArray arrayWithCapacity:0];
    _arrayLetters = [NSMutableArray arrayWithCapacity:0];
    
    [_arrayLetters addObject:@"☆"];
    for (NSInteger i = 'A'; i <= 'Z' + 1; i++) {
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        [_adressBookArray_cell addObject:arr];
        if (i <= 'Z') {
            [_arrayLetters addObject:[NSString stringWithFormat:@"%c",(char)i]];
        }
    }
    [_arrayLetters addObject:@"#"];
    
    _arraySectionTitle = [NSMutableArray arrayWithCapacity:0];
}


/**
 *  询问并读取本地通讯录
 */
- (void)checkStatusAndReadData
{
    [[SXAddressBookManager manager]checkStatusAndDoSomethingSuccess:^{
        NSLog(@"已经有权限，做相关操作，可以做读取通讯录等操作");
        
        self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
        for (SXPersonInfoEntity * person in self.personEntityArray) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            NSString * mobileStr = person.mobile?
            [self searchReplaceRemoveClippingOperationForPhoneNumStr:person.mobile]:@"";
            [dic setObject: @"2"     forKey:@"status"];
            [dic setObject:mobileStr forKey:@"mobile"];
            [dic setObject:person.bookName ? person.bookName : @"" forKey:@"bookName"];
            [dic setObject:person.mobileId ? person.mobileId : @"" forKey:@"mobileId"];
            [_adressBookArray addObject:dic];
        }
        [self  queryAdressBookDataToBackGround];//查询通讯录数据
    }
           failure:^{
               NSLog(@"未得到权限，做相关操作，可以做弹窗询问等操作");
               [self alertViewToUserSetting];
           }];
}

- (void)alertViewToUserSetting
{
    if (iOS7) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否前往【设置】->【贤钱宝】-> 打开通讯录功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        //初始化提示框；
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否前往【设置】->【贤钱宝】-> 打开通讯录功能" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //跳转到本应用设置页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
           
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
     [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"请前往【设置】->【贤钱宝】-> 打开通讯录功能" MDErrorShowViewType:NoData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        //跳转到本应用设置页面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
- (void)createTabeleView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {//索引
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = [UIColor lightGrayColor];
    }
}

/**
 *  1. 查询通讯录列表接口
 */
- (void)queryAdressBookDataToBackGround
{
    NSDictionary * parameters = @{@"uid"  : getObjectFromUserDefaults(UID),
                                  @"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                        /*设备号*/ @"imei" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],};
    WS(weakSelf);
    [self showWithDataRequestStatus:@"加载中"];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/queryFriendList",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf queryAdressBookDataToBackGround];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf queryAdressBookDataToBackGround];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"查询通讯录返回数据 = %@",responseObject);
                [self dismissWithDataRequestStatus];
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]
                    && [self isLegalObject:responseObject[@"data"]]) {
//                    NSArray * array = responseObject[@"data"];
                    //1.将所有原始，存到临时变量 tempArr中
                    NSMutableArray * tempArr = [responseObject[@"data"] copy];
                    if (tempArr.count > 0) {
                        [self initArray];
                        [self parseData:tempArr];
                        
                        for (id info in tempArr) {
                            [_adressBookArray_background addObject:info];
                        }
                        if (!getArrayFromUserDefaults(@"_adressBookArray_background")) {
                            saveArrayToUserDefaults(_adressBookArray_background, @"_adressBookArray_background");
                        }else{
                            NSArray * userDefaultsArray =getArrayFromUserDefaults(@"_adressBookArray_background");
                            if (_adressBookArray_background.count != userDefaultsArray.count) {
                                removeArrayFromUserDefaults(@"_adressBookArray_background");
                                saveArrayToUserDefaults(_adressBookArray_background, @"_adressBookArray_background");
                            }
                        }
                        [self JudgeWhetherTheDataISChanged];//判断数据是否更改
                        
                    }else{
                        if (_adressBookArray.count > 0) {
                            NSData *data=[NSJSONSerialization dataWithJSONObject:_adressBookArray options:NSJSONWritingPrettyPrinted error:nil];
                            _jsonAdressBookArrayStirng=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            [self uploadDataToBackGround];
                            
                        }else{
                            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"暂无通讯录数据" MDErrorShowViewType:NoData];
                        }
                    }
                    
                  
                 /*   if (array.count > 0) {
                        for (id info in array) {
                            [_adressBookArray_background addObject:info];
                        }
                        if (!getArrayFromUserDefaults(@"_adressBookArray_background")) {
                            saveArrayToUserDefaults(_adressBookArray_background, @"_adressBookArray_background");
                        }else{
                            NSArray * userDefaultsArray =getArrayFromUserDefaults(@"_adressBookArray_background");
                            if (_adressBookArray_background.count != userDefaultsArray.count) {
                                removeArrayFromUserDefaults(@"_adressBookArray_background");
                                saveArrayToUserDefaults(_adressBookArray_background, @"_adressBookArray_background");
                            }
                        }
                        [self JudgeWhetherTheDataISChanged];//判断数据是否更改
                        [_tableView reloadData];
                    }else{
                        if (_adressBookArray.count > 0) {
                            NSData *data=[NSJSONSerialization dataWithJSONObject:_adressBookArray options:NSJSONWritingPrettyPrinted error:nil];
                            _jsonAdressBookArrayStirng=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            [self uploadDataToBackGround];
                            
                        }else{
                            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"暂无通讯录数据" MDErrorShowViewType:NoData];
                        }
                    }*/
                }
            } else {
                [self dismissWithDataRequestStatus];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
                              }];
}

- (void)parseData:(NSMutableArray *)tempArray
{
    //2.遍历 herosArr，按照title进行排序
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * dic = (NSDictionary  *) obj;
        NSLog(@"%@",dic);
        NSString * headStr = [self getFirstLetterFromString:dic[@"bookName"]];
        NSLog(@"%@",headStr);
        if ([headStr isEqualToString:@"#"]) {
            [_adressBookArray_cell[26] addObject:obj];
        }else{
            unichar headC = [headStr characterAtIndex:0];
            NSLog(@"%hu",headC);
            NSInteger index = headC - 'A';
            [_adressBookArray_cell[index] addObject:obj];
        }
    }];
    
    //3.处理空数组问题
    [_adressBookArray_cell removeObject:[NSMutableArray array]];
    
    //    4. 对table  header 处理  取分组首字母
    [_adressBookArray_cell enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * arr = (NSMutableArray  *) obj;
        NSDictionary * dic = [arr firstObject];
        NSLog(@"%@",dic);
        NSString * headStr = [self getFirstLetterFromString:dic[@"bookName"]];
        NSLog(@"%@",headStr);
        [_arraySectionTitle addObject:headStr];
    }];
    [self hideMDErrorShowView:self];
    [_tableView reloadData];

}

/**
 *  2. 手机通讯录首次上传接口
 */
- (void)uploadDataToBackGround
{
    NSDictionary * parameters = @{@"uid"  : getObjectFromUserDefaults(UID),
                                  @"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                       /*设备号*/  @"imei" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                  @"mobileBook" : _jsonAdressBookArrayStirng,                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/uploadData",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf uploadDataToBackGround];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf uploadDataToBackGround];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"上传通讯录返回数据 = %@",responseObject);
                [self queryAdressBookDataToBackGround];//查询通讯录
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

//判断数据更改
- (void)JudgeWhetherTheDataISChanged
{
     /*后台&本地对比*/  /*status 1.新增 2.修改 3.删除*/
    NSArray * userDefaultsAdressArray = getArrayFromUserDefaults(@"_adressBookArray_background") ? getArrayFromUserDefaults(@"_adressBookArray_background") : nil;
    
    /*删除*/
    NSPredicate * delegatePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",_adressBookArray];
    NSArray * reslutDelegateArray = [userDefaultsAdressArray filteredArrayUsingPredicate:delegatePredicate];//userDefaultArray 除去_adressBookArray中的数据
    NSMutableArray * delegateArray = [NSMutableArray arrayWithCapacity:0];
    if (reslutDelegateArray.count > 0) {
        for (NSInteger i = 0; i < reslutDelegateArray.count; i++) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[reslutDelegateArray objectAtIndex:i]];
            [dict setValue:@"3" forKey:@"status"];
            [delegateArray addObject:dict];
        }
        //后续再传
//        [self sendDataToBackstageChangeData:delegateArray WithTypeStatus:@"3"];
    }
    
    /*新增&修改*/ /*一级筛选*/
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",userDefaultsAdressArray];
    NSArray * reslutFilteredArray = [_adressBookArray filteredArrayUsingPredicate:filterPredicate];
    if (reslutFilteredArray.count > 0) {
        
        /*二级筛选*/ /*修改*/
        NSMutableArray * updateArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < userDefaultsAdressArray.count; i++) {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"mobileId = %@",userDefaultsAdressArray[i][@"mobileId"]];
            for (NSDictionary *dic in reslutFilteredArray) {
                if([predicate evaluateWithObject:dic])
                {
                    [updateArray addObject:dic];
                }
            }
        }
        
        /*三级筛选*/ /*新增*/
        NSPredicate * newAddPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",updateArray];//筛选条件
        NSArray * newAddArray = [reslutFilteredArray filteredArrayUsingPredicate:newAddPredicate];
        
        //通讯录数据新增或修改接口
        if (updateArray.count > 0) {
//            for (NSInteger i = 0; i < updateArray.count; i++) {  //默认2
//                 [updateArray[i] setValue:@"2" forKey:@"status"];//同上同下
//            }
            [self sendDataToBackstageChangeData:updateArray WithTypeStatus:@"2"];
        }
        
        if (newAddArray.count > 0) {
            NSMutableArray * addArray = [NSMutableArray arrayWithCapacity:0];
            for (NSInteger i = 0; i < newAddArray.count; i++) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[newAddArray objectAtIndex:i]];
                [dict setValue:@"1" forKey:@"status"];
                [addArray addObject:dict];
//   [newAddArray[i] setValue:@"1" forKey:@"status"]; //安全期间不用（暂无发现问题）
            }
            [self sendDataToBackstageChangeData:addArray WithTypeStatus:@"1"];
        }
        NSLog(@"新增 = %@",newAddArray);
        NSLog(@"修改 = %@",updateArray);
    }
    NSLog(@"删除 = %@",delegateArray);
}

//数组转 JSON 字符串 上传后台
- (NSString *)arrayChangeJSONStringSendTobackctageWithArray:(NSArray *)changeArray
{
    NSData * data = [NSJSONSerialization dataWithJSONObject:changeArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

/**
 *  3. 通讯录数据新增或修改接口
 */
- (void)sendDataToBackstageChangeData:(NSArray *)changeData  WithTypeStatus:(NSString *)status
{
    
    /*转 JSON 格式字符串上传后台*/
    NSData *data=[NSJSONSerialization dataWithJSONObject:_adressBookArray options:NSJSONWritingPrettyPrinted error:nil];
    _jsonAdressBookArrayStirng=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString * jsonChangeArrayString = [self arrayChangeJSONStringSendTobackctageWithArray:changeData];
  
    /**
     *  status 1:新增 2:修改，
     *  imei   设备号
     */
    NSDictionary * parameters = @{@"uid"    : getObjectFromUserDefaults(UID),
                                  @"at"     : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"status" : status,
                                  @"imei"   : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                  @"mobileBook" : jsonChangeArrayString,                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/updateOrInsertMoblieFriendData",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf uploadDataToBackGround];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf uploadDataToBackGround];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"-新增/修改- 返回数据 = %@",responseObject);
                //做实时更新再处理
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _adressBookArray_cell.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_adressBookArray_cell[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:[AddressBookCell AdressBookTableViewID]];
    if (!cell) {
        cell = [AddressBookCell AdressBookTableViewCell];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /**
     *  状态 1：添加 2：邀请 3：已添加 4:等待验证
     */
    [cell.AddBtn addTarget:self action:@selector(addressBookcellStatusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *Dict = nil;
    
    if ([_adressBookArray_cell[indexPath.section] count] > 0) {
        Dict = _adressBookArray_cell[indexPath.section][indexPath.row];
    }
    
    NSArray * colorArray = [[NSArray alloc] initWithObjects:@"24c6d5",@"24a797",@"7cc653",@"fec92f",@"fd7344",@"28b6f6",@"6086eb",@"fea42c",@"926dd7",nil];
    _colorIndex=_colorIndex==9?0:_colorIndex;
    
    if ([self isLegalObject:Dict[@"bookName"]]) {
        cell.NameLabel.text = [NSString stringWithFormat:@"%@",Dict[@"bookName"]];
        cell.IconLabel.text = [self isBlankString:cell.NameLabel.text]?
                              @"#":[cell.NameLabel.text substringToIndex:1];
        cell.IconLabel.backgroundColor = [UIColor colorWithHexString:colorArray[_colorIndex]];
    }
    
    if ([self isLegalObject:Dict[@"mobile"]]) {
        cell.MobileLabel.text = [NSString stringWithFormat:@"%@",Dict[@"mobile"]];
    }
    
    if ([Dict[@"status"] intValue] > 0) {
        switch ([Dict[@"status"] intValue]) {
            case 1:
                [cell.AddBtn setTitle:@"添加" forState:UIControlStateNormal];
                [cell.AddBtn setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
                break;
            case 2:
                [cell.AddBtn setTitle:@"邀请" forState:UIControlStateNormal];
                break;
            case 3:
            {
                [cell.AddBtn setEnabled:NO];
                [cell.AddBtn setBackgroundColor:[UIColor clearColor]];
                [cell.AddBtn setTitle:@"已添加" forState:UIControlStateNormal];
                [cell.AddBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [cell.AddBtn.layer setBorderColor:[UIColor clearColor].CGColor];
            }
            case 4:
            {
                [cell.AddBtn setEnabled:NO];
                [cell.AddBtn setBackgroundColor:[UIColor clearColor]];
                [cell.AddBtn setTitle:@"等待验证" forState:UIControlStateNormal];
                [cell.AddBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [cell.AddBtn.layer setBorderColor:[UIColor clearColor].CGColor];

            
            }
                break;
            default:
                break;
        }
    }
     _colorIndex++;
    return cell;
}

//返回右边索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _arrayLetters;
}

//索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self errorPrompt:.5 promptStr:title];
    
    NSInteger count = 0;
    for(NSString *character in _arraySectionTitle)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return count;//还是上次 count 位置 (无)
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 25)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, iPhoneWidth-35, 25)];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.backgroundColor = [UIColor clearColor];
    label.text = _arraySectionTitle.count>0?_arraySectionTitle[section]:@"";
    [headerView addSubview:label];
    
    return headerView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (_arraySectionTitle.count > 0) {
//        return _arraySectionTitle[section];
//    }
//    return @"";
//}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AddressBookCell AdressBookTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)addressBookcellStatusBtnClicked:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"添加"]) {
        [btn setBackgroundColor: [UIColor colorWithHexString:@"e5e5e5"]];
        [self goToNextAddFriendsInterfaceWithBtn:btn];
    }
    
    if ([btn.titleLabel.text isEqualToString:@"邀请"]) {
        [self goToInvitationToSendEnvelopePage];
    }
    
    if ([btn.titleLabel.text isEqualToString:@"已添加"]) {
      // null
    }
    if ([btn.titleLabel.text isEqualToString:@"等待验证"]) {
      // null
    }
}

/**
 *  4.请求加为好友接口
 */
- (void)goToNextAddFriendsInterfaceWithBtn:(UIButton *)btn
{
    //首先获得Cell：button的父视图是contentView，再上一层才是UITableViewCell
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    //然后使用indexPathForCell方法，就得到indexPath了~
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSDictionary * Dict = _adressBookArray_cell.count>0 ? _adressBookArray_cell[indexPath.section][indexPath.row] : nil;
    NSString * friendMobile = Dict[@"mobile"] ? Dict[@"mobile"] : @"";
    
    NSDictionary * parameters = @{@"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid"  : getObjectFromUserDefaults(UID),
                                  @"friendMobile" : friendMobile, };
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
                NSLog(@"请求加好友返回数据 = %@",responseObject);
                
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

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)getFirstLetterFromString:(NSString *)aString
{
    if ([self isBlankString:aString]) {
        return @"#";
    }
    
    if ([[aString substringToIndex:1] isEqualToString:@"沈"]) {
        return @"S";
    }
    
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [pinyinString capitalizedString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
}

- (void)goToInvitationToSendEnvelopePage
{
//    MyInviteHongBaoViewController * invite = [[MyInviteHongBaoViewController alloc] init];
//    [self customPushViewController:invite customNum:0];
    BYInviteEnvelopeViewController * invite = [[BYInviteEnvelopeViewController alloc] init];
    [self customPushViewController:invite customNum:0];
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
