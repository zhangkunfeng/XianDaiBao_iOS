//
//  ShortFinancialHeaderView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/17.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortFinancialHeaderView : UIView <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shortFinancialHeaderTableView;
@property (weak, nonatomic) IBOutlet UIImageView *descImageView;

- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController;
- (void)setData:(NSDictionary *)dict;

@end
