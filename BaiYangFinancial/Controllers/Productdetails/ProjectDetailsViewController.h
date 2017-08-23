
//  Created by ShinesZhao on 2016/12/2.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class ProductdetailsViewController;

@interface ProjectDetailsViewController : BaseViewController

@property (nonatomic, strong)ProductdetailsViewController *productdetail;
@property(nonatomic,copy) NSString * bidString;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
