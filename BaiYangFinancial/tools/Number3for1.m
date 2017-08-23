//
//  Number3for1.m
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/6/29.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "Number3for1.h"

@implementation Number3for1
+ (NSString*) formatAmount:(NSString*)number
{
    NSMutableString *resultStr = [NSMutableString stringWithFormat:@"%.2f",[number doubleValue]];
    
    BOOL bellowZearo = NO;
    if ([number doubleValue]<0)
    {
        bellowZearo = YES;
        [resultStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    int count = ([resultStr length]-1)/3-2;
    int mod = [resultStr length]%3==0?3:[resultStr length]%3;
    
    for (int i=0; i<=count; i++)
    {
        [resultStr insertString:@"," atIndex:mod+3*(count-i)];
    }
    
    if (bellowZearo)
    {
        [resultStr insertString:@"-" atIndex:0];
    }
    
    return resultStr;
}

//替换下,
+ (NSString *)forDelegateChar:(NSString *)str
{
//    NSString * userSurplusMoney = [self.dict[@"userSurplusMoney"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    return [str stringByReplacingOccurrencesOfString:@"," withString:@""];
}


//label 替换中间颜色文字 未试
+(NSMutableAttributedString *)addyourString:(NSString *)yourString withTextColor1:(UIColor *)textColor1 andTextColor2:(UIColor *)textColor2 rangeString1:(NSString *)rangeString1 andrangeString2:(NSString *)rangeString2
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:yourString];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:rangeString1];
    [hintString addAttribute:NSForegroundColorAttributeName value:textColor1 range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:rangeString2];
    [hintString addAttribute:NSForegroundColorAttributeName value:textColor2 range:range2];
    
//    hintLabel.attributedText=hintString;
    return hintString;
}


+(NSString *)forNumMoeny:(NSString *)nummoeny{
    double money = [nummoeny doubleValue];
    
    // 如果后面有000则显示万元，否则返回原数据
    if ([nummoeny hasSuffix:@"00"]) {
        NSString *result;
        if ([nummoeny hasSuffix:@"000000"]) {
            money = money/100000000;
            result = [NSString stringWithFormat:@"%.2f亿元",money];
        }else{
            money = money/10000;
            result = [NSString stringWithFormat:@"%.2f万元",money];
        }
        if ([result hasSuffix:@"0"]) {
            result = [result substringToIndex:result.length];
        }
        return result;
    }else{
        double acount = money/10000;
        return acount<1?
        [NSString stringWithFormat:@"%.2f元",[nummoeny floatValue]]
        :[NSString stringWithFormat:@"%.2f万元",acount];

//        return [NSString stringWithFormat:@"%@元",nummoeny];
    }
}

+ (NSString *)forMoenyString:(NSString *)num{
    float acount = [num floatValue]/10000;
    return acount<1?
    [NSString stringWithFormat:@"%.2f",[num floatValue]]
    :[NSString stringWithFormat:@"%.2f万",acount];
}


@end
