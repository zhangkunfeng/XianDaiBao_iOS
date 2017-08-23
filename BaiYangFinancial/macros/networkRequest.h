//
//  networkRequest.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/10.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#ifndef BaiYangFinancial_networkRequest_h
#define BaiYangFinancial_networkRequest_h

/**
 WD_testMode:
 0:生产环境
 1:开发环境
 */
#ifdef WD_testMode

//生产环境
#if WD_testMode == 0

////appStore － production
#define kAppId @""
#define kAppKey @""
#define kAppSecret @"" 

/**
 *  白杨 正式环境
 */
//#define GeneralWebsite @"https://app.baiyangjinrong.com/"

//联机环境1
//#define GeneralWebsite  @"http://192.168.1.110:9090/mobile/"

//联机环境2
//#define GeneralWebsite  @"http://192.168.99.152:8082/frontend/"

//#define GeneralWebsite  @"http://116.62.195.216:8081"

/**
 *  生产环境
 */
//#define GeneralWebsiteT @"http://app.xianqianbao.net/"
//#define GeneralWebsite  @"http://app.xianqianbao.net/"

#define GeneralWebsiteT @"http://116.62.195.216:8082/"
#define GeneralWebsite @"http://116.62.195.216:8082/"

//#define GeneralWebsiteT @"http://192.168.1.112:8082/mobile/"
//#define GeneralWebsite @"http://192.168.1.112:8082/mobile/"


//开发环境
#elif WD_testMode == 1

// 企业证书 － development
#define kAppId @""
#define kAppKey @""
#define kAppSecret @""
#define GeneralWebsite @"http://123.56.233.157/" //UATesting

#define GeneralWebsiteT @"http://116.62.195.216:8082/"
#define GeneralWebsite @"http://116.62.195.216:8082"
#else

#warning "未匹配环境"
       
#endif

#else

#warning "没有定义环境"

#endif

#define USERINFODICT @"userinfodict" //用户的/Users/hongxu/Library/Containers/com.tencent.qq/Data/Library/Caches/Images/09346904C9DC69A9F67B456563F8C737.jpg信息
#define InviteCode @"InviteCode"     //邀请好友送红包的二维码
/**
 *  接口错误提示
 */
#define verificationOK @"1"         //接口请求成功
#define TOKEN_TIME @"-100010003"    //acess_token过期
#define SESSION_EMPTY @"-100010010" //sid超时

typedef uint32_t CCOperation2;

/**
 *  最终的手势密码存储key
 */
#define gestureFinalSaveKey @"gestureFinalSaveKey"

/** 
 *  程序中的静态界面
 */
//Appstore  用户评价 1230911254  贤钱宝评价页
#define AppStoreUrl @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1230911254&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"//评价页
#define AppStoreURL2 @""//功能页 //暂未启用

//http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APPID&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8

//用户协议
#define UserAgreementURL @"http://html.baiyangjinrong.com/regRule/serviceAgreement.html"

//债权转让细则  没有债权转让
#define AssignmentDetailsURL @"https://qianluwanghtml.oss-cn-hangzhou.aliyuncs.com/assignment/assignment.html"

//提现规则
#define AboutDetailURL @"https://xqbhtml.oss-cn-hangzhou.aliyuncs.com/withdraw/withdrawalNotice.html"

//自动投标规则
#define AutoBidguizeURL @"https://xqbhtml.oss-cn-hangzhou.aliyuncs.com/zdtb/BaiYangBid.html"

//关于理财师规则 未启用
#define FinancialPlannerRulesURL @"https://qianluwanghtml.oss-cn-hangzhou.aliyuncs.com/licaishi/licaishi.html"

//零钱包规则  未启用
#define ChangeMoneyFinancialRulesURL @"https://qianluwanghtml.oss-cn-hangzhou.aliyuncs.com/coinRule/coinRule.html"

//好友红包规则
#define EnveloperRulesURL @"http://html.baiyangjinrong.com/friendRed/friendHBRule.html"

//安全保障
#define SecurityURL @"http://html.baiyangjinrong.com/safeApp/SecurityAssurance.html"

//平台介绍
#define PlatformIntroduced @"http://xqbapp.oss-cn-hangzhou.aliyuncs.com/aboutUs/aboutUsApp.html"

//帮助中心
#define HelpCenterURL @"https://xqbapp.oss-cn-hangzhou.aliyuncs.com/helpPage/helpPage.html"

//风险提示

#define FengXianUrl @"https://xqbhtml.oss-cn-hangzhou.aliyuncs.com/regRule/safeMsg.html"

//注册协议
#define ZhuCeUrl @"https://xqbhtml.oss-cn-hangzhou.aliyuncs.com/regRule/serviceAgreement.html"




/** 此版取消  未改 */
//在线客服
#define OnlineKefuURL @"http://kefu.yunqixs.com"
//积分兑换
#define ClickIntegralShake @"http://www.BaiYangFinancial.org/actiovity/clickIntegralShake"

#endif
