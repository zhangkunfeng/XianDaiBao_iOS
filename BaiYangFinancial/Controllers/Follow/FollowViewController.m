//
//  FollowViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/26.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "FollowViewController.h"
#import "SDRefresh.h"
#import "PinYinForObjc.h"
#import "FFDropDownMenuView.h"
#import "FollowViewDataManager.h"
#import "MyFriendsTableViewCell.h"
#import "HomeNotifyAndAdressAlertView.h"
#import "AddPhoneAdressViewController.h" //添加朋友
#import "AddressBookViewController.h"    //查看手机通讯录
#import "CheckNewMessageViewController.h"//查看我的消息
#import "ChooseEnveloperTypeViewController.h"//选择红包
#import "setPaymentPassWorldViewController.h"
#import "BindingBankCardViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "NewDiscoveryViewController.h"

#define FriendsListTitleText @"好友列表"

@interface FollowViewController () <UITableViewDelegate,UITableViewDataSource,HomeNotifyAndAdressAlertViewDelegate, UISearchBarDelegate>

/** 下拉菜单 */
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;
@property (nonatomic, strong) HomeNotifyAndAdressAlertView *addAdressBookAlertVC;
@property (nonatomic, strong) UITableView * followListTableView;
@property (nonatomic, strong) NSMutableArray * friendsListArray;//我的好友数组
@property (nonatomic, strong) NSMutableArray * arrayLetters; //索引
@property (nonatomic, strong) NSMutableArray * arraySectionTitle; //标题
@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, strong) UIAlertView * envelopeAlert;
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, copy) NSString * message_Total;
@property (nonatomic, copy) NSDictionary * UserInformationDict;

@property (weak, nonatomic) IBOutlet UIView *NavigationView;
@property (weak, nonatomic) IBOutlet UIButton *addFirendsBtn;
- (IBAction)addFirendsBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isHaveData;
@property (nonatomic, strong) NSString *msgString;
@property (nonatomic, strong) NewDiscoveryViewController *discoveryViewController;


@end

@implementation FollowViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //   [self hideMDErrorShowView:self];//点击功能键会移除返回没有
    [self talkingDatatrackPageEnd:FriendsListTitleText];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadVerifyMessageNumData];
    [self talkingDatatrackPageBegin:FriendsListTitleText];
}

//解决APP界面卡死Bug
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self forbiddenSideBack];
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _colorIndex = 0;
//    [self setTheGradientWithView:self.NavigationView];
    saveObjectToUserDefaults(@"YES",SHOWFOLLOWALERT);
    //    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4F5F6"]; 不明
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshFollowData:) name:RefreshFollowView object:nil];//刷新
    
    /** 初始化下拉菜单 **/
    [self setupDropDownMenu]; //会触发reloadData
    [self createTabeleView];
    //  [self initArray];
    [self setupHeader];
    [self viewDidCurrentView];
    self.searchBar.delegate = self;
    [self resetSideBack];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:getObjectFromUserDefaults(MOBILE)]) {
        [self errorPrompt:3.0 promptStr:@"自己手机号无法查看哦"];
    }
    if ((searchBar.text.length > 11 || searchBar.text.length == 11 ) && ![searchBar.text isEqualToString:getObjectFromUserDefaults(MOBILE)]) {
        searchBar.text = [searchBar.text substringToIndex:11];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length < 11) {
        //暂且不弄
    }
    
}// called when keyboard search button pressed


- (void)freshFollowData:(NSNotification *)notifity
{
//    [self hideMDErrorShowView:self];
    [self viewDidCurrentView];
}

- (void)initArray
{
    _friendsListArray = [NSMutableArray arrayWithCapacity:0];
    _arrayLetters = [NSMutableArray arrayWithCapacity:0];
    
    [_arrayLetters addObject:@"☆"];
    for (NSInteger i = 'A'; i <= 'Z' + 1; i++) {
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        [_friendsListArray addObject:arr];
        if (i <= 'Z') {
            [_arrayLetters addObject:[NSString stringWithFormat:@"%c",(char)i]];
        }
    }
    [_arrayLetters addObject:@"#"];
    
    _arraySectionTitle = [NSMutableArray arrayWithCapacity:0];
}

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_followListTableView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_arrayLetters removeAllObjects];
            [_arraySectionTitle removeAllObjects];
            [_friendsListArray removeAllObjects];
            [self initArray];
            [self loadData];
            [self loadVerifyMessageNumData];
        });
    };
}

