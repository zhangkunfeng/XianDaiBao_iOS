//
//  MainViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "MDAssetsViewController.h"
#import "MainViewController.h"
#import "MainViewControllerDelegate.h"
#import "VerificationiPhoneNumberViewController.h"
#import "WDRegisterSuccessPopupView.h"
#import "RedenvelopeViewController.h"
#import "updataVersionview.h"
#import <AdSupport/AdSupport.h>
#import "HomeViewController.h"
#import "BindingBankCardViewController.h"
#import "BaseNewProductViewController.h"//理财产品
//#import "NewDiscoveryViewController.h"  //发现
#import "FollowViewController.h" //发现-\>关注
#import "DiscoverController.h"
typedef enum {
    RecmmendMenu = 0,
    ProductMenu,
    MyassetsMenu,
    DiscoveryMenu
} MainViewSubMenu;

#define TagBaseMenuButton 100
#define TagRecmmendMenuButton 101
#define TagProductMenuButton 102
#define TagAssetsMenuButton 103
#define TagDiscoveryMenuButton 104

#define TagBaseMenuLabel 200
#define TagRecmmendMenuLabel 201
#define TagProductMenuLabel 202
#define TagAssetsMenuLabel 203
#define TagMoreMenuLabel 204

#define MenuIndexNotFound -1
#define DefaultSelectedMenuButtonIndex 0

#define MenuLabelColor_Normal [UIColor colorWithRed:(139.0 / 255.0) green:(139.0 / 255.0) blue:(139.0 / 255.0) alpha:1.0]
/* define MenuLabelColor_Selected [UIColor colorWithRed:(61.0 / 255.0) green:(177.0 / 255.0) blue:(250.0 / 255.0) alpha:1.0] */
#define MenuLabelColor_Selected [UIColor colorWithRed:(96.0 / 255.0) green:(192.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0]

typedef struct {
    MainViewSubMenu menuId;
    int menuBtnTag;
    __unsafe_unretained NSString *menuActionSelector;
} MenuItemStruct;

static MenuItemStruct MenuList[] = {
    {RecmmendMenu, TagRecmmendMenuButton, @"loadRecmmendMainViewController"},
    {ProductMenu, TagProductMenuButton, @"loadProductMainViewController"},
    {DiscoveryMenu, TagDiscoveryMenuButton, @"loadDiscoveryMainViewController"},
    {MyassetsMenu, TagAssetsMenuButton, @"loadMyAssetsMainViewController"}};

const int kMenuItemCount = sizeof(MenuList) / sizeof(MenuList[0]);

@interface MainViewController () <versionUpdataviewDelegate, WDRegisterSuccessPopupViewDelegate, UIAlertViewDelegate>

//@property (nonatomic, strong) RecommendViewController *recmmendViewController;
@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) BaseNewProductViewController *productViewController;
@property (nonatomic, strong) MDAssetsViewController *myAssetsViewController;
//@property (nonatomic, strong) NewDiscoveryViewController *discoveryViewController;
//@property (nonatomic, strong) FollowViewController *followViewController;
@property (nonatomic, strong) DiscoverController *disCoverController;

@property (weak, nonatomic) IBOutlet UIView *contentHolderView;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel_main;

@property (nonatomic, assign) NSInteger selectedMenuIndex;
@property (nonatomic, assign) NSInteger lastSelectedMenuIndex;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, retain) NSString *updataVersioURL;
//@property (nonatomic, assign) BOOL isShowMianViewNotifity;//是否走登录流程(含再登录) 长刷新
@property (nonatomic, copy) NSString * message_total;

- (UIViewController *)loadRecmmendMainViewController;
- (UIViewController *)loadProductMainViewController;
- (UIViewController *)loadMyAssetsMainViewController;
- (UIViewController *)loadDiscoveryMainViewController;
- (void)loadDefaultSelectMenuIfNeeded;
- (void)loadViewWithMenuButtonIndex:(NSInteger)buttonIndex;
- (void)loadViewWithSelectedMenuButton:(UIButton *)selectedButton selectType:(MenuSelectType)type;

