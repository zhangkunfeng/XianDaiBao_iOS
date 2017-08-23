//
//  ImageLocalCache.h
//  TYReader
//
//  Created by Joy Chiang on 12-1-4.
//  Copyright (c) 2012年 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NSString+Crypto.h"

static inline NSString *keyForURL(NSURL *url, NSString *style) 
{
	if (style) {
		return [NSString stringWithFormat:@"ImageLoader-%u-%u", [[url description] hash], [style hash]];
	} else {
        return [[NSString stringWithFormat:@"%@", url] MD5EncodedString];
	}
}

@interface JCImageCache : NSObject 
{
@private
	NSMutableDictionary *cacheDictionary;
	NSOperationQueue *diskOperationQueue;
	NSTimeInterval defaultTimeoutInterval;
    NSMutableDictionary *imageCacheDictionary;
}

@property(nonatomic, assign) NSTimeInterval defaultTimeoutInterval;

+ (JCImageCache *)sharedImageCache;

- (void)clearCache;
- (BOOL)hasCacheForKey:(NSString *)key;
- (void)removeCacheForKey:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (NSData *)plistForKey:(NSString *)key;
- (void)setPlist:(id)plistObject forKey:(NSString *)key;
- (void)setPlist:(id)plistObject forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (NSString *)stringForKey:(NSString *)key;
- (void)setString:(NSString *)aString forKey:(NSString *)key;
- (void)setString:(NSString *)aString forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (UIImage *)imageForKey:(NSString *)key;
- (UIImage *)imageForURLString:(NSString *)urlString;

- (void)setImage:(UIImage *)anImage forKey:(NSString *)key;
- (void)setImage:(UIImage *)anImage forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (void)copyFilePath:(NSString *)filePath asKey:(NSString *)key;
- (void)copyFilePath:(NSString *)filePath asKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;	

@end