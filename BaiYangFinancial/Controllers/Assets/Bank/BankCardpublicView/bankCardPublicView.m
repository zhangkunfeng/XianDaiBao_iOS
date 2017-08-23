//
//  bankCardPublicView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "bankCardPublicView.h"

@implementation bankCardPublicView

- (id)initWithsetBank:(NSString *)bankCardIcon bankCardName:(NSString *)bankCardNameStr bankCardNumber:(NSString *)bankCardNumberStr bankCardStyle:(NSString *)bankCardStyleStr{
    self = [[[NSBundle mainBundle] loadNibNamed:@"bankCardPublicView" owner:self options:nil] lastObject];
    if (self) {
        //从plist文件中获取到存放银行卡信息的列表
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankListPlist" ofType:@"plist"];
        NSDictionary *bankListDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        //比较  需要注意：constainsObject内部在比较对象是否相等时采取的是地址比较。
       // 如果两个不同的地址而内容完全相等的对象采取containsObject默认比较返回结果是NO    (未出现)?
        if ([[bankListDict allKeys] containsObject:bankCardIcon]) {
            self.bankGroundView.hidden = NO;
            [self.bankCardIconImage setImage:[UIImage imageNamed:bankCardIcon]];
        }else{
            [self.bankCardIconImage setImage:[UIImage imageNamed:@"bankcardStyle_image.png"]];
        }
        
        self.bankCardName.text = bankCardNameStr;
        self.bankCardNumber.text = bankCardNumberStr;
        self.bankCardStyle.text = bankCardStyleStr;
    }
    CGRect rectFarm = self.frame;
    rectFarm.size.width = iPhoneWidth;
    self.frame = rectFarm;
    return self;
}

@end
