//
//  MDbuyConfirmViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/18.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

@interface MDbuyConfirmViewController : BaseViewController
@property (copy, nonatomic) NSString *bidString;

@property (copy, nonatomic) NSDictionary *dict;

@property (assign, nonatomic) BOOL isOptimizationBid; //是否优选标

- (void)getmyRedenvelopeList;
@end
