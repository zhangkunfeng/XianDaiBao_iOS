//
//  FinancialRuleViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/23.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "FinancialRuleViewController.h"

@interface FinancialRuleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * financialRuleTableView;

@end

#define FinancialRuleViewText @"贤钱宝理财师规则说明"
@implementation FinancialRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomMadeNavigationControllerView *financialRuleView = [[CustomMadeNavigationControllerView alloc] initWithTitle:FinancialRuleViewText showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:financialRuleView];
    
    [self createView];
    
//    [self createTableView];
    
}

- (void)createView
{
    float scale = 7859/1242;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];
    scrollView.contentSize = CGSizeMake(iPhoneWidth,iPhoneWidth*scale);
    [self.view addSubview:scrollView];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneWidth*scale)];
    imageV.image =[UIImage imageNamed:@"理财师规则6P"];
    [scrollView addSubview:imageV];
}

- (void)createTableView
{
    _financialRuleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth/*&0*/, iPhoneHeight - 64)];
    _financialRuleTableView.delegate   = self;
    _financialRuleTableView.dataSource = self;
    _financialRuleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_financialRuleTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableViewID = @"aboutFinancialRuleTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewID];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     UIImageView * imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"理财师规则6P"]];
    return imageV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float scale = 7859/1242;
    return iPhoneWidth*scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
