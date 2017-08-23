//
//  AssetDetailsViewController.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/21.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AssetDetailsViewController.h"
#import "AssetDetailsTableViewCell.h"
#import "myAssetTableViewCell.h"

@interface AssetDetailsViewController (){
    NSArray *_array;
    NSArray *_array1;
    NSArray *_array2;
}

@end

@implementation AssetDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *AutobidView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"总资产明细" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:AutobidView];
    
    _array=[[NSMutableArray alloc] initWithObjects:@"可用余额",@"可提现余额",@"投资冻结金额",@"待收总额",@"提现中金额",@"不可提现余额",nil];
    _array1=[[NSMutableArray alloc] initWithObjects:@"待收利息",@"已收利息",@"实际赚取",nil];
    _array2=[[NSMutableArray alloc] initWithObjects:@"投标奖励",@"债权差价",@"提前还款罚息收入",@"我的投资积分",nil];
}
//TODO:导航栏返回按钮
- (void)goBack{
    [self customPopViewController:0];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 6;
        }
            break;
        case 2:{
            return 3;
        }
            break;
        default:
            break;
    }
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier=@"cell";
    if (indexPath.section == 0) {
        myAssetTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil)
        {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"myAssetTableViewCell" owner:self options:nil] lastObject];
        }
        if ([self isLegalObject:_accinfoDict[@"amount"]]) {
//            cell.myAssetLab.text =[NSString stringWithFormat:@"%.2f",[_accinfoDict[@"amount"] doubleValue]];
            cell.myAssetLab.text = [Number3for1 formatAmount:_accinfoDict[@"amount"]];
        }else{
            cell.myAssetLab.text = @"0.00";
        }
        return cell;
    }else{
        AssetDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil)
        {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"AssetDetailsTableViewCell" owner:self options:nil] lastObject];
        }
        cell.topLine.hidden = YES;
        switch (indexPath.section) {
            case 1:{
                cell.titleLab.text=[_array objectAtIndex:indexPath.row];
                if (indexPath.row == 0) {
                    cell.topLine.hidden = NO;
                    //可用余额
                    if ([self isLegalObject:_accinfoDict[@"balance"]]) {
//                        cell.sumLab.text=[NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"balance"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"balance"]]];
                    }else{
                        cell.sumLab.text= @"";
                    }
                }else if (indexPath.row == 1){
                    //可提现余额 = 可提金额 - 可提冻结
                    NSString * useMoeny = [NSString stringWithFormat:@"%.2f",[_accinfoDict[@"availablecash"] doubleValue] - [_accinfoDict[@"availablefrozen"] doubleValue]];
                    cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:useMoeny]];
                }else if (indexPath.row == 2){
                    //投资冻结金额
                    if ([self isLegalObject:_accinfoDict[@"investment"]]) {
//                        cell.sumLab.text = [NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"investment"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"investment"]]];
                    }else{
                        cell.sumLab.text= @"";
                    }
                }else if (indexPath.row == 3){
                    //待收总额
                    if ([self isLegalObject:_accinfoDict[@"waitTotal"]]) {
//                        cell.sumLab.text = [NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"waitTotal"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"waitTotal"]]];
                    }else{
                        cell.sumLab.text= @"";
                    }
                }else if (indexPath.row == 4){
                    //提现中金额
                    if ([self isLegalObject:_accinfoDict[@"withdrawCashFrozen"]]) {
//                        cell.sumLab.text = [NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"withdrawCashFrozen"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"withdrawCashFrozen"]]];

                    }else{
                        cell.sumLab.text= @"";
                    }
                }else{
                    //不可提现余额 = 不可提金额 - 不可提冻结
                    NSString * noUseMoney = [NSString stringWithFormat:@"%.2f",[_accinfoDict[@"disabledcash"] doubleValue] - [_accinfoDict[@"withdrawfrozen"] doubleValue]];
                    cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:noUseMoney]];

                }
            }
                break;
            case 2:{
                cell.titleLab.text=[_array1 objectAtIndex:indexPath.row];
                if (indexPath.row == 0) {
                    cell.topLine.hidden = NO;
                    if ([self isLegalObject:_accinfoDict[@"accrual"]]) {
//                        cell.sumLab.text = [NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"accrual"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"accrual"]]];

                    }else{
                        cell.sumLab.text= @"";
                    }
                }else if (indexPath.row == 1){
                    if ([self isLegalObject:_accinfoDict[@"interestReceived"]]) {
//                        cell.sumLab.text = [NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"interestReceived"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"interestReceived"]]];

                    }else{
                        cell.sumLab.text= @"";
                    }
                    
                }else{
                    if ([self isLegalObject:_accinfoDict[@"totalEarning"]]) {
//                        cell.sumLab.text = [NSString stringWithFormat:@"%.2f元",[_accinfoDict[@"totalEarning"] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[@"totalEarning"]]];

                    }else{
                        cell.sumLab.text= @"";
                    }
                    if ([self isLegalObject:_accinfoDict[@"totalAdministrativeFee"]]) {
                        cell.totalEarning.text = [NSString stringWithFormat:@"( 管理费 %.2f元 )",[_accinfoDict[@"totalAdministrativeFee"] doubleValue]];
                    }else{
                        cell.totalEarning.text= @"";
                    }
                }
            }
                break;
            case 3:{
                if (indexPath.row == 0) {
                    cell.topLine.hidden = NO;
                }
//                                NSLog(@"%@",_accinfoDict);
                NSArray *FirstSectionarray=[[NSArray alloc] initWithObjects:@"totalActiveAmount",@"changeFee",@"totalYuqifaxiAmount", @"integaral",nil];
                NSString *str=[FirstSectionarray objectAtIndex:indexPath.row];
                //容错
                if ([self isLegalObject:_accinfoDict[str]]) {
                    
                    if (indexPath.row == 3) {
                        cell.sumLab.text = [NSString stringWithFormat:@"%@分",[Number3for1 formatAmount:_accinfoDict[str]]];
                    }else{
                        //                    cell.sumLab.text=[NSString stringWithFormat:@"%.2f元",[_accinfoDict[str] doubleValue]];
                        cell.sumLab.text = [NSString stringWithFormat:@"%@元",[Number3for1 formatAmount:_accinfoDict[str]]];
                    }
                }else{
                    
                    if ([_accinfoDict[str] isKindOfClass:[NSNull class]] && indexPath.row == 3) {
                        cell.sumLab.text = @"0.00分";
                    }else{
                    cell.sumLab.text= @"";
                    }
                }
                cell.titleLab.text=[_array2 objectAtIndex:indexPath.row];
            }
                break;
                
            default:
                break;
        }
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //分割线顶格
        [self setCellSeperatorToLeft:cell];
        return cell;
        
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
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

@end
