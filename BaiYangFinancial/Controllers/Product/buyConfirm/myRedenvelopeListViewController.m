//
//  myRedenvelopeListViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/17.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "CustomMadeNavigationControllerView.h"
#import "Masonry.h"
#import "RedenvelopeTableViewCell.h"
#import "XYErrorView.h"
#import "myRedenvelopeListViewController.h"
#import "myRedenvelopeModel.h"

@interface myRedenvelopeListViewController () <CustomUINavBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation myRedenvelopeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [self colorFromHexRGB:@"efefef"];
    CustomMadeNavigationControllerView *myRedenvelopeListView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"我的红包" showBackButton:YES showRightButton:YES rightButtonTitle:@"不使用" target:self];
    [self.view addSubview:myRedenvelopeListView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.top.equalTo(myRedenvelopeListView.mas_bottom).offset(0);
    }];
}

- (void)goBack {
    [self customPopViewController:0];
}

- (void)doOption {
    self.block_RedenvelopeList(nil);
    [self goBack];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedenvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RedenvelopeTableViewCell initWithRedenvelopeTableViewCellID]];
    if (cell == nil) {
        cell = [RedenvelopeTableViewCell initWithRedenvelopeTableViewCell];
    } else {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    myRedenvelopeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.SymbolLable.textColor = [self colorFromHexRGB:@"FA6522"];
    cell.userMoneyLable.textColor = [self colorFromHexRGB:@"FA6522"];
    cell.RedenvelopeName.text = model.RedenvelopeTitle;
    cell.overdueTimeLable.text = model.RedenvelopeTime;
    cell.minAmountLable.text = model.RedenvelopeMinAount;
    cell.deadlineLable.text = model.minDeadline;
//    cell.belielLable.text = [NSString stringWithFormat:@"抵扣比例：%.1f%%", model.RedenvelopeMaxRatio];
    
    //可用红包 无需考虑负数有效期  /*投标时候页面*/  非我的红包  后台没返回数据考虑0天处理
    if ([model.RedenvelopeEndTime isEqualToString:@""]) {
        cell.endTimeLabel.text = @"0天";
    }else{
     cell.endTimeLabel.text = [NSString stringWithFormat:@"%@天",model.RedenvelopeEndTime];//有效天数
    }
//    cell.userMoneyLable.text = [NSString stringWithFormat:@"%.2f", [model.RedenvelopeMoney doubleValue]];
    cell.userMoneyLable.text = [NSString stringWithFormat:@"%@", model.RedenvelopeMoney];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RedenvelopeTableViewCell initWithRedenvelopeTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    myRedenvelopeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *dict = @{ @"RedenvelopeMoney": model.RedenvelopeMoney,
                            @"Deduction": [NSString stringWithFormat:@"%.2f", [model.RedenvelopeMoney doubleValue] * model.RedenvelopeMaxRatio],
                            @"RedenvelopeID": model.RedenvelopeID,
                            @"RedenvelopeMaxRatio": [NSString stringWithFormat:@"%.2f", model.RedenvelopeMaxRatio],
                            @"RedenvelopeEndTime": model.RedenvelopeEndTime,
                            @"redpackSource":model.redpackSource};
    self.block_RedenvelopeList(dict);
    [self goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