- (IBAction)onMenuButtonPressed:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedMenuIndex = MenuIndexNotFound;
        _lastSelectedMenuIndex = MenuIndexNotFound;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self isUpdataversion];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainview:) name:LoginBackMainView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToProductList:) name:GOTOPRODUCTLIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProductList:) name:@"dismissTo102" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_selectedMenuIndex == 102) {
        [_productViewController viewWillAppear:YES];
    }
    //数据统计呆在界面的时候
    [self talkingDatatrackPageBegin:@"首页"];
    [self setTimer];
    [self loadVerifyMessageNumData];
    [self loadDefaultSelectMenuIfNeeded];

    //评分
    if (![self isBlankString:getObjectFromUserDefaults(UID)] && ![getObjectFromUserDefaults(REJECTSCORE) isEqualToString:@"ConfirmRejectScore"]) {
        [self performSelector:@selector(RecordScore) withObject:nil afterDelay:3.0];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    dispatch_source_cancel(_getMYmessageTimer);
    if (_selectedMenuIndex == 102) {
        [_productViewController viewWillDisappear:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //数据统计离开界面的时候
    [self talkingDatatrackPageEnd:@"首页"];
}

- (void)RecordScore {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *nowTimeString = [NSString stringWithFormat:@"%.0f", a];
    NSUserDefaults *userDefaults = UserDefaults;
    //用户登录并使用两天之后才让去评分
    NSString *oldTimeString = getObjectFromUserDefaults(RECORDFIRSTSCORETIME);
    if ([self isBlankString:oldTimeString]) {
        //第一次进来保存本地一个时间戳
        saveObjectToUserDefaults(nowTimeString, RECORDFIRSTSCORETIME);
    } else {
        //当点击下次再说的时候保存本地一个时间戳两天后在显示
        if ([self isBlankString:[userDefaults objectForKey:RecordScoreTime]]) {
            if ([nowTimeString doubleValue] - 172800 > [oldTimeString doubleValue]) {
                [self showWeidaiStore];
            }
        } else {
            NSString *RecordScoreTimeString = [userDefaults objectForKey:RecordScoreTime];
            if ([nowTimeString doubleValue] - 172800 > [RecordScoreTimeString doubleValue]) {
                [self showWeidaiStore];
            }
        }
    }
}

- (void)showWeidaiStore {
    if (iOS7) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"求一个爱的好评！" message:@"衷心感谢您的支持与鼓励，小白厚着脸皮向你求一个爱的好评" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"五星大赏", nil];
        [alertView show];
    } else {
        //初始化提示框；
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"求一个爱的好评！" message:@"衷心感谢您的支持与鼓励，小白厚着脸皮向你求一个爱的好评" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"五星大赏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                             [self showStoreProductInApp];
                             saveObjectToUserDefaults(@"ConfirmRejectScore", REJECTSCORE);
                         }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                             NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
                             NSTimeInterval a = [dat timeIntervalSince1970];
                             NSString *nowTimeString = [NSString stringWithFormat:@"%.0f", a];
                             saveObjectToUserDefaults(nowTimeString, RecordScoreTime);
                         }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                             saveObjectToUserDefaults(@"ConfirmRejectScore", REJECTSCORE);
                         }]];
        //弹出提示框；
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [dat timeIntervalSince1970];
        NSString *nowTimeString = [NSString stringWithFormat:@"%.0f", a];
        saveObjectToUserDefaults(nowTimeString, RecordScoreTime);
    } else {
        [self showStoreProductInApp];
        saveObjectToUserDefaults(@"ConfirmRejectScore", REJECTSCORE);
    }
}

- (void)showStoreProductInApp {
    NSString *string = [NSString stringWithFormat:AppStoreUrl];
  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

- (void)showMainview:(NSNotification *)notification {
//    _isShowMianViewNotifity = YES;//刷新发现页面信息 考虑长刷新
//    UIButton *selectedButton = (UIButton *) [self.view viewWithTag:TagRecmmendMenuButton];//原先bug处
    UIButton *selectedButton = (UIButton *) [self.tabBarView viewWithTag:TagRecmmendMenuButton];
    [self loadViewWithSelectedMenuButton:selectedButton selectType:MenuSelectTypeUserSelect];
}

- (void)showProductList:(NSNotification *)notification {
    UIButton *selectedButton = (UIButton *) [self.tabBarView viewWithTag:TagProductMenuButton];
    [self loadViewWithSelectedMenuButton:selectedButton selectType:MenuSelectTypeUserSelect];
}

- (void)goToProductList:(NSNotification *)notification {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:GOTOPRODUCTLIST object:nil];
    WDRegisterSuccessPopupView *registerSuccessPopupView = [[WDRegisterSuccessPopupView alloc] init];
    registerSuccessPopupView.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:registerSuccessPopupView];
    registerSuccessPopupView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.35 animations:^{
        registerSuccessPopupView.transform = CGAffineTransformIdentity;
    }
        completion:^(BOOL finished) {
            registerSuccessPopupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }];
}

#pragma mark - WDRegisterSuccessPopupViewDelegate
- (void)bindingBankCard
{
    //获取用户信息
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"state": @"1",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)};
    [self showWithDataRequestStatus:@"获取信息中..."];
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
            BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
            BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
                
            };
            BindingBankCardView.UserInformationDict = (NSDictionary *) [responseObject[@"item"] copy];
            [self customPushViewController:BindingBankCardView customNum:0];
        } else {
            [self dismissWithDataRequestStatus];
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }fail:^{
      [self dismissWithDataRequestStatus];
      [self errorPrompt:3.0 promptStr:errorPromptString];
  }];
}

- (void)lookReddenvelope {
    //我的红包
    RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] init];
   
    [self customPushViewController:myRedenvelopeView customNum:0];
}

#pragma mark - 页面定时器初始化
- (void)setTimer {
    [self getMYmessageNumber];
}

#pragma mark - 获取未读站内信数量接口
/** 消息传递及相关后续
 *init   The Attribute Values
 mainVC 隔段时间加载站内信接口  
 _message_total(mainVC) 记录值 ->懒加载HomeVC 赋值给total  【runloop】
 total(HomeVC)  messageBtn点击 ->传值给 NewDiscoveryVC(bool)
 isHaveMessage(NewDiscoveryVC) 决定创建是否显示小圆点
 
 *after
 mainVC 隔段时间加载站内信接口 
 HideDiscoveryviewRedDot  发送通知   
   收取  HomeVC -> 改变messageBtn 图片
  NewDiscovery -> 是否显示小圆点
 */
- (void)getMYmessageNumber {
    
    WS(weakSelf);
    if (![self isBlankString:getObjectFromUserDefaults(SID)] && ![self isBlankString:getObjectFromUserDefaults(UID)]) {
        NSDictionary *parameters = @{
                                     @"uid": getObjectFromUserDefaults(UID),
                                     @"sid": getObjectFromUserDefaults(SID),
                                     @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                     };
        
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/sysCountSms", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if (![self isBlankString:responseObject[@"r"]]) {
                if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf getMYmessageNumber];
                    }
                                                                         withFailureBlock:^{
                                                                             
                                                                         }];
                } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf getMYmessageNumber];
                    }
                                                                     withFailureBlock:^{
                                                                         
                                                                     }];
                } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    if ([responseObject[@"total"] integerValue] > 0) {
                        _message_total = responseObject[@"total"]?[responseObject[@"total"] stringValue]:@"1";
                        [[NSNotificationCenter defaultCenter] postNotificationName:HideDiscoveryviewRedDot object:nil];
                    }
                }
            }
        }fail:^{
                                      
           }];
    }
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
                    NSLog(@"mainVC 查看待验证信息  = %@",responseObject);
                    if ([responseObject[@"item"] integerValue] > 0) {
                        self.roundLabel_main.hidden = NO;
                        saveObjectToUserDefaults(@"1", REDBUTTON);
                    }else{
                        self.roundLabel_main.hidden = YES;
                    }
                } else {
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        }fail:^{
          [self errorPrompt:3.0 promptStr:errorPromptString];
      }];
    }
}

