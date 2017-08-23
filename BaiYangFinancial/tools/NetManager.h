//
//  NetManager.h
//  
//
//  Created by MrFeng on 14-11-7.
//  Copyright (c) 2014年 金鼎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import <CommonCrypto/CommonCryptor.h>

//#define K3DESKey  @"p2p_standard2_base64_key"
//#define K3DESKey @"123456781234567812345678"
#define K3DESKey @"123456781234567812345678"
@interface NetManager : NSObject


//调度afnetworking请求
//请求成功
typedef void(^AFFinishedBlock)(AFHTTPRequestOperation *oper,id responseObj);
//请求失败
typedef void(^AFFailedBlock)(AFHTTPRequestOperation *oper,NSError *error);

//对外暴露类方法,根据请求地址请求数据
+(void)requestWithUrlString:(NSString *)urlString andDic:(NSDictionary *)dic finished:(AFFinishedBlock)finishedBlock failed:(AFFailedBlock)failedBlock;

//3DES加密
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;



@end
