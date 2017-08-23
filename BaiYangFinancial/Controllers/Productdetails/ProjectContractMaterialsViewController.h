//
//  ProjectContractMaterialsViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/5.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class ProductdetailsViewController;

@interface ProjectContractMaterialsViewController : BaseViewController

@property(nonatomic, strong)ProductdetailsViewController *productdetail;
@property(nonatomic,copy) NSString * bidString;
@property(nonatomic,copy) NSString * bidTypeId;
@property(nonatomic,assign) BOOL isShowPic;

@end
