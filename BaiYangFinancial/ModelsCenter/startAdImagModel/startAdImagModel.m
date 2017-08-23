//
//  startAdImagModel.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/2.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "startAdImagModel.h"

@implementation startAdImagModel

@synthesize image = _image;
@synthesize title = _title;
@synthesize url = _url;


- (id)initWithDictionary:(NSDictionary *)dic
{
    if((self = [super init])) {
        if (isKindOfNSDictionary(dic)) {
            self.tag = [[dic objectForKey:@"id"] integerValue];
            self.image = [dic objectForKey:@"path"];
            self.title = [dic objectForKey:@"title"];
            self.url = [dic objectForKey:@"urlLink"];
//            self.duration = [dic intValueForKey:@"duration"];
        }
    }
    return self;
}

@end
