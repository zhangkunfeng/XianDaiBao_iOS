//
//  WDStoreDatas.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/5/18.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#define force_inline __inline__ __attribute__((always_inline))

#ifndef WDStoreDatas_h
#define WDStoreDatas_h

static NSString *const UID = @"uid";  //userId  用户id
static NSString *const SID = @"sid";  //sessionId 识别码  SID是一个数据库的唯一标识符
static NSString *const USERNAME = @"userName";
static NSString *const MOBILE = @"mobile";
static NSString *const ACCESSTOKEN = @"accessToken";//请求操作时的访问令牌 过期不过期
static NSString *const PAYPSWSTATUS = @"payPswStatus";

static NSString *const REJECTSCORE = @"RejectScore";
static NSString *const GesturesPassword = @"gesturespassword";
static NSString *const NotificationUserDefaults = @"HomeViewNotification";
static NSString *const RECORDFIRSTSCORETIME  = @"RecordFirstScoreTime";
static NSString *const ALLUSEREARNING = @"earning";    //用户收益
static NSString *const SHOWASSETSMONEY = @"showAsstsMoney";//显示资产金额
static NSString *const SHOWHOMEMONEY = @"showHomeMoney";//显示首页金额
static NSString *const SHOWFOLLOWALERT = @"SHOWFOLLOWALERT";//显示好友弹窗
static NSString *const SWITCHOPEN = @"enabled";//开关
static NSString *const REDBUTTON = @"REDBUTTON";//红点
//dict
static NSString *const InvestmentSuccessDataDict = @"InvestmentSuccessDataDict";//投资成功分享界面数据

static force_inline void saveObjectToUserDefaults(NSString *value, NSString *key) {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static force_inline NSString *getObjectFromUserDefaults(NSString *key) {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!str) {
        return @"";
    }
    return str;
}

static force_inline void removeObjectFromUserDefaults(NSString *key) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//延伸  字典
static force_inline void saveDictionaryToUserDefaults(NSDictionary *value, NSString *key) {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static force_inline NSDictionary *getDictionaryFromUserDefaults(NSString *key) {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!dict) {
        return nil;
    }
    return dict;
}

static force_inline void removeDictionaryFromUserDefaults(NSString *key) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//延伸  数组
static force_inline void saveArrayToUserDefaults(NSArray *value, NSString *key) {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static force_inline NSArray *getArrayFromUserDefaults(NSString *key) {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!array) {
        return nil;
    }
    return array;
}

static force_inline void removeArrayFromUserDefaults(NSString *key) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#endif /* WDStoreDatas_h */



