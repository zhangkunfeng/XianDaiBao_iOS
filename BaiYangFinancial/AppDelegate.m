//
//  AppDelegate.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AppDelegate.h"
#import "GestureViewController.h"
#import "GuidanceManager.h"
#import "GuidanceViewController.h"
#import "MainViewController.h"
#import "PCCircleViewConst.h"
#import "SDImageCache.h"
#import "UniversalWebViewController.h"
#import "startAdImagModel.h"
#import "startAdImageViewController.h"
#import <AdSupport/AdSupport.h>
//#import "UMSocial.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialWechatHandler.h"
#import "GeTuiSdk.h"
#import "TalkingData.h"
#import "TalkingDataAppCpa.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import <Bugly/Bugly.h>



NSString *const NotificationCategoryIdent  = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"ACTION_ONE";
NSString *const NotificationActionTwoIdent = @"ACTION_TWO";

//个推
#define kGtAppId           @"xVmzioMeqk9qku07Ekhac5"
#define kGtAppKey          @"aHpldakx8FAzFpscc1JAt8"
#define kGtAppSecret       @"8c5buNHwyoA31TQft3PUX5"

@interface AppDelegate () <GuidanceViewControllerDelegate,GeTuiSdkDelegate,UIAlertViewDelegate>
{
    GestureViewController *_gestureVc;
}
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) GuidanceViewController *guidanceViewController;
@property (nonatomic, strong) startAdImageViewController *adImageView;
@property (nonatomic, copy  ) NSArray *payloadMsgArray;
@property (nonatomic, assign) BOOL isApplicationActioning;
@property (nonatomic, assign) BOOL isShowAdImageView;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation AppDelegate

@synthesize clientId = _clientId;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [self lunchImageView];
    
    [self loadMainViewController];
    [self.window  makeKeyAndVisible];
    //让程序睡一会
//    [NSThread sleepForTimeInterval:0.8];
    
    /*新手引导*/
    [self checkShowGuidingPage];
    
    [self initGeTuiSDKSetting];
    
    [self setSDKkeys];
    
    [self talkingDataAppAnalyticsSDK];
    [self talkingDataAppAdTrackingSDK];
      
    //这里获得开机画面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3/*5*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getAdvertisementRequest];
    });
    
    [Bugly startWithAppId:@""];
    
    return YES;
}

#pragma  mark - GeTui
- (void)initGeTuiSDKSetting
{
    //  通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // [2]:注册APNS
    [self registerUserNotification];
    
    [self settingOtherGeTui];
}

//个推其他设置
- (void)settingOtherGeTui
{
    //主线程延迟1秒调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *phoneNo = getObjectFromUserDefaults(MOBILE);
        [GeTuiSdk bindAlias:phoneNo andSequenceNum:@""];
        NSLog(@"GeTui -> 当前用户:%@",phoneNo);
       });
}

#pragma mark - 收到远程通知
/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    //返回后台 收到消息
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

