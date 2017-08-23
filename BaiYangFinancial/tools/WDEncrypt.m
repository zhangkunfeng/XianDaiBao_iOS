//
//  WDEncrypt.m
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/4/12.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import "WDEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WDEncrypt

+ (NSString *)md5FromString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int) strlen(cStr), result); // This is the md5 call
    return [NSString
        stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5],
            result[6], result[7], result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (NSString *)base64EncodedStringFromString:(NSString *)string {
    NSData *data = [NSData
        dataWithBytes:[string UTF8String]
               length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData =
        [NSMutableData dataWithLength:((length + 2) / 3) * 4];

    uint8_t *input = (uint8_t *) [data bytes];
    uint8_t *output = (uint8_t *) [mutableData mutableBytes];

    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        static uint8_t const kAFBase64EncodingTable[] =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length
                              ? kAFBase64EncodingTable[(value >> 6) & 0x3F]
                              : '=';
        output[idx + 3] = (i + 2) < length
                              ? kAFBase64EncodingTable[(value >> 0) & 0x3F]
                              : '=';
    }

    return [[NSString alloc] initWithData:mutableData
                                 encoding:NSASCIIStringEncoding];
}

+ (NSString *)sha1:(NSString *)input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (int) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

@end
