//
//  InvestedUserTableViewCell.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/3.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "investedUserModel.h"

@interface InvestedUserTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *currentTenderAmountLable;
@property (weak, nonatomic) IBOutlet UILabel *InterestRateLable;
@property (weak, nonatomic) IBOutlet UILabel *tenderTimeLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;

//imageView
@property (weak, nonatomic) IBOutlet UIImageView *investRankingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investRankingImageViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investRankingImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investRankingImageViewHeight;


@property (nonatomic, strong)investedUserModel *investedModel;

@end