#pragma mark - 4.2 苹果官方静默推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    // IOS 7 Support Required
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 打印错误信息  /** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)setSDKkeys {
    
//    //友盟分享APPKey
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"596461bbae1bf84486000caa"];
    
    //设置微信的appKey和appSecret
    //ID wx5706db5d108e1931   //SEC  4043a1e86386f7457850bd6e4e1e06ea
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5706db5d108e1931" appSecret:@"4043a1e86386f7457850bd6e4e1e06ea" redirectURL:@"http://www.baiyangjinrong.com"];
    
    //设置分享到QQ互联的appKey和appSecret  qq Appkey为AppID
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106225515"  appSecret:@"DM5jLdMlSZ6BjkGN" redirectURL:@"http://www.baiyangjinrong.com"];
    
    //APP ID1106225515APP KEYDM5jLdMlSZ6BjkGN
//    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"169588509"  appSecret:@"c763d4fe079c432671dedf3682e14da6" redirectURL:@""];
    
//    //友盟统计
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"596461bbae1bf84486000caa";
    UMConfigInstance.channelId = @"App Store";
//    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
   [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

- (void)talkingDataAppAnalyticsSDK
{
    // App ID: 在 App Analytics 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
    // 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
    [TalkingData sessionStarted:@"346DBAD9E05446458CACF9965C1F64E9" withChannelId:@"AppStore"];
    
    // YES: 开启自动捕获 自动获取异常信息
    // NO: 关闭自动捕获
    [TalkingData setExceptionReportEnabled:YES];
}
     
- (void)talkingDataAppAdTrackingSDK
{
    //channelId为渠道跟踪ID，如果在Appstore官方市场上架，channelID 必须设置为AppStore 避免系统误判为其他第三方市场数据，如果在国内第三方应用市场，或者越狱市场上架，请按照系统生成的ID为准!
    [TalkingDataAppCpa init:@"6D3805411FAD4541856357645862A4D5" withChannelId:@"AppStore"];
}
     
// 判断广告图片是否下载完成
- (BOOL)isAdImageDownloadComplete {
    UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[UserDefaults objectForKey:@"adImage.path"]];
    return myCachedImage ? YES : NO;
}

//获得开机画面
- (void)getAdvertisementRequest {
    if (getObjectFromUserDefaults(ACCESSTOKEN)) {/*M7fbfba2e1baba27c446b2f41f3e98480*/
        NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                      @"type": @"6"
        };
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/queryList", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                id data = responseObject[@"data"];
                if ([data isKindOfClass:[NSArray class]]) {
                    NSArray *dataArray = (NSArray *) data;
                    if (dataArray.count > 0) {
                        startAdImagModel *adImageModel = [[startAdImagModel alloc] initWithDictionary:[responseObject[@"data"] objectAtIndex:0]];/*Only one*/
                        if (![adImageModel.image isEqualToString:[UserDefaults objectForKey:@"adImage.path"]] || ![self isAdImageDownloadComplete]) {
                            [[SDImageCache sharedImageCache] removeImageForKey:[UserDefaults objectForKey:@"adImage.path"]];
                            if ([UserDefaults objectForKey:@"adImage.path"]) {
                                [UserDefaults removeObjectForKey:@"adImage.path"];
                                [UserDefaults removeObjectForKey:@"adImage.title"];
                                [UserDefaults removeObjectForKey:@"adImage.url"];
                            }
                            UIImage *adImage;
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:adImageModel.image]];
                            adImage = [UIImage imageWithData:data];
                            [[SDImageCache sharedImageCache] storeImage:adImage forKey:adImageModel.image];
                            [UserDefaults setObject:adImageModel.title forKey:@"adImage.title"];
                            [UserDefaults setObject:adImageModel.image forKey:@"adImage.path"];
                            [UserDefaults setObject:adImageModel.url forKey:@"adImage.url"];
                            [UserDefaults synchronize];
                        }
                    }
                }
            }
            self.isShowAdImageView = YES;
        }fail:^{

        }];
    }
}

// 添加广告视图到window上
- (void)setupAdImageViewController {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [[NSNotificationCenter defaultCenter] postNotificationName:DisableMessageBtn object:@"禁用"];
    });
    
    WS(weakSelf);
    _adImageView = [[startAdImageViewController alloc] init];
    _adImageView.skipRemove = ^(BOOL isRemove){
        if (isRemove) {
            [weakSelf removeAdImageViewFromWindow];
        }
    };
    [_mainViewController.view addSubview:_adImageView.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(/*2.0*/3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self isShowGestureViewController]) {/*是否大于60秒*/
            //验证手势密码
            //[self verifyGesture];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_payloadMsgArray count] > 0 && !_isApplicationActioning) {
                    if ([[_payloadMsgArray objectAtIndex:1] rangeOfString:@"http"].location != NSNotFound) {
                        [self dealWithgeTuiNotification];
                    }
                }
                _isApplicationActioning = YES;
            });
        }
        [self removeAdImageViewFromWindow];
    });
}

- (void)removeAdImageViewFromWindow {
    if (_adImageView.view != nil) {
        [UIView animateWithDuration:1.0
            animations:^{
                _adImageView.view.alpha = 0.0;
                [_adImageView.view setTransform:(CGAffineTransformMakeScale(1.5, 1.5))];
            }
            completion:^(BOOL finished) {
                [_adImageView.view removeFromSuperview];
                [[NSNotificationCenter defaultCenter] postNotificationName:DisableMessageBtn object:@"启用"];
            }];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
     [TalkingDataAppCpa onReceiveDeepLink:url];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self getCurrenttime];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // [EXT] APP进入后台时，通知个推SDK进入后台
//    [GeTuiSdk enterBackground];
    _isApplicationActioning = NO;
    //清理缓存
    //缓存沙盒地址
    //    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    //获取缓存大小
    //    CGFloat cacheFileSize = [self folderSizeAtPath:cachPath];
    //    if (cacheFileSize > 8.0) {
    //        [self myClearCacheAction];
    //    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //调用作为从后台到非活动状态的过渡的一部分，在这里你可以撤消许多进入背景的变化。
    
//     不合适 后台->前台
//    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:CreditRechargeShowAlert object:nil];
    
    if ((![self isAdImageDownloadComplete] || self.isShowAdImageView) && !_isApplicationActioning) {
        if ([self isShowGestureViewController] && ![self isCurrentViewControllerVisible:_gestureVc]) {
             //验证手势密码
            //[self verifyGesture];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_payloadMsgArray count] > 0 && !_isApplicationActioning) {
                    if ([[_payloadMsgArray objectAtIndex:1] rangeOfString:@"http"].location != NSNotFound) {
                        [self dealWithgeTuiNotification];
                    }
                }
                _isApplicationActioning = YES;
            });
        }
    }
/*
    //输出错误信息
    @try{
        
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
*/
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    // [EXT] 重新上线
//    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    /*这里更合适  程序启动&&后台->前台 */
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
}

- (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 3.2 App运行时启动个推SDK并注册APNS   ( - 后配置 - )
/** 注册用户通知 */
- (void)registerUserNotification {
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        /***这里写出现警告的代码就能实现去除警告***/

        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
#pragma clang diagnostic pop
    }
}

#pragma mark 注册远程通知成功 返回deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
#pragma mark - 远程通知(推送)回调   3.3 向个推服务器注册DeviceToken
    /** 远程通知注册成功委托 */
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

#pragma mark - background fetch  唤醒    3.4 Background Fetch 接口回调
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GexinSdkDelegate  3.5 GeTuiSdk注册回调，获取CID信息
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    _clientId = clientId;
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    
    //    if (_deviceToken) {
    //        [GeTuiSdk registerDeviceToken:_deviceToken];
    //    }
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

#pragma mark -  4.1 使用个推SDK透传消息, 由个推通道下发 (非APNS)
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
//    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
//    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
    if ([payloadMsg rangeOfString:@"－－－》"].location != NSNotFound) {
        if ([_payloadMsgArray count] > 0) {
            _payloadMsgArray = nil;
        }
        _payloadMsgArray = [payloadMsg componentsSeparatedByString:@"－－－》"]; //从字符A中分隔成2个元素的数组
    }
    
//    //在线处理通知消息  不提示了直接打开
//    if ([_payloadMsgArray count] > 0) {
//        [self onLinedealWithgeTuiNotification];
//    }
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用  以下均 demo 有
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
//    NSError * err = nil;
//    [1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self /*error:&err*/];
//    [1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
//    [1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
        [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

//验证手势密码
- (void)verifyGesture {
    NSString *valueString = [NSString stringWithFormat:@"%zd",[getObjectFromUserDefaults(UID) integerValue]];
    if ([getObjectFromUserDefaults(gestureFinalSaveKey) length] && valueString.length > 0) {
        _gestureVc = [[GestureViewController alloc] init];
        [_gestureVc setType:GestureViewControllerTypeLogin];
        WS(weakSelf);//避免循环引用
        _gestureVc.appDelegateGoback = ^(BOOL isBack) {
            if (isBack) {
                if ([_payloadMsgArray count] > 0 && !_isApplicationActioning) {
                    if ([[_payloadMsgArray objectAtIndex:1] rangeOfString:@"http"].location != NSNotFound) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            _isApplicationActioning = YES;
                            [weakSelf dealWithgeTuiNotification];
                        });
                    }
                }else{  //避免与个推信息 首页产生冲突
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:@"手势完成后加载系统通知"];                    });
                }
            }
        };
        
        [_mainViewController customPushViewController:_gestureVc customNum:3];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([_payloadMsgArray count] > 0 && !_isApplicationActioning) {
                if ([[_payloadMsgArray objectAtIndex:1] rangeOfString:@"http"].location != NSNotFound) {
                    [self dealWithgeTuiNotification];
                }
            }
            _isApplicationActioning = YES;
        });
    }
}

