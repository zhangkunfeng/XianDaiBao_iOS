//
//  AssetsRulesViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/3/7.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "AssetsRulesViewController.h"
#import "UITableView+CellHeightCache.h"

@interface AssetsRulesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _sectionArray;
    NSMutableArray *_allArray;//创建一个数据源数组
    NSMutableDictionary *dic; //创建一个字典进行判断收缩还是展开
}

@property (nonatomic,strong)UITableView *tableView;

@end
#define AssetsRulesVCText self.rulesType==AutoBidRulesType?@"自动投标规则":@"零钱计划规则"
@implementation AssetsRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomMadeNavigationControllerView *assetsRulesView = [[CustomMadeNavigationControllerView alloc] initWithTitle:AssetsRulesVCText showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:assetsRulesView];
    
    dic = [NSMutableDictionary dictionary];
   
    NSArray * sectionArray;
    NSMutableArray * allArray;
    if (self.rulesType == ChangeRulesType) {
        sectionArray = @[@"什么是零钱计划",
                         @"关于转入转出",
                         @"关于计划收益",
                         @"关于零钱提现"];
        
         allArray = [@[@[@"零钱计划是贤钱宝推出的一款小额理财产品，随存随取，方便灵活。"],
                       @[@"(1) 账户中的可用余额资金可以直接转入零钱计划;",
                         @"(2) 零钱计划一元起投,个人限额1万元;",
                         @"(3) 用户可以随时将资金转出零钱计划,转出后，资金实时到达账户余额;",
                         @"(4) 零钱计划的转入转出不收取任何费用;",
                         @"(5) 每日限转出一次。"],
                       @[@"(1) 零钱计划的年化收益为6.8%;",
                         @"(2) 资金转入零钱计划后,隔天开始计息;",
                         @"(3) 平台每日进行利息结算,利息每日自动转入零钱计划。"],
                       @[@"(1) 用户使用回款投资零钱计划时，提现不收取任何手续费;",
                         @"(2) 用户使用账户新增充值金额投资零钱计划满3天时，提现不收取任何手续费；不满3天将收取0.5%的手续费。(注：第三天18:00之后算满3天时间)。"]]mutableCopy];
        
    }else if (self.rulesType == AutoBidRulesType){
        sectionArray = @[@"什么是自动投标?"];
        
        allArray= [@[@[@"自动投标专为解放投资者的双手而生，一键轻松开启，畅享理财新风尚!",
                       @"(1) 用户开启此工具，并完成条件设置后，自动投标功能将即刻生效;",
                       @"(2) 当有新的借款项目上线时，系统会智能地第一时间帮用户进行投标，无需再进行手动操作;",
                       @"(3) 自动投标成交的金额为用户在“自动投标”设置的最大金额、可用余额和项目可投金额三者中的最小值;",
                       @"(4) 中标后当账户余额小于100元时，自动投标将重新排队，建议用户早作充值计划;",
                       @"(5) 账户余额大于或等于100元，且下限设置不大于账户余额，可保留排队;",
                       @"(6) 进行自动投标关闭后重新开启、修改期限设置、下限改小等操作将重新排队，自动投标开启中请谨慎修改。"]]mutableCopy];
    }
    
    _sectionArray = [NSArray arrayWithArray:sectionArray];
    _allArray     = [NSMutableArray arrayWithArray:allArray];
  
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHex:@"F6F7F8"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, iPhoneWidth-30, 47)];
    label.text = _sectionArray[section];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor colorWithHex:@"333333"];
    [view addSubview:label];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44.5, iPhoneWidth-30, 0.5)];
    
    [view addSubview:lineLabel];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth-55, 2.5, 40, 40)];
    btn.tag = 400+section;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    NSString *str = [NSString stringWithFormat:@"%d",(int)section];
    if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [btn setImage:[UIImage imageNamed:@"drop-down"] forState:UIControlStateNormal];
        lineLabel.backgroundColor = [UIColor clearColor];
    }else{//反之关闭cell
        [btn setImage:[UIImage imageNamed:@"shrinkage"] forState:UIControlStateNormal];
        lineLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2];
    }
    
//    //创建一个手势进行点击，这里可以换成button
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
//    view.tag = 300 + section;
//    [view addGestureRecognizer:tap];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc] init];
    UIColor * color;
    NSString *str = [NSString stringWithFormat:@"%d",(int)section];
    if (self.rulesType == AutoBidRulesType && [dic[str] integerValue] == 1) {
        color = [UIColor whiteColor];
    }else{
        if (self.rulesType == ChangeRulesType && section==3 && [dic[str] integerValue] == 1) {
            color = [UIColor whiteColor];
        }else{
        color = [UIColor colorWithHex:@"F6F7F8"];
        }
    }
    footerView.backgroundColor = color;
    return footerView;
}

- (void)btnClicked:(UIButton *)btn{
    NSString *str = [NSString stringWithFormat:@"%d",(int)(btn.tag-400)];
    btn.selected = !btn.selected;
    if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [dic setObject:@"1" forKey:str];
    }else{//反之关闭cell
        [dic setObject:@"0" forKey:str];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]] withRowAnimation:UITableViewRowAnimationAutomatic];//有动画的刷新
    
}

/* - (void)action_tap:(UIGestureRecognizer *)tap{
    NSString *str = [NSString stringWithFormat:@"%d",(int)(tap.view.tag - 300)];
    if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [dic setObject:@"1" forKey:str];
    }else{//反之关闭cell
        [dic setObject:@"0" forKey:str];
    }
    // [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]] withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([dic[string] integerValue] == 1) {  //打开cell返回数组的count
        NSArray *array = [NSArray arrayWithArray:_allArray[section]];
        return array.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = [tableView getCellHeightCacheWithCacheKey:_allArray[indexPath.section][indexPath.row]];
    NSLog(@"从缓存取出来图片高度的-----%f",cellHeight);
    
    if(!cellHeight){
        NSString * textStr = _allArray[indexPath.section][indexPath.row];
        CGSize lablesize = [self labelAutoCalculateRectWith:textStr FontSize:13.0 MaxSize:CGSizeMake(iPhoneWidth-40, MAXFLOAT)];
        cellHeight = lablesize.height+15;
        [tableView setCellHeightCacheWithCellHeight:cellHeight CacheKey:_allArray[indexPath.section][indexPath.row]];
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.numberOfLines = 0;
    [self setLabelSpace:cell.textLabel withValue:_allArray[indexPath.section][indexPath.row] withFont:[UIFont systemFontOfSize:13.0f]];
    cell.textLabel.textColor = [UIColor colorWithHex:@"666666"];
    
    return cell;
}

- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
