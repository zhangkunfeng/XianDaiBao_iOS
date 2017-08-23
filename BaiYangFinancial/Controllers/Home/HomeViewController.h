//
//  HomeViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

@property (nonatomic, assign)BOOL isHaveDiscovery;//中转传值 传发现页面  消息
@property (nonatomic ,copy) NSString * total;     //消息数量


@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

- (IBAction)messageBtnClicked:(id)sender;




@end