- (void)createTabeleView
{
    _followListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45, iPhoneWidth, iPhoneHeight - 64 - 45)];
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
    [_followListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalCell"];
    _followListTableView.backgroundColor = [UIColor colorWithHex:@"f7f7f7"];
    
}

/**
 *  查看待验证信息条数
 */
- (void)loadVerifyMessageNumData
{
    WS(weakSelf);
    if (![self isBlankString:getObjectFromUserDefaults(SID)] && ![self isBlankString:getObjectFromUserDefaults(UID)]) {
        NSDictionary * parameters = @{@"uid"  : getObjectFromUserDefaults(UID),
                                      @"at"   : getObjectFromUserDefaults(ACCESSTOKEN)};
        
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/friendSmsCount",GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadVerifyMessageNumData];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadVerifyMessageNumData];
                    } withFailureBlock:^{
                        
                    }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    NSLog(@"查看待验证信息条数返回数据 = %@",responseObject);
                    
                    /*测试数据
                     self.roundLabel.hidden = NO;//本VC+圆点
                     self.dropdownMenu.menuViewTotal = [NSString stringWithFormat:@"%u",arc4random()%10+1];
                     NSLog(@"好友页面随机生成的消息条数 = %@", self.dropdownMenu.menuViewTotal);
                     [[NSNotificationCenter defaultCenter] postNotificationName:isHidenFollowAddMessageRedDot object:[NSString stringWithFormat:@"%u",arc4random()%10+1]];*/
                    
                    _message_Total =[NSString stringWithFormat:@"%@", responseObject[@"item"]];
                    self.dropdownMenu.menuViewTotal = _message_Total;//init 方法
                    /*由于dropdownMenu属性传值 只能传成功一次(cell只加载一次）辅以通知传搞定*/
                    [[NSNotificationCenter defaultCenter] postNotificationName:isHidenFollowAddMessageRedDot object:_message_Total];
                    self.roundLabel.hidden = [responseObject[@"item"] integerValue]>0 ?NO:YES;//本VC+圆点
                    
                    
                } else {
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        }
                                  fail:^{
                                      [self errorPrompt:3.0 promptStr:errorPromptString];
                                  }];
    }
}

/**
 *  好友查询列表
 */
- (void)loadData
{
    _colorIndex = 0;
    NSDictionary * parameters = @{@"uid"  : getObjectFromUserDefaults(UID),
                                  @"at"   : getObjectFromUserDefaults(ACCESSTOKEN)};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@mobileBook/queryFriendRealtionList",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"提交后台联系人返回数据 = %@",responseObject);
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [self isLegalObject:responseObject[@"data"]]) {
                    
                    //1.将所有原始，存到临时变量 tempArr中
                    NSMutableArray * tempArr = [responseObject[@"data"] copy];
                    if (tempArr.count > 0) {
                        _isHaveData = YES;
                        [self parseData:tempArr];
                    }else{
//                        [self hideMDErrorShowView:self];
//                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64+45+56*2+45+10, iPhoneWidth, iPhoneHeight-64-45-(56*2+45+10)) contentShowString:@"暂无好友" MDErrorShowViewType:NoData];
                        _isHaveData = NO;
                        self.msgString = @"暂无好友";
                        [_followListTableView reloadData];
                        if ([getObjectFromUserDefaults(SHOWHOMEMONEY) isEqualToString:@"YES"]) {
                            //后续做弹窗
                            if (!_addAdressBookAlertVC) {
                                _addAdressBookAlertVC = [[HomeNotifyAndAdressAlertView alloc] initWithHomeNotifyAndAdressAlertViewDelegate:self];
                            }
                            [self showPopupWithStyle:CNPPopupStyleCentered popupView:_addAdressBookAlertVC];
                            
                            getObjectFromUserDefaults(SHOWFOLLOWALERT) ? removeObjectFromUserDefaults(SHOWFOLLOWALERT) : @"";
                            saveObjectToUserDefaults(@"NO",SHOWFOLLOWALERT);
                        }
                    }
                    
                }
                [_weakRefreshHeader endRefreshing];
            } else {
                [_weakRefreshHeader endRefreshing];
//                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64+45+56*2+45+10, iPhoneWidth, iPhoneHeight-64-45-(56*2+45+10))  contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
                _isHaveData = NO;
                self.msgString = responseObject[@"msg"];
                [_followListTableView reloadData];
            }
        }
    }
                              fail:^{
                                  [_weakRefreshHeader endRefreshing];
//                                  [weakSelf initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 64+45+56*2+45+10, iPhoneWidth, iPhoneHeight-64-45-(56*2+45+10))];
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
            [_friendsListArray[26] addObject:obj];
        }else{
            unichar headC = [headStr characterAtIndex:0];
            NSLog(@"%hu",headC);
            NSInteger index = headC - 'A';
            [_friendsListArray[index] addObject:obj];
        }
    }];
    
    //3.处理空数组问题
    [_friendsListArray removeObject:[NSMutableArray array]];
    
    //4. 对table  header 处理  取分组首字母
    [_friendsListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * arr = (NSMutableArray  *) obj;
        NSDictionary * dic = [arr firstObject];
        NSLog(@"%@",dic);
        NSString * headStr = [self getFirstLetterFromString:dic[@"bookName"]];
        NSLog(@"%@",headStr);
        [_arraySectionTitle addObject:headStr];
    }];
