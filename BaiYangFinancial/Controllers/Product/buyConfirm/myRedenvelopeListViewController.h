//
//  myRedenvelopeListViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/17.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RedenvelopeListBlock)(NSDictionary *dict);

@interface myRedenvelopeListViewController : BaseViewController

@property (copy, nonatomic) RedenvelopeListBlock block_RedenvelopeList;
@property (copy, nonatomic) NSMutableArray *dataArray;

@end
