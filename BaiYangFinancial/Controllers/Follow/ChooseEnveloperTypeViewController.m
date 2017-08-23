//
//  ChooseEnveloperTypeViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/5.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ChooseEnveloperTypeViewController.h"
#import "Masonry.h"
#import "PersonEnveloperViewController.h"
#import "ReceiverOrSendEnveloperViewController.h"
#import "FollowViewDataManager.h"

#define ChooseEnveloperTypeVCText @"选择红包类型"
@interface ChooseEnveloperTypeViewController ()
@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, strong) NSMutableArray * friendsListArray;//我的好友数组
@property (nonatomic, strong) NSMutableArray * arrayLetters; //索引
@property (nonatomic, strong) NSMutableArray * arraySectionTitle; //标题

@end

@implementation ChooseEnveloperTypeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    [self initArray];
    _colorIndex = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"F4F5F6"];
    
    CustomMadeNavigationControllerView *chooseEnveloperTypeView = [[CustomMadeNavigationControllerView alloc] initWithTitle:ChooseEnveloperTypeVCText showBackButton:YES showRightButton:YES rightButtonTitle:@"我的红包" target:self];
    chooseEnveloperTypeView.rightBtnWidth.constant = 70;
    [self.view addSubview:chooseEnveloperTypeView];

    [self createSelfView];
    [self loadData];
}


#pragma mark - CustomUINavBarDelegate
- (void)goBack{
    [self customPopViewController:0];
}

- (void)doOption{
#define ReceiveEnveloperTitleText @"收到的红包"
#define ReleaseEnveloperTitleText @"发出的红包"
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    //收到
    [alertController addAction: [UIAlertAction actionWithTitle:ReceiveEnveloperTitleText style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self customPushEnveloperViewControllerWithTitleType:ReceiveEnveloperTitleText];
    }]];
    
    //发出
    [alertController addAction: [UIAlertAction actionWithTitle:ReleaseEnveloperTitleText style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self customPushEnveloperViewControllerWithTitleType:ReleaseEnveloperTitleText];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)customPushEnveloperViewControllerWithTitleType:(NSString *)title{
    ReceiverOrSendEnveloperViewController * enveloperVC  = [[ReceiverOrSendEnveloperViewController alloc] init];
    enveloperVC.titleStr = title;
    [self customPushViewController:enveloperVC customNum:0];
}

- (void)createSelfView
{
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"邀你尝鲜"];
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(126);
        make.centerX.mas_equalTo(0);
    }];
    
    CGFloat  btnFont = 14.0f;
    UIColor * titleColor = [UIColor whiteColor];
    UIColor * backgroundColor = AppBtnColor;
    UIButton * topBtn    = [self createBtnWithTitle:@"普通红包"
                                      titleColor:titleColor
                                 backgroundColor:backgroundColor
                                       titleFont:btnFont
                                       addTarget:@selector(btnClicked:)
                                      addSubView:self.view];
    
    UIButton * bottomBtn = [self createBtnWithTitle:@"随机红包"
                                         titleColor:titleColor
                                    backgroundColor:backgroundColor
                                          titleFont:btnFont
                                          addTarget:@selector(btnClicked:)
                                         addSubView:self.view];
    
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(55);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(iPhoneWidth*0.6667);
        make.height.mas_equalTo(40);
    }];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBtn.mas_bottom).offset(25);
        make.centerX.equalTo(topBtn.mas_centerX);
        make.width.equalTo(topBtn.mas_width);
        make.height.equalTo(topBtn.mas_height);
    }];
    
}

- (UIButton *)createBtnWithTitle:(NSString *)title titleColor:(UIColor *)titlecolor backgroundColor:(UIColor*)backGroundColor titleFont:(CGFloat)font addTarget:(SEL)target addSubView:(UIView *)view
{
    UIButton * btn = [[UIButton alloc] init];
    btn.backgroundColor = backGroundColor;
    btn.layer.cornerRadius = 5.0f;
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    [btn addTarget:self action:target forControlEvents:UIControlEventTouchUpInside
     ];
    [view addSubview:btn];
    return btn;
}

- (void)btnClicked:(UIButton*)btn
{
    PersonEnveloperViewController * personEnveloperVC = [[PersonEnveloperViewController alloc] initWithNibName:@"PersonEnveloperViewController" bundle:nil];
    personEnveloperVC.titleStr = [btn.titleLabel.text isEqualToString:@"普通红包"]?
                                 @"普通红包":@"随机红包";
    [self customPushViewController:personEnveloperVC customNum:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
//                        _isHaveData = YES;
                        [self parseData:tempArr];
                    }else{
                        //                        [self hideMDErrorShowView:self];
                        //                        [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64+45+56*2+45+10, iPhoneWidth, iPhoneHeight-64-45-(56*2+45+10)) contentShowString:@"暂无好友" MDErrorShowViewType:NoData];
//                        _isHaveData = NO;
//                        self.msgString = @"暂无好友";
                        //[_followListTableView reloadData];
                        if ([getObjectFromUserDefaults(SHOWHOMEMONEY) isEqualToString:@"YES"]) {
                            //后续做弹窗
//                            if (!_addAdressBookAlertVC) {
//                                _addAdressBookAlertVC = [[HomeNotifyAndAdressAlertView alloc] initWithHomeNotifyAndAdressAlertViewDelegate:self];
//                            }
//                            [self showPopupWithStyle:CNPPopupStyleCentered popupView:_addAdressBookAlertVC];
                            
                            getObjectFromUserDefaults(SHOWFOLLOWALERT) ? removeObjectFromUserDefaults(SHOWFOLLOWALERT) : @"";
                            saveObjectToUserDefaults(@"NO",SHOWFOLLOWALERT);
                        }
                    }
                    
                }
                //[_weakRefreshHeader endRefreshing];
            } else {
               // [_weakRefreshHeader endRefreshing];
                //                [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64+45+56*2+45+10, iPhoneWidth, iPhoneHeight-64-45-(56*2+45+10))  contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
//                _isHaveData = NO;
//                self.msgString = responseObject[@"msg"];
//                [_followListTableView reloadData];
            }
        }
    }
                              fail:^{
                                 // [_weakRefreshHeader endRefreshing];
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
    
    
    //[_followListTableView reloadData];
    
    [FollowViewDataManager manager].lettersArray      = _arrayLetters;
    [FollowViewDataManager manager].followsListArray  = _friendsListArray;
    [FollowViewDataManager manager].sectionTitleArray = _arraySectionTitle;
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



@end
