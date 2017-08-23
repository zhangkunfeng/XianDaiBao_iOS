//
//  myAssetTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/21.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myAssetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myAssetLab;//资产总额
- (IBAction)ButtonAsset:(id)sender;

@end
