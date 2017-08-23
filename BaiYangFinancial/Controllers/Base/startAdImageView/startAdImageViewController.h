//
//  startAdImageViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/4.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^skipRemoveBlock)(BOOL isRemove);

@interface startAdImageViewController : BaseViewController

@property (nonatomic, copy)skipRemoveBlock skipRemove;

@end
