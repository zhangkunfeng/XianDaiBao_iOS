//
//  ChangeViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/1/12.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface ChangeViewController : BaseViewController <CustomUINavBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leiJLab;
@property (weak, nonatomic) IBOutlet UILabel *shengYuLab;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoLab;
@property (weak, nonatomic) IBOutlet UILabel *userLab;

@end
