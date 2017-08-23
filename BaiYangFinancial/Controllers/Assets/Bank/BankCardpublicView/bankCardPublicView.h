//
//  bankCardPublicView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bankCardPublicView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bankCardIconImage;
@property (weak, nonatomic) IBOutlet UILabel *bankCardName;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *bankCardStyle;

@property (weak, nonatomic) IBOutlet UIView *bankGroundView;

- (id)initWithsetBank:(NSString *)bankCardIcon bankCardName:(NSString *)bankCardNameStr bankCardNumber:(NSString *)bankCardNumberStr bankCardStyle:(NSString *)bankCardStyleStr;

@end