//    [self hideMDErrorShowView:self];
    
    
    [_followListTableView reloadData];
    
    [FollowViewDataManager manager].lettersArray      = _arrayLetters;
    [FollowViewDataManager manager].followsListArray  = _friendsListArray;
    [FollowViewDataManager manager].sectionTitleArray = _arraySectionTitle;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _friendsListArray.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 2){
        return _isHaveData?0:1;
    }
    return [_friendsListArray[section-3] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = 0;
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@"添加好友"];
            cell.textLabel.text = @"添加好友";
        }else{
            cell.imageView.image = [UIImage imageNamed:@"friend"];
            cell.textLabel.text = @"邀请好友";
        }
        return cell;
    }else if (indexPath.section == 2){
        if (_isHaveData) {
            return nil;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
            cell.selectionStyle = 0;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = self.msgString;
            return cell;
        }
    }
    
    MyFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[MyFriendsTableViewCell MyFriendsTableViewCellID]];
    if (!cell) {
        cell = [MyFriendsTableViewCell MyFriendsTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消点击效果
    NSArray * colorArray = [[NSArray alloc] initWithObjects:@"24c6d5",@"24a797",@"7cc653",@"fec92f",@"fd7344",@"28b6f6",@"6086eb",@"fea42c",@"926dd7",nil];
    _colorIndex=_colorIndex==9?0:_colorIndex;
    
    NSDictionary * dic = [NSDictionary dictionary];
    if ([_friendsListArray[indexPath.section-3] count] > 0) {
        dic = _friendsListArray[indexPath.section-3][indexPath.row];
    }
    
    if ([self isLegalObject:dic[@"bookName"]]) {
        cell.titleNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"bookName"]];
        cell.userBronzeHeadLabelView.text = [cell.titleNameLabel.text substringToIndex:1];
        //cell.userBronzeHeadLabelView.backgroundColor = [UIColor colorWithHexString:colorArray[_colorIndex]];
        
    }
    
    if ([self isLegalObject:dic[@"mobile"]]) {
        cell.detailPhoneLabel.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    }
    
    _colorIndex++;
    return cell;
}

//返回右边索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _isHaveData?_arrayLetters:nil;
}

