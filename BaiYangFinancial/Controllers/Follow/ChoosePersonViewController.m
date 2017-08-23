//
//  ChoosePersonViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/6.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ChoosePersonViewController.h"
#import "choosePersonTableViewCell.h"
#import "FollowViewDataManager.h"
#import "PersonEnveloperViewController.h"

#define ChoosePersonVCText @"选择领取人"
@interface ChoosePersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * followListTableView;
@property (nonatomic, strong) NSArray * lettersArray;
@property (nonatomic, strong) NSArray * friendsListArray;
@property (nonatomic, strong) NSArray * arraySectionTitle;
@property (nonatomic, assign) NSInteger colorIndex;

@end

@implementation ChoosePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self resetSideBack];
    _colorIndex = 0;

    CustomMadeNavigationControllerView *choosePersonView = [[CustomMadeNavigationControllerView alloc] initWithTitle:ChoosePersonVCText showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:choosePersonView];
    
    [self createTabeleView];
    [self getArraysForView];
//    [self fromFollowSendData];
}

- (void)getArraysForView
{
    self.lettersArray  = [[FollowViewDataManager manager] getLettersArray];
    self.friendsListArray  = [[FollowViewDataManager manager] getFollowsListArray];
    self.arraySectionTitle = [[FollowViewDataManager manager] getSectionTitleArray];
//    self.friendsListArray  = [NSArray array]; test nodata
    
    if (_friendsListArray.count > 0) {
        [_followListTableView reloadData];
    }else{
        [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) contentShowString:@"暂无好友数据" MDErrorShowViewType:NoData];
    }
}

- (void)createTabeleView
{
    _followListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
    _followListTableView.delegate   = self;
    _followListTableView.dataSource = self;
    //    _followListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _followListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
    //    _followListTableView.separatorColor = UIColorFromRGB(0xe6e6e6);//cell 线颜色
    [self.view addSubview:_followListTableView];
    
    if ([_followListTableView respondsToSelector:@selector(setSectionIndexColor:)]) {//索引
        _followListTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _followListTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _followListTableView.sectionIndexColor = [UIColor lightGrayColor];
    }
}

- (void)goBack{
    [self customPopViewController:0];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _friendsListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendsListArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    choosePersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[choosePersonTableViewCell MyFriendsTableViewCellID]];
    if (!cell) {
        cell = [choosePersonTableViewCell MyFriendsTableViewCell];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    NSArray * colorArray = [[NSArray alloc] initWithObjects:@"24c6d5",@"24a797",@"7cc653",@"fec92f",@"fd7344",@"28b6f6",@"6086eb",@"fea42c",@"926dd7",nil];
    _colorIndex=_colorIndex==9?0:_colorIndex;
    
    NSDictionary * dic = [NSDictionary dictionary];
    if ([_friendsListArray[indexPath.section] count] > 0) {
        dic = _friendsListArray[indexPath.section][indexPath.row];
    }
    
    if ([self isLegalObject:dic[@"bookName"]]) {
        cell.nameLab.text = [NSString stringWithFormat:@"%@",dic[@"bookName"]];
        cell.iconTitleLab.text = [cell.nameLab.text substringToIndex:1];
        cell.iconTitleLab.backgroundColor = [UIColor colorWithHexString:colorArray[_colorIndex]];
    }
    
    if ([self isLegalObject:dic[@"mobile"]]) {
        cell.phoneLab.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    }
    
    _colorIndex++;
    return cell;
}

//返回右边索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _lettersArray;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_arraySectionTitle.count > 0) {
        return _arraySectionTitle[section];
    }
    return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [choosePersonTableViewCell MyFriendsTableViewCellHeight];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary * dic = [NSDictionary dictionary];
    dic = _friendsListArray[indexPath.section][indexPath.row];
    self.selectPersonNameBlock([NSString stringWithFormat:@"%@",dic[@"bookName"]],
                               [NSString stringWithFormat:@"%@",dic[@"friendUid"]]);
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
