//
//  NSFileManager+pathMethods.h
//  
//
//  Created by MrFeng on 14-11-7.
//  Copyright (c) 2014年 金鼎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (pathMethods)
//判断指定路径下的文件有效期是否超过了规定的时间
+(BOOL)isTimeoutWithPath:(NSString *)path time:(NSTimeInterval)time;
@end