#pragma mark - 软件更新
- (void)isUpdataversion {
    WS(weakSelf);
    NSDictionary *parameters = @{ @"type": @"0",
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
    };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/versionInformation", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf isUpdataversion];
                }
                    withFailureBlock:^{

                    }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([self isLegalObject:responseObject[@"item"]]) {
                    //先判断版本是否一致
                    NSString *versionString = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
                /*------*/    NSLog(@"versionString--z>> %@",versionString);
                    NSString *requestVersion = responseObject[@"item"][@"version"];
                /*------*/    NSLog(@"requestVersion--,,,,,,>> %@",requestVersion);

                    if (![requestVersion isEqualToString:versionString]) {
                        _updataVersioURL = responseObject[@"item"][@"url"];
                        /*------*/    NSLog(@"_updataVersioURL--,,,,,,>> %@",_updataVersioURL);
                        
                        NSString *infoString = responseObject[@"item"][@"info"];
                        /*------*/    NSLog(@"infoString--,,,,,,>> %@",infoString);
                        
                        /*------*/    NSLog(@"responseObject!#$^*()_)_+ %@",responseObject);

                        if ([responseObject[@"item"][@"isupdate"] integerValue] == 0) {
                            updataVersionview *updataVersion = [[updataVersionview alloc] initWithupdataVersionview:NOFORCEUPDATAVERSION contentString:infoString theDelegate:self];
                            [self showPopupWithStyle:CNPPopupStyleFullscreen popupView:updataVersion];
                        } else if ([responseObject[@"item"][@"isupdate"] integerValue] == 1) {
                            updataVersionview *updataVersion = [[updataVersionview alloc] initWithupdataVersionview:FORCEUPDATAVERSION contentString:infoString theDelegate:self];
                            [self showPopupWithStyle:CNPPopupStyleFullscreen popupView:updataVersion];
                        }
                    }
                }
            }
        }
    }
        fail:^{

        }];
}

#pragma mark - versionUpdataviewDelegate
//不更新按钮点击方法
- (void)noUpdatabuttonAction {
    [self dismissPopupController];
}
//立即更新的点击方法
- (void)updataButtonAction {
    [AFNetworkTool cancelAllHTTPOperations];
    if (![self isBlankString:_updataVersioURL]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updataVersioURL]];
    }
 //[self dismissPopupController];

}

- (void)loadDefaultSelectMenuIfNeeded {
    if (_selectedMenuIndex == MenuIndexNotFound) {
        [self loadViewWithMenuButtonIndex:DefaultSelectedMenuButtonIndex];
        _selectedMenuIndex = DefaultSelectedMenuButtonIndex;
    }
}

- (UIViewController *)loadRecmmendMainViewController {
    if (!_homeViewController) {
        _homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    }
    _homeViewController.total = _message_total;
    return _homeViewController;
}

- (UIViewController *)loadProductMainViewController {
    if (!_productViewController) {
//        _productViewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
        _productViewController = [[BaseNewProductViewController alloc] init];
    }
    return _productViewController;
}

- (UIViewController *)loadMyAssetsMainViewController {
    if (!_myAssetsViewController) {
        _myAssetsViewController = [[MDAssetsViewController alloc] initWithNibName:@"MDAssetsViewController" bundle:nil];
    }
    return _myAssetsViewController;
}

- (UIViewController *)loadDiscoveryMainViewController {
    if (!_disCoverController) {
        _disCoverController = [[DiscoverController alloc] init];
    }
//    _discoveryViewController.new_isHaveDiscovery = _isHaveDiscovery;
    return _disCoverController;
}

#pragma mark - 按钮点击事件
- (IBAction)onMenuButtonPressed:(id)sender {
    [self loadVerifyMessageNumData];//点击标签刷新信息
    UIButton *senderButton = (UIButton *) sender;
    if (_lastSelectedMenuIndex != senderButton.tag) {
        [self loadViewWithSelectedMenuButton:senderButton selectType:MenuSelectTypeUserSelect];
    }
}

