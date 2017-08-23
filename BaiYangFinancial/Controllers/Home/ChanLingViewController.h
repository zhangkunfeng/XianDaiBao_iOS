//
//  ChanLingViewController.h
//  BaiYangFinancial
//
//  Created by dudu on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface ChanLingViewController : BaseViewController

@property (nonatomic, strong) NSString *sidStr;
@property (nonatomic, strong) NSString *uidStr;
@property (nonatomic, strong) NSString *tidStr;

@property (weak, nonatomic) IBOutlet UILabel *nHuaLab;

@property (weak, nonatomic) IBOutlet UILabel *yesTerDayLab;
@property (weak, nonatomic) IBOutlet UILabel *totalAmLab;
@property (weak, nonatomic) IBOutlet UILabel *remainingLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeBigLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeUserLab;

@end
