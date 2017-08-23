//
//  myRedenvelopeModel.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/16.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "NSString+CustomNil.h"
#import "myRedenvelopeModel.h"

@implementation myRedenvelopeModel

@synthesize RedenvelopeMinAount;
@synthesize RedenvelopeStatus;
@synthesize RedenvelopeMoney;
@synthesize RedenvelopeTime;
@synthesize RedenvelopeTitle;
@synthesize RedenvelopeMaxRatio;
@synthesize RedenvelopeEndTime;
@synthesize minDeadline;
@synthesize redpackSource;
/*
 dict === {
	comboName = <null>,
	maxRatio = 100,
	minAmount = 500,
	amount = 10,
	redPacketName = 新手大礼包3,
	pastDueTime = 2016-09-23 23:59:59,
	getTime = 2016-06-16 11:12:23,
	minDeadline = 1,
	validTime = 99,
	endTime = 76,
	activityName = <null>,
	recordId = <null>,
	status = 2
 }
 */

- (instancetype)initWithmyRedenvelopeModel:(NSDictionary *)dict {
    if (self = [super init]) {
        self.RedenvelopeTitle = [NSString stringWithJsonStringAtNillIfNull:dict[@"redPacketName"]];
        self.RedenvelopeID = dict[@"recordId"];
        self.RedenvelopeMinAount = [NSString stringWithFormat:@"%zd元", [[NSString stringWithJsonStringAtNillIfNull:dict[@"minAmount"]] integerValue]];
        self.RedenvelopeStatus = [NSString stringWithFormat:@"%zd", [dict[@"status"] integerValue]];
        self.RedenvelopeTime = [NSString stringWithFormat:@"有效期至%@", [dict[@"pastDueTime"] substringWithRange:NSMakeRange(0, 10)]];
        self.RedenvelopeMoney = [NSString stringWithFormat:@"%.0f", [dict[@"amount"] floatValue]];
        self.RedenvelopeMaxRatio = [[NSString stringWithJsonStringAtNillIfNull:dict[@"maxRatio"]] floatValue];//不能删
        self.minDeadline = [NSString stringWithFormat:@"%@", dict[@"minDeadline"]];//起投天数
        self.RedenvelopeEndTime = [NSString stringWithJsonStringAtNillIfNull:dict[@"endTime"]];//有效天数
        
        self.redpackSource = [NSString stringWithJsonStringAtNillIfNull:dict[@"redpackSource"]];//红包类型
    }
    return self;
}
@end
