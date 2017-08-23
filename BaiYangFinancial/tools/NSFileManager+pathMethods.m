//
//  NSFileManager+pathMethods.m
//  
//
//  Created by MrFeng on 14-11-7.
//  Copyright (c) 2014年 金鼎. All rights reserved.
//

#import "NSFileManager+pathMethods.h"

@implementation NSFileManager (pathMethods)
+(BOOL)isTimeoutWithPath:(NSString *)path time:(NSTimeInterval)time{
    //获取指定路径下文件的所有属性
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    //获取文件的修改时间
    NSDate *moDate =[dic objectForKey:NSFileModificationDate];
    NSDate *date = [NSDate date];
    NSTimeInterval timeOut =[date timeIntervalSinceDate:moDate];
    if (timeOut>time) {
        //超时
        return YES;
    }else{
        return NO;
    }
}
@end
