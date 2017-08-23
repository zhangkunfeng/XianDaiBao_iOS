//
//  DeviceConfiguration.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/3.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#ifndef BaiYangFinancial_DeviceConfiguration_h
#define BaiYangFinancial_DeviceConfiguration_h

//屏幕宽度
#define Screen_Width [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define Screen_Height [UIScreen mainScreen].bounds.size.height

// 当前设备大小
#define iPhoneWidth [UIScreen mainScreen].bounds.size.width
#define iPhoneHeight [UIScreen mainScreen].bounds.size.height

//rgb调色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//设备的型号
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_ ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//设备版本
#define iOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0))

#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0))

#define IsiOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#define iOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0

#define IOS10 (NSFoundationVersionNumber >= NSFoundationVersionNumber10_0)?YES:NO
//  主要单例
#define UserDefaults [NSUserDefaults standardUserDefaults]

//线条的背景颜色
#define LineBackGroundColor [UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1.0]
//btn 主题色
//#define AppBtnColor [UIColor colorWithHexString:@"#26B25C"]    //60B8D3

#define AppBtnColor [UIColor colorWithHexString:@"#05CBF3"]
//程序主题颜色  【采用区域  登录&注册边框 以及主题色】
//#define AppMianColor [UIColor colorWithHexString:@"#26B25C"]
#define AppMianColor [UIColor colorWithHex:@"#05CBF3"]
//突出重要信息等
#define AppTextColor [UIColor colorWithHex:@"#ED702A"]

//程序界面背景色
#define AppViewBackGroundColor [UIColor colorWithRed:245 / 255.0 green:248 / 255.0 blue:252 / 255.0 alpha:1.0]
//877D7D 待更改


//首页广告的Page点
#define IMG_HomePageNormal @"tb2"
#define IMG_HomePageHighlight @"tb1"

//获取验证码最大时间
#define GetCodeMaxTime 60

/**
 *  通知的名称
 */
#define LoginBackMainView @"LoginBackMainView"
#define RefreshDiscoveryView @"RefreshDiscoveryView" //刷新发现
#define RefreshRecommendView @"RefreshRecommendView"
#define RefreshHomeView @"RefreshHomeView"     //刷新首页[新]
#define RefreshFollowView @"RefreshFollowView" //刷新好友【登录】及点击
#define changeDetailContentScrollView @"changeDetailContentScrollView" //详情滚动视图
#define showDetailContractMaterialsDataimage @"showDetailContractMaterialsDataimage"                //加载项目材料&合同图片
#define RefreshProductList @"RefreshProductList"
#define ISHAVEDiscovery @"haveDiscovery"
#define DISCOVERYISNODATA @"DISCOVERYISNODATA"
#define SendToMyAssets @"sendtoMyAssetsView"
#define DISCOVERYHIDENODATAVIEW @"hidenodataview"
#define GOTOPRODUCTLIST @"productList"                     //注册成功弹出视图
#define HideMainviewRedDot @"HideMainviewRedDot"
#define HideDiscoveryviewRedDot @"HideDiscoveryviewRedDot" //是否有新消息
#define DisableMessageBtn @"DisableMessageBtn"             //禁用messageBtn
#define isHidenFollowAddMessageRedDot @"isHidenFollowAddMessageRedDot"//好友+消息展示
#define CreditRechargeShowAlert @"CreditRechargeShowAlert" //信用卡充值跳转后通知
//#define i6NotifyMasoryL @"i6NotifyMasoryL"//i6大小适配

/**
 *  列表页的标题
 */
#define WEIDAIDYNAMIC @"动态"
#define SYSTEMESSAGE @"消息"
#define ALLBID @"全部标的"
#define ASSIGNMENTBID @"转让标的"

/**
 *  UITextFieldFram
 */
#define UITextFieldFram CGRectMake(iPhoneWidth * 0.25, 0, iPhoneWidth * 0.75, 44)
#define BankNameCityFram CGRectMake(iPhoneWidth * 0.30, 0, iPhoneWidth * 0.61, 44)

#define isKindOfNSDictionary(obj) (obj && [obj isKindOfClass:[NSDictionary class]])

//程序下载渠道
#define TALKINGDATADOWNLOADChannel @"AppStore（3.6）"

//#define errorPromptString @"未知错误，请稍候点击重试"
#define errorPromptString @"网络开小差了,请稍后再试"

#define RecordScoreTime @"RecordScoreTime"

#endif