//获取当前时间
- (void)getCurrenttime {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:timeString forKey:@"date"];
    [defaults synchronize];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [self dealWithgeTuiNotification];
    }
}

- (void)dealWithgeTuiNotification {
    UniversalWebViewController *webViews = [[UniversalWebViewController alloc] initWithNibName:@"UniversalWebViewController" bundle:nil];
    webViews.WebTiltle = [_payloadMsgArray objectAtIndex:0];
    webViews.requestURL = [_payloadMsgArray objectAtIndex:1];
    [_mainViewController customPushViewController:webViews customNum:1];
    _payloadMsgArray = nil;
}

- (void)onLinedealWithgeTuiNotification {
    if (_isApplicationActioning) {
        if ([[_payloadMsgArray objectAtIndex:1] rangeOfString:@"http"].location != NSNotFound) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[_payloadMsgArray objectAtIndex:0] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
            [alertView show];
        }
    }
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
//     [4-EXT]:发送上行消息结果反馈
//        NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//        [_viewController logMsg:record];
//        [_mainViewController showAlartAPNSmessage:record];
    
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

#pragma mark - loadMainViewController
- (void)loadMainViewController {
    _mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]
        initWithRootViewController:_mainViewController];
    navigationController.navigationBarHidden = YES;
    self.navigationController = navigationController;
    self.window.rootViewController = self.navigationController;
    
    NSLog(@"/*@@* adImage.path = %@ *@@*/",[UserDefaults objectForKey:@"adImage.path"]);/*yes*/
    NSLog(_isApplicationActioning ? @"_isApplicationActioning = YES"
                                  : @"_isApplicationActioning = NO");/*NO*/
    
    if ([UserDefaults objectForKey:@"adImage.path"] != nil && _isApplicationActioning) {
        //[self verifyGesture];
    }
//    [self verifyGesture];//tempAction
}

#pragma mark - 新手引导页面
- (void)checkShowGuidingPage {
    NSLog([self isAdImageDownloadComplete] ? @"判断广告页是否下载完成YES" : @"判断广告页是否下载完成NO");
    GuidanceManager *manager = [[GuidanceManager alloc] init];
    if ([manager needShowGuidancePage]) {
        [self showGuidingPage];
    } else {
        if ([self isAdImageDownloadComplete]) {//判断广告页是否下载完成
            [self setupAdImageViewController];
        }/*else{ 不能加 会造成2次验证手势密码
            [self setupAdImageViewController];//tempAction  默认图其实不用加判断
        }*/
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    }
}

- (void)showGuidingPage {
    if (!_guidanceViewController) {
        _guidanceViewController = [[GuidanceViewController alloc] initWithNibName:@"GuidanceViewController" bundle:nil];
        _guidanceViewController.delegate = self;
        _guidanceViewController.view.frame = self.window.bounds;
    }
    [self.window addSubview:_guidanceViewController.view];
}

#pragma mark - GuidanceViewControllerDelegate
- (void)guidingViewWillDisappear {
    GuidanceManager *manager = [[GuidanceManager alloc] init];
    [manager storageGuidancePlayedState];
    self.guidanceViewController = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
}

#pragma mark -isShowGestureViewController
- (BOOL)isShowGestureViewController {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *nowTimeString = [NSString stringWithFormat:@"%.0f", a];
    NSLog(@"nowTimeString = %@",nowTimeString);/*距离1970年至今的秒数*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldtimeString = [defaults objectForKey:@"date"];

    if ([nowTimeString doubleValue] - [oldtimeString doubleValue] > 30) {
        return YES;
    }
    return NO;
}

#pragma mark -  cleanCache
- (CGFloat)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)myClearCacheAction {
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];

            NSLog(@"files :%lu", (unsigned long) [files count]);
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
        });
}

- (void)clearCacheSuccess {
    NSLog(@"清理成功");
}

@end