//索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    /*索引跟随实际可用 ?*/
    //    NSLog(@"===%@  ===%ld",title,(long)index);
    //    //点击索引，列表跳转到对应索引的行
    //    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+4]
    //     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //    //弹出首字母提示
    //    //[self showLetter:title];
    //    return index+4;
    
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
    if (section == 0 || section == 1) {
        UIView * aa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 10)];
        aa.backgroundColor = [UIColor colorWithHex:@"f7f7f7"];
        return aa;
    }else if (section == 2){
        UIView * aa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 45)];
        aa.backgroundColor = [UIColor colorWithHex:@"f7f7f7"];
        
        UILabel * ab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, iPhoneWidth-60, 45)];
        ab.textColor = [UIColor colorWithHexString:@"333333"];
        ab.font = [UIFont systemFontOfSize:15.0f];
        ab.backgroundColor = [UIColor clearColor];
        ab.text = _isHaveData?@"我的好友":@"";
        [aa addSubview:ab];
        return aa;
    }
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, 25)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, iPhoneWidth-35, 25)];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.backgroundColor = [UIColor clearColor];
    label.text = _arraySectionTitle.count>0?_arraySectionTitle[section-3]:@"";
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
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 10;
    }else if (section == 2){
        return 45;
    }
    if (_isHaveData) {
        
        return 25;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return _isHaveData?0:iPhoneHeight-64-45-56-10-56-45;
    }
    return [MyFriendsTableViewCell MyFriendsTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AddPhoneAdressViewController * addPhoneAdressBook = [[AddPhoneAdressViewController alloc] init];
        [self customPushViewController:addPhoneAdressBook customNum:0];
    }else if (indexPath.section == 1){
        AddressBookViewController * addressBook = [[AddressBookViewController alloc] init];
        [self customPushViewController:addressBook customNum:0];
    }
    if (indexPath.section == 2 && !_isHaveData) {
        [_weakRefreshHeader beginRefreshing];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/** 初始化下拉菜单 */
- (void)setupDropDownMenu {
    
    NSArray *modelsArray = [self getMenuModelsArray];
    //    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:140.0f eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
    
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:145 eachItemHeight:45 menuRightMargin:10 triangleRightMargin:20];//traiangleRightMargin -> Triangle(三角形)右边间距
    
//        self.dropdownMenu.triangleColor = [UIColor colorWithHexString:@""];//内部更改了
    self.dropdownMenu.menuItemBackgroundColor = [UIColor colorWithHexString:@"#448b51"];
    
}

/** 获取菜单模型数组 */
- (NSArray *)getMenuModelsArray {
    //    __weak typeof(self) weakSelf = self; //? 无效
    //菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加好友" menuItemIconName:@"addFriends_small"  menuBlock:^{
        //        NSLog(@"当前点击添加朋友");
        AddPhoneAdressViewController * addPhoneAdressBook = [[AddPhoneAdressViewController alloc] init];
        [self customPushViewController:addPhoneAdressBook customNum:0];
    }];
    
    //菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"手机联系人" menuItemIconName:@"adressBook_small" menuBlock:^{
        //       NSLog(@"当前点击查看手机通讯录");
        AddressBookViewController * addressBook = [[AddressBookViewController alloc] init];
        [self customPushViewController:addressBook customNum:0];
    }];
    
    //菜单模型2
    FFDropDownMenuModel *menuModel2 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"查看消息" menuItemIconName:@"message_small" menuBlock:^{
        //              NSLog(@"当前点击查看消息");
        CheckNewMessageViewController * checkMessage = [[CheckNewMessageViewController alloc] init];
        [self customPushViewController:checkMessage customNum:0];
    }];
    
    //菜单模型3
    FFDropDownMenuModel *menuModel3 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"好友红包" menuItemIconName:@"redEnvelope_small"  menuBlock:^{
        
        [self loadJudgeTradingPasswordAndCardData];
    }];
    
    NSArray *menuModelArr = @[menuModel0, menuModel1,menuModel2,menuModel3];
    
    return menuModelArr;
}

#pragma mark - 判断设置交易密码
- (void)loadJudgeTradingPasswordAndCardData{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
            [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                [weakSelf loadJudgeTradingPasswordAndCardData];
            } withFailureBlock:^{
                
            }];
        } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _UserInformationDict = [responseObject[@"item"] copy];
                //是否设置交易密码
                if (![_UserInformationDict[@"pay"] isKindOfClass:[NSNull class]] && [_UserInformationDict[@"pay"] integerValue] == 1) {
                    
                    //是否绑卡
                    if ([_UserInformationDict[@"status"] integerValue] == 2) {
                        _envelopeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"好友红包需要绑定银行卡，请绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                        [_envelopeAlert show];
                    } else {
                        ChooseEnveloperTypeViewController * chooseEnveloperTypeVC = [[ChooseEnveloperTypeViewController alloc] init];
                        [self customPushViewController:chooseEnveloperTypeVC customNum:0];
                    }
                    
                }else{
                    [self setPaymentPassWordController];
                }
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

