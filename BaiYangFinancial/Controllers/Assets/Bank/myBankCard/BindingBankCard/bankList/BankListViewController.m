//
//  BankListViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/4.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BankListViewController.h"

@interface BankListViewController (){
    NSString *_index;
}

@property (nonatomic, strong)NSArray *bankListArray;
@end

@implementation BankListViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self dismissWeidaiLoadAnimationView:self];
    [self hideMDErrorShowView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showWeidaiLoadAnimationView:self];
    CustomMadeNavigationControllerView *BankListView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"选择银行卡" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:BankListView];
    
    _index = @"NO";
    
//    if (!_bankListArray) {
//        //从plist文件中获取到存放银行卡信息的列表
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankListPlist" ofType:@"plist"];
//        _bankListArray = [NSArray arrayWithContentsOfFile:plistPath];
//        [_bankListArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//            if (*stop == NO) {
//                if ([obj[@"bankName"] isEqualToString:_bankName]) {
//                    _index = [NSString stringWithFormat:@"%zd",idx];
//                }
//            }
//        }];
//    }
    
    if ([_bankListArray count] == 0) {
        [self getBankListArrayRequest];
    }
}

- (void)getBankListArrayRequest{
    
    NSDictionary *parameters = @{@"uid" : getObjectFromUserDefaults(UID),
                                 @"sid" : getObjectFromUserDefaults(SID),
                                 @"bank": @"1",
                                 @"at"  : getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    NSString *url=[NSString stringWithFormat:@"%@user/getBankAccount",GeneralWebsite];
    [AFNetworkTool postJSONWithUrl:url parameters:parameters success:^(id responseObject) {
        
        if (responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getBankListArrayRequest];
        } withFailureBlock:^{
            
        }];
            }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getBankListArrayRequest];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                NSLog(@"bankList = %@",responseObject[@"bankList"]);
                _bankListArray = [responseObject[@"bankList"] copy];
                [_bankListArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    if (*stop == NO) {
                        if ([obj[@"name"] isEqualToString:_bankName]) {
                            _index = [NSString stringWithFormat:@"%zd",idx];
                        }
                    }
                }];
                [_bankListTableView reloadData];
                [self dismissWeidaiLoadAnimationView:self];
            }else{
                [self dismissWeidaiLoadAnimationView:self];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    } fail:^{
        [self dismissWeidaiLoadAnimationView:self];
        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:errorPromptString MDErrorShowViewType:NoData];
    }];
}

#pragma mark - UITableViewDataSourceAndUITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_bankListArray count] > 0) {
        return [_bankListArray count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bankList_id = @"BankListcell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankList_id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankList_id];
    }
    UIImage * bankImage = [UIImage imageNamed:[_bankListArray objectAtIndex:indexPath.row][@"bankNo"]];
    cell.imageView.image = bankImage?bankImage:[UIImage imageNamed:@"bank_icon_default"];
    cell.textLabel.text = [_bankListArray objectAtIndex:indexPath.row][@"name"];
    [self setCellSeperatorToLeft:cell];
    
    if (![_index isEqualToString:@"NO"]) {
        if ([_index intValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    // 选中操作
//    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    // 保存选中的
//    _index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    [self.bankListTableView reloadData];
//    NSLog(@"%@",[_bankListArray objectAtIndex:indexPath.row]);
//    [self goBack];
    [self customPopViewController:0];
    self.backBankDict((NSDictionary *)[_bankListArray objectAtIndex:indexPath.row]);
//    [self goBack];
}

#pragma mark - 返回方法代理的实现
- (void)goBack{
    [self customPopViewController:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
