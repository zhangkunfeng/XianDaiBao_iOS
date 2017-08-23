//
//  startAdImagModel.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/2.
//  Copyright © 2016年 无名小子. All rights reserved.
//  开始图片模型


#import <Foundation/Foundation.h>

@interface startAdImagModel : NSObject

@property(nonatomic) NSInteger tag;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *url;

@property(nonatomic) NSInteger duration;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
