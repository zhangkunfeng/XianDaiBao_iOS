//
//  ProductSectionView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/16.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherFinancialHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *descImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleTypeText;
@property (weak, nonatomic) IBOutlet UILabel *titleTypeDescText;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setViewController:(UIViewController *)viewController withType:(NSString *)type;
@end
