//
//  CheckNewMessageViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/15.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "CheckNewMessageViewController.h"
#import "SDRefresh.h"
#import "MyFriendsTableViewCell.h"

#define CheckMyNewMessageText @"查看我的消息"
@interface CheckNewMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * _acceptBtn; //接受
    UIButton * _refusedBtn;//拒绝
}
@property (nonatomic, strong) UITableView * MessageListTableView;
@property (nonatomic, strong) NSMutableArray * MessageListArray;//我的消息数组
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@end

@implementation CheckNewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self resetSideBack];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomMadeNavigationControllerView *addressBookView = [[CustomMadeNavigationControllerView alloc] initWithTitle:CheckMyNewMessageText showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:addressBookView];
    
    _MessageListArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createTabeleView];
    [self setupHeader];
    
    if (_MessageListArray.count == 0) {
        [_weakRefreshHeader beginRefreshing];
    }
}

#pragma mark - CustomUINavBarDelegate
- (void)goBack{
    [self customPopViewController:0];
}

- (void)createTabeleView
{
    _MessageListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
    _MessageListTableView.delegate   = self;
    _MessageListTableView.dataSource = self;
    // _MessageListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MessageListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
    //    _followListTableView.separatorColor = UIColorFromRGB(0xe6e6e6);//cell 线颜色
    [self.view addSubview:_MessageListTableView];
}

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_MessageListTableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self loadQueryAcceptFriendListData];
        });
    };
}

/**
 *  待接受邀请列表（搜索框界面）  
 *  返回值：[{‘bookName’:’姓名’,’mobile’,’手机号’,’uid’:’uid’,’friendUid’:’好友uid’}]
 *  `STATUS` varchar(1) DEFAULT NULL COMMENT '好友状态 1:请求验证 发起方状态，2：好友关系，3：删除关系，4:等待接受 接收方状态',

 r = 1,
	data = (
	{
	friendUid = 169326,
	status = 4,
	mobile = 15267314928,
	uid = 133195,
	bookName = 钱龙飞
 },
 
 */
- (void)loadQueryAcceptFriendListData
{
    NSDictionary * parameters = @{@"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid"  : getObjectFromUserDefaults(UID),};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/queryAcceptFriendList",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadQueryAcceptFriendListData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadQueryAcceptFriendListData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [_weakRefreshHeader endRefreshing];
                NSLog(@"待接受邀请列表 = %@",responseObject);
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray * array = responseObject[@"data"];
                    if (_MessageListArray.count > 0) {
                        [_MessageListArray removeAllObjects];
                    }
                    if (array.count > 0) {
                        for (id info in array) {
                            [_MessageListArray addObject:info];
                        }
                          [_MessageListTableView reloadData];
                    }else{
                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) contentShowString:@"暂无邀请消息" MDErrorShowViewType:NoData];
                    }
                  
                }
            } else {
                [_weakRefreshHeader endRefreshing];
                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)  contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }
    }
                              fail:^{
                                  [_weakRefreshHeader endRefreshing];
                                  [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];
                              }];
}
     
/**
 *  接受邀请接口
 *  返回值：{‘r’:’1’,’msg’:’信息’}
 */
