//
//  myAssetTableViewCell.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/21.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "myAssetTableViewCell.h"
#import "AssetDetailsViewController.h"

@implementation myAssetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ButtonAsset:(id)sender {
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"总资产包括" message:@"我的总资产  =  可用余额  +  提现中金额  +  投资冻结金额  +  待收总额" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}
@end
