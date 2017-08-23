//
//  PayYesViewController.h
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/7.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
@interface PayYesViewController : BaseViewController<CustomUINavBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tMoenyLab;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UILabel *teleLab;
@property (nonatomic, strong) NSString *moen;

@end