//设置支付密码页面
- (void)setPaymentPassWordController
{
    setPaymentPassWorldViewController *setPaymentPassWorldView = [[setPaymentPassWorldViewController alloc] initWithNibName:@"setPaymentPassWorldViewController" bundle:nil];
    setPaymentPassWorldView.backUpView = ^(BOOL ishavePW) {
        if (ishavePW) {
            //            _isHavePayPassworld = YES;
        }
    };
    [self errorPrompt:3.0 promptStr:@"请先设置支付密码"];
    [self customPushViewController:setPaymentPassWorldView customNum:1];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _envelopeAlert && buttonIndex != 0) {
        BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
        BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
        BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
            
        };
        BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
        [self customPushViewController:BindingBankCardView customNum:0];
    }
}

- (IBAction)addFirendsBtnClicked:(id)sender {
    NSLog(@"点击了添加按钮");
    [self showDropDownMenu];
}

/** 显示下拉菜单 */
- (void)showDropDownMenu {
    [self.dropdownMenu showMenu];
}

- (void)againLoadingData
{
    //    [self hideMDErrorShowView:self];
    [self viewDidCurrentView];
}

- (void)viewDidCurrentView {
    if (![self isBlankString:getObjectFromUserDefaults(UID)]) {
        if ([_friendsListArray count] == 0) {
            [_weakRefreshHeader beginRefreshing];
        }else{
            [self initArray];
            [self loadData];
            [self loadVerifyMessageNumData];
        }
    } else {
        VerificationiPhoneNumberViewController *verfication = [[VerificationiPhoneNumberViewController alloc] initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        verfication.pushviewNumber = 1234;
        [self customPushViewController:verfication customNum:0];
    }
}

#pragma mark - AddAdressBookAlertViewDelegate
- (void)cancleBtnClicked {
    [self dismissPopupController];
}

- (void)importAdressBookPage
{
    AddressBookViewController * addressBookVC = [[AddressBookViewController alloc] init];
    [self customPushViewController:addressBookVC customNum:0];
    [self dismissPopupController];
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)getFirstLetterFromString:(NSString *)aString
{
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    
    if ([self isBlankString:aString]) {
        return @"#";
    }
    
    if ([[aString substringToIndex:1] isEqualToString:@"沈"]) {
        return @"S";
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backUp:(UIButton *)sender {
    [self customPopViewController:0];
}
- (IBAction)message:(id)sender {
//#if 0
//    /**
//     之前看到 @maple 分享的一键开启这几个功能的 Url scheme ：
//     支付宝扫码  alipayqr://platformapi/startapp?saId=10000007
//     支付宝付款码 alipayqr://platformapi/startapp?saId=20000056
//     微信扫一扫的 weixin://dl/scan  //已失效
//     QQ扫一扫代码 mqq://dl/scan/scan
//     //之前配置的白名单，就是需要跳转对方App的key，即对方设置的url
//     */
//    
//    NSArray * arrayUrl = @[@"weixin://",
//                           @"alipayqr://platformapi/startapp?saId=10000007",
//                           @"alipayqr://platformapi/startapp?saId=20000056"];
//    
//    NSString * urlStr = arrayUrl[arc4random()%3];
//    NSURL * url = [NSURL URLWithString:urlStr];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"跳转的应用程序未安装" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    
//#elif 0
//    
//    BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
//    BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
//    BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
//        
//    };
//    BindingBankCardView.UserInformationDict = [_UserInformationDict copy];
//    [self customPushViewController:BindingBankCardView customNum:0];
//    
//#elif 1
//    if (!_discoveryViewController) {
//        _discoveryViewController = [[NewDiscoveryViewController alloc] initWithNibName:@"NewDiscoveryViewController" bundle:nil];
//        _discoveryViewController.isHaveMessage = [_total integerValue]>=1?NO:YES;
//    }
//    [sender setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
//    [self customPushViewController:_discoveryViewController customNum:0];
//#endif

    CheckNewMessageViewController * checkMessage = [[CheckNewMessageViewController alloc] init];
    [self customPushViewController:checkMessage customNum:0];
}
@end
