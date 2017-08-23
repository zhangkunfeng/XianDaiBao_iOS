//
//  NetManager.m
//  
//
//  Created by MrFeng on 14-11-7.
//  Copyright (c) 2014年 金鼎. All rights reserved.
//

#import "NetManager.h"
#import "NSFileManager+pathMethods.h"
#import "NSString+Hashing.h"//md5加密
#import "GTMBase64.h"

@implementation NetManager
//请求的封装方法
+(void)requestWithUrlString:(NSString *)urlString andDic:(NSDictionary *)dic finished:(AFFinishedBlock)finishedBlock failed:(AFFailedBlock)failedBlock{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",[urlString MD5Hash]];
    //需要考虑缓存
    //如果指定路径下文件存在，并且没有超出规定时间
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]&&[NSFileManager isTimeoutWithPath:path time:2*60]==NO) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        //直接将数据传出
        finishedBlock(nil,data);
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:urlString parameters:dic success:finishedBlock failure:failedBlock];
    }
}

/*!
 @plainText         要加密的文本
 @encryptOrDecrypt  选择哪种方式加密( GTBase64 / 非)
 @key               传入 key
 
 @还有一种 ivkey      NSString *initVec = @"12345678";   写死到里面了
 */
//加密过程
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
//        NSString *key = @"123456789012345678901234";
//    NSString *initVec = @"p2p_s2iv";
    NSString *initVec = @"12345678";  /* 这个是另一个要传的参数   这里写死了 */
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding]
                  ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}

//+(NSString *) doCipher:(NSString *)plainText operation:(CCOperation)encryptOrDecrypt
//{
//    const void * vplainText;
//    size_t plainTextBufferSize;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        NSData * EncryptData = [GTMBase64 decodeData:[plainText
//                                                      dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        plainTextBufferSize = [EncryptData length];
//        vplainText = [EncryptData bytes];
//    }
//    else
//    {
//        NSData * tempData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//        plainTextBufferSize = [data length];
//        vplainText = [tempData bytes];
//    }
//    
//    CCCryptorStatus ccStatus;
//    uint8_t * bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    // uint8_t ivkCCBlockSize3DES;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES)
//    & ~(kCCBlockSize3DES - 1);
//    
//    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    NSString * key = @"123456789012345678901234";
//    NSString * initVec = @"init Vec";
//    
//    const void * vkey = (const void *)[key UTF8String];
//    const void * vinitVec = (const void *)[initVec UTF8String];
//    
//    uint8_t iv[kCCBlockSize3DES];
//    memset((void *) iv, 0x0, (size_t) sizeof(iv));
//    
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding,
//                       vkey, //"123456789012345678901234", //key
//                       kCCKeySize3DES,
//                       vinitVec, //"init Vec", //iv,
//                       vplainText, //plainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
//    if (ccStatus == kCC ParamError) return @"PARAM ERROR";
//    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
//    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
//    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
//    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
//    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
//    
//    NSString * result;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        result = [[[NSString alloc] initWithData:[NSData
//                                                  dataWithBytes:(const void *)bufferPtr
//                                                  length:(NSUInteger)movedBytes] 
//                                        encoding:NSUTF8StringEncoding]
//                  autorelease];
//    }
//    else
//    {
//        NSData * myData = [NSData dataWithBytes:(const void *)bufferPtr
//                                         length:(NSUInteger)movedBytes];
//        
//        result = [GTMBase64 stringByEncodingData:myData];
//    }
//    
//    return result;
//    
//}

@end
