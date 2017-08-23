//
//  NSString+CustomNil.m
//  BaiYangFinancial
//
//  Created by yaoqi on 16/3/21.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "NSString+CustomNil.h"

@implementation NSString (CustomNil)
//置空
+ (NSString *)stringWithJsonStringAtNillIfNull:(NSString *)tempString {
    NSString *string = [NSString stringWithFormat:@"%@", tempString];
    if ([string isEqual:[NSNull null]] || string == nil || [string isEqualToString:@"null"] || [string isEqualToString:@"<null>"]) {
        return @"";
    }
    return string;
}

@end
