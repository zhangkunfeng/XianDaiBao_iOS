//
//  shareView.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/11/13.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  废弃

#import <UIKit/UIKit.h>

@protocol shareViewDelegate <NSObject>

- (void)UMengShare;

- (void)dismissShareView;

@end

@interface shareView : UIView {
    id<shareViewDelegate> Sharedelegate;
}

- (id)initWithShareViewDelegate:(id<shareViewDelegate>)theDelegate;
- (void)setDataWithShareView;
//@property (weak, nonatomic)id<shareViewDelegate> Sharedelegate;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabelText;
@property (weak, nonatomic) IBOutlet UILabel *blackyuan;

@end
