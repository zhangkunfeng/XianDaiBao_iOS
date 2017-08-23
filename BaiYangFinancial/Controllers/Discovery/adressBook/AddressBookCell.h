//
//  AddressBookCell.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/10/24.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPersonInfoEntity.h"
@interface AddressBookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *IconLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIButton *AddBtn;
@property (weak, nonatomic) IBOutlet UILabel *MobileLabel;

+ (id)AdressBookTableViewCell;
+ (NSString *)AdressBookTableViewID;
+ (CGFloat)AdressBookTableViewCellHeight;

@end