- (void)loadAcceptInvitationDataWithBtnTag:(long)btnTag
{
    long indexPathRow = btnTag - 300;
    NSString * friendUidStr = [NSString stringWithFormat:@"%@",_MessageListArray[indexPathRow][@"friendUid"]];
    NSLog(@"friendUidStr = %@",friendUidStr);
    NSDictionary * parameters = @{@"at"   : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid"  : getObjectFromUserDefaults(UID),
                                  @"friendUid":friendUidStr };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/acceptFriend",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadAcceptInvitationDataWithBtnTag:btnTag];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadAcceptInvitationDataWithBtnTag:btnTag];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"接受邀请接口 = %@",responseObject);
                if ([responseObject[@"msg"] isEqualToString:@"成功"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFollowView object:nil];
                    [self loadQueryAcceptFriendListData];
                    [self errorPrompt:3.0 promptStr:@"添加好友成功！"];
                    //未取到
//                    UIButton * btn =  (UIButton *)[_acceptBtn viewWithTag:btnTag];
//                    [btn setTitle:@"添加成功" forState:UIControlStateNormal];
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _MessageListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[MyFriendsTableViewCell MyFriendsTableViewCellID]];
    if (!cell) {
        cell = [MyFriendsTableViewCell MyFriendsTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray * colorArray = [[NSArray alloc] initWithObjects:@"24c6d5",@"24a797",@"7cc653",@"fec92f",@"fd7344",@"28b6f6",@"6086eb",@"fea42c",@"926dd7",nil];
    
    NSDictionary * dic = [NSDictionary dictionary];
    if (_MessageListArray.count > 0) {
        dic = _MessageListArray[indexPath.row];
    }
    
    if ([self isLegalObject:dic[@"bookName"]]) {
        cell.titleNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"bookName"]];
        cell.userBronzeHeadLabelView.text = [cell.titleNameLabel.text substringToIndex:1];
        cell.userBronzeHeadLabelView.backgroundColor = [UIColor colorWithHexString:colorArray[indexPath.row%9]];
    }
    
    if ([self isLegalObject:dic[@"mobile"]]) {
        cell.detailPhoneLabel.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    }
    
    [self cellContentViewAddBtnsWithCell:cell andIndexPath:indexPath.row];
    
    return cell;
}

- (void)cellContentViewAddBtnsWithCell:(UITableViewCell *)cell andIndexPath:(NSInteger)indexPathRow
{
    //接受   待验证
    _acceptBtn = [[UIButton alloc] init];
    _acceptBtn.frame = CGRectMake(iPhoneWidth-90,(CGRectGetHeight(cell.contentView.frame)-30)/2, 70, 30);
    _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _acceptBtn.tag = indexPathRow + 300;
    [_acceptBtn setTitle:@"" forState:UIControlStateNormal];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_acceptBtn setBackgroundColor:AppBtnColor];
    [_acceptBtn addTarget:self action:@selector(cellAcceptBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:_acceptBtn];
    

    /*
     `STATUS` varchar(1) DEFAULT NULL COMMENT '好友状态 1:请求验证 发起方状态，2：好友关系，3：删除关系，4:等待接受 接收方状态',
     */
    NSInteger statusType = [_MessageListArray[indexPathRow][@"status"] integerValue];
    switch (statusType) {
        case 1:
            _acceptBtn.enabled = NO;
            [_acceptBtn setTitle:@"等待验证" forState:UIControlStateNormal];
            _acceptBtn.backgroundColor = [UIColor clearColor];
            break;
        case 2:
            _acceptBtn.hidden = YES;
//            [_acceptBtn setTitle:@"已是好友" forState:UIControlStateNormal];
            break;
        case 3:
            //删除关系
            _acceptBtn.hidden = YES;
            break;
        case 4:
            [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    /*拒绝
    _refusedBtn = [[UIButton alloc] init];
    _refusedBtn.frame = CGRectMake(iPhoneWidth-150,CGRectGetMinY(_acceptBtn.frame), 50, 30);
    [_refusedBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    _refusedBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _refusedBtn.tag = indexPathRow+400;
    [_refusedBtn setTitleColor:[UIColor colorWithHexString:@"877D7D"] forState:UIControlStateNormal];
    [_refusedBtn setBackgroundColor:[UIColor colorWithHexString:@"FFC305"]];
    [_refusedBtn addTarget:self action:@selector(cellRefusedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:_refusedBtn];*/
}

//接受
- (void)cellAcceptBtnClicked:(UIButton *)acceptBtn
{
    [self loadAcceptInvitationDataWithBtnTag:acceptBtn.tag];
}
/*拒绝
- (void)cellRefusedBtnClicked:(UIButton *)refusedBtn
{
    NSLog(@"我点击了拒绝");
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return [MyFriendsTableViewCell MyFriendsTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
