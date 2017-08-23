//
//  WDQuerySessionID.m
//  IOS-WeidaiCreditLoan
//
//  Created by 无名小子 on 16/4/25.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import "WDQuerySessionID.h"

@interface WDQuerySessionID ()

@property (assign, nonatomic) NSInteger failureCount;

@end

@implementation WDQuerySessionID

DEF_SINGLETON(WDQueryAccessToken)

- (instancetype)init {
    self = [super init];
    if (self) {
        self.failureCount = 0;
    }
    return self;
}

- (void)querySessionIDWithSuccessBlock:(void (^)(id))successBlock withFailureBlock:(void (^)())failureBlock {
    WS(weakSelf);
    NSDictionary *params = @{ @"uid": getObjectFromUserDefaults(UID),
                              @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                              @"sid": getObjectFromUserDefaults(SID) };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@login/gainSid",GeneralWebsite] parameters:params success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            saveObjectToUserDefaults(responseObject[@"sid"], SID);
            if (successBlock) {
                successBlock(responseObject);
            }
        }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                
            } withFailureBlock:^{
                
            }];
        }else{
            weakSelf.failureCount++;
            if (weakSelf.failureCount < 3) {
                [weakSelf querySessionIDWithSuccessBlock:^(id responseObj) {
                    
                }
                                        withFailureBlock:^{
                                            
                                        }];
            } else {
                self.failureCount = 0;
                if (failureBlock) {
                    failureBlock();
                }
                removeObjectFromUserDefaults(UID);
                removeObjectFromUserDefaults(SID);
                removeObjectFromUserDefaults(MOBILE);
                removeObjectFromUserDefaults(USERNAME);
                removeObjectFromUserDefaults(GesturesPassword);
            }
        }
    } fail:^{
        weakSelf.failureCount++;
        if (weakSelf.failureCount < 3) {
            [weakSelf querySessionIDWithSuccessBlock:^(id responseObj) {
                
            }
                                    withFailureBlock:^{
                                        
                                    }];
        } else {
            self.failureCount = 0;
            if (failureBlock) {
                failureBlock();
            }
            removeObjectFromUserDefaults(UID);
            removeObjectFromUserDefaults(SID);
            removeObjectFromUserDefaults(MOBILE);
            removeObjectFromUserDefaults(USERNAME);
            removeObjectFromUserDefaults(GesturesPassword);
        }
    }];
    //    [[WDHTTPSessionManager sharedManager] managerWithMethod:POST withURLString:@"login/getsid" withParams:params withSuccessBlock:^(id responseObject) {
    //        WDSessionIDModel *model = [WDSessionIDModel yy_modelWithJSON:responseObject];
    //        WDModelVerifyType verifyType = [NSObject modelVerifyWithDataModel:model];
    //        if (verifyType == WDModelVerifyTypeSucceess) {
    //            saveObjectToUserDefaults(model.sid, SID);
    //            if (successBlock) {
    //                successBlock(model);
    //            }
    //        } else if (verifyType == WDModelVerifyTypeFailureAccessToken) {
    //            [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
    //                [weakSelf querySessionIDWithSuccessBlock:^(id responseObj) {
    //                }
    //                    withFailureBlock:^{
    //
    //                    }];
    //            }
    //                withFailureBlock:^{
    //
    //                }];
    //        } else if (verifyType == WDModelVerifyTypeFailureSessionIDLoginTimeout) {
    //            WDLoginSuccessModel *loginSuccessModel1 = WDKeyedUnarchiverObjectWithFile(WDLOGIN_SUCCESS_INFO_FILE_PATCH);
    //            if (loginSuccessModel1.item.password == nil) {
    //                return;
    //            }
    //            NSDictionary *Params = @{ @"mobile": loginSuccessModel1.item.mobile,
    //                                      @"password": [WDEncrypt md5FromString:loginSuccessModel1.item.password],
    //                                      @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    //            [[WDHTTPSessionManager sharedManager] managerWithMethod:POST withURLString:@"login/login" withParams:Params withSuccessBlock:^(id responseObject) {
    //                WDLoginSuccessModel *loginSuccessModel = [WDLoginSuccessModel yy_modelWithJSON:responseObject];
    //
    //                WDModelVerifyType modelVerifyType = [NSObject modelVerifyWithDataModel:loginSuccessModel];
    //                if (modelVerifyType == WDModelVerifyTypeSucceess) {
    //                    loginSuccessModel.item.password = loginSuccessModel1.item.password;
    //
    //                    BOOL result = WDKeyedArchiverRootObject(loginSuccessModel, WDLOGIN_SUCCESS_INFO_FILE_PATCH);
    //                    if (result) {
    //                        NSLog(@"登录消息归档成功");
    //                    }
    //
    //                    saveObjectToUserDefaults(loginSuccessModel.item.userName, USERNAME);
    //                    saveObjectToUserDefaults(loginSuccessModel.item.mobile, MOBILE);
    //                    saveObjectToUserDefaults(loginSuccessModel.item.uid, UID);
    //                    saveObjectToUserDefaults(loginSuccessModel.item.sid, SID);
    //                    saveObjectToUserDefaults(loginSuccessModel.item.payPswStatus, PAYPSWSTATUS);
    //
    //                    if (successBlock) {
    //                        successBlock(model);
    //                    }
    //                }
    //            }
    //                withFailurBlock:^(NSError *error){
    //                }];
    //        } else {
    //            self.failureCount++;
    //            if (self.failureCount < 3) {
    //                [self querySessionIDWithSuccessBlock:^(id responseObj) {
    //
    //                }
    //                    withFailureBlock:^{
    //
    //                    }];
    //            } else {
    //                self.failureCount = 0;
    //                if (failureBlock) {
    //                    failureBlock();
    //                }
    //            }
    //        }
    //    }
    //        withFailurBlock:^(NSError *error) {
//                self.failureCount++;
//                if (self.failureCount < 3) {
//                    [self querySessionIDWithSuccessBlock:^(id responseObj) {
//    
//                    }
//                        withFailureBlock:^{
//    
//                        }];
//                } else {
//                    self.failureCount = 0;
//                    if (failureBlock) {
//                        failureBlock();
//                    }
//                }
    //        }];
}

@end
