//
//  WDQueryAccessToken.m
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/4/13.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#define MONTH @"2000"
#define PRIVATE @"c9b8223ec1d91201b6f4ce350316852d20151203weidai"
#define PRIVATE1 @"weixufang+aiyunwang+zhy"

#import "WDQueryAccessToken.h"

@interface WDQueryAccessToken ()

@property (nonatomic, assign) NSInteger failureCount;

@end

@implementation WDQueryAccessToken

DEF_SINGLETON(WDQueryAccessToken)

- (instancetype)init {
    self = [super init];
    if (self) {
        self.failureCount = 0;
    }
    return self;
}

- (void)queryAccessTokenWithSuccessBlock:(void (^)(id responseObj))successBlock withFailureBlock:(void (^)())failureBlock {

    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@sysAuth/sysTk", GeneralWebsite] parameters:accessTokenParams() success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            saveObjectToUserDefaults(responseObject[@"at"], ACCESSTOKEN);
            if (successBlock) {
                successBlock(responseObject);
            }
        } else {
            self.failureCount++;
            if (self.failureCount < 3) {
                [self queryAccessTokenWithSuccessBlock:^(id responseObj) {

                }
                    withFailureBlock:^{

                    }];
            } else {
                self.failureCount = 0;
                if (failureBlock) {
                    failureBlock();
                }
                NSLog(@"获取access_token 业务失败");
            }
        }
    }
        fail:^{
            self.failureCount++;
            if (self.failureCount < 3) {
                [self queryAccessTokenWithSuccessBlock:^(id responseObj) {

                }
                    withFailureBlock:^{

                    }];
            } else {
                self.failureCount = 0;
                if (failureBlock) {
                    failureBlock();
                }
                NSLog(@"获取access_token 业务失败");
            }
        }];
}

static force_inline NSDateFormatter *WDDateFormatter() {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
    });
    return formatter;
}

static force_inline NSDictionary *accessTokenParams() {
    NSString *currentTime = [WDDateFormatter() stringFromDate:[NSDate date]];

    NSString *data = [NSString stringWithFormat:@"%@%@%@%@", [currentTime substringWithRange:NSMakeRange(0, 1)],
                                                [currentTime substringWithRange:NSMakeRange(3, 1)],
                                                [currentTime substringWithRange:NSMakeRange(7, 1)],
                                                [currentTime substringWithRange:NSMakeRange(10, 4)]];

    NSString *tag = [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@%@%@", data, MONTH, PRIVATE, [WDEncrypt md5FromString:PRIVATE1]]];

    NSString *sigin = [NSString stringWithFormat:@"%@%@%@",
                                                 [[WDEncrypt base64EncodedStringFromString:currentTime] substringWithRange:NSMakeRange(0, 1)],
                                                 randomBase64StringFromRange12(),
                                                 [[WDEncrypt base64EncodedStringFromString:currentTime] substringWithRange:NSMakeRange(1, [WDEncrypt base64EncodedStringFromString:currentTime].length - 1)]];

    NSDictionary *params = @{
        @"app_id": @"baiyang",
        @"secret": @"baiyang",
        @"tag": tag,
        @"sign": sigin
    };
    return params;
}

static force_inline NSString *randomBase64StringFromRange12() {
    NSString *strRandom = @"";
    for (int i = 0; i < 12; i++) {
        strRandom = [strRandom stringByAppendingFormat:@"%i", (arc4random() % 9)];
    }
    return [[WDEncrypt base64EncodedStringFromString:strRandom] substringWithRange:NSMakeRange(0, 12)];
}

@end
