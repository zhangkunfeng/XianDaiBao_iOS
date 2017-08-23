//
//  NSString+Crypto.h
//  Framework-iOS
//
//  Created by Teng Kiefer on 12-7-9.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Crypto)

+ (NSString *)GUIDString;

- (NSString *)MD5EncodedString;
- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
- (NSString *)base64EncodedString;
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

@end