- (void)loadViewWithMenuButtonIndex:(NSInteger)buttonIndex {
    UIButton *selectedButton = (UIButton *) [self.view viewWithTag:TagBaseMenuButton + buttonIndex + 1];
    UILabel *selectedLabel = (UILabel *) [self.view viewWithTag:TagBaseMenuLabel + buttonIndex + 1];
    selectedLabel.textColor = MenuLabelColor_Selected;
    [self loadViewWithSelectedMenuButton:selectedButton selectType:MenuSelectTypeDefault];
}

- (void)loadViewWithSelectedMenuButton:(UIButton *)selectedButton selectType:(MenuSelectType)type {
    UIViewController<MainViewControllerDelegate> *selectedViewController;
//    NSLog(@"%ld",(long)_lastSelectedMenuIndex);//首次-1  之后101
    if (_lastSelectedMenuIndex != MenuIndexNotFound) //对上次Controller操作  -1
    {
        if (_lastSelectedMenuIndex != selectedButton.tag) { //selectedButton.tag 101 -> 104
            UIViewController<MainViewControllerDelegate> *lastViewController;
            UIButton *lastButton = (UIButton *) [self.tabBarView viewWithTag:_lastSelectedMenuIndex];
            lastButton.selected = NO;
//            NSLog(@"%ld",lastButton.tag - TagBaseMenuButton - 1);//退出登录-> 3
            SEL getMenuSelector = NSSelectorFromString(MenuList[lastButton.tag - TagBaseMenuButton - 1].menuActionSelector); //SEL myTestSelector = @selector(myTest:);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            lastViewController = [self performSelector:getMenuSelector];
#pragma clang diagnostic pop
            if ([lastViewController respondsToSelector:@selector(wasUnselectedBySender:)]) {
                [lastViewController wasUnselectedBySender:self];
            }
            //解决选择首页时候刷新数据
            if (selectedButton.tag == 101) {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:nil];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }
            
            if (selectedButton.tag == 102) {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshProductList object:nil];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
            
            if (selectedButton.tag == 103) {
                 //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscoveryView object:nil];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                self.roundLabel_main.hidden = YES;
            }
            
            if (selectedButton.tag == 104) {//固有
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:SendToMyAssets object:nil];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }
            selectedButton.userInteractionEnabled = YES;
        }
    }
    
    //本次加载Controller操作
    self.selectedMenuIndex = selectedButton.tag; //  增加index判定
//    NSLog(@"%ld",(long)self.selectedMenuIndex);
    
    UILabel *selectedLabel = (UILabel *) [self.view viewWithTag:TagBaseMenuLabel + _selectedMenuIndex - TagBaseMenuButton];//200 + ? - 100
//    NSLog(@"%ld",TagBaseMenuLabel + _selectedMenuIndex - TagBaseMenuButton);
    selectedLabel.textColor = MenuLabelColor_Selected;
    if (_currentLabel) {//设置 last 为 Normal
        _currentLabel.textColor = MenuLabelColor_Normal;
    }
    if (_lastSelectedMenuIndex == selectedButton.tag) {//重新登录 104 last 不走
        _currentLabel.textColor = MenuLabelColor_Selected;
    }
    self.currentLabel = selectedLabel;

    SEL getMenuSelector = NSSelectorFromString(MenuList[selectedButton.tag - TagBaseMenuButton - 1].menuActionSelector);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    selectedViewController = [self performSelector:getMenuSelector];
#pragma clang diagnostic pop
    selectedButton.selected = YES;
 
    if (selectedViewController) {
        selectedViewController.view.frame = self.contentHolderView.bounds;
        if (![selectedViewController.view superview]) {
            [self.contentHolderView addSubview:selectedViewController.view];
        }
        [self.contentHolderView bringSubviewToFront:selectedViewController.view];
        if ([selectedViewController respondsToSelector:@selector(wasSelectedBySender:selectType:)]) {
            [selectedViewController wasSelectedBySender:self selectType:type];
        }
    }
    _lastSelectedMenuIndex = _selectedMenuIndex;
}

@end
