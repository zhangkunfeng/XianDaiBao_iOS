//
//  SXPersonInfoEntity.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "SXPersonInfoEntity.h"
/*
 
 @property(nonatomic,copy)NSString *firstname;
 @property(nonatomic,copy)NSString *lastname;
 @property(nonatomic,copy)NSString *fullname;
 @property(nonatomic,copy)NSString *company;
 @property(nonatomic,copy)NSString *phoneNumber;
 **/
@implementation SXPersonInfoEntity
/**
 * 重写 description 返回打印信息而不是地址
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",@{@"bookName":_bookName,@"mobile":_mobile,@"mobileId":_mobileId}];
}
- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@ : %p, %@>",[self class],self,@{@"bookName":_bookName,@"mobile":_mobile,@"mobileId":_mobileId}];
}
@end
