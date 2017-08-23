//
//  HomeCollectionViewCell.h
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/27.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *TITLE;
@property (weak, nonatomic) IBOutlet UILabel *nianHuaLab;
@property (weak, nonatomic) IBOutlet UILabel *dataLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBttn;
@property (copy, nonatomic) void(^finishAction)();
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (weak, nonatomic) IBOutlet UILabel *tianLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateDescBottomRate;

@end
