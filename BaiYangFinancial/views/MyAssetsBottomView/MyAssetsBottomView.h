//
//  MyAssetsBottomView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/11/27.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyAssetsButtonViewDelegate <NSObject>

- (void)exitUserBlock;

@end

@protocol MyAssetsBottomViewDelegate <NSObject>

- (void)weidaiFinancialPlannerViewTapped;

@end

@interface MyAssetsBottomView : UIView {
    id WaveView;
    id<MyAssetsButtonViewDelegate> delegate;
}

//@property (nonatomic, weak) id<MyAssetsBottomViewDelegate> delegate;


- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController theDelegate:(id<MyAssetsButtonViewDelegate>)theDelegate;

- (void)setMDAssetsView:(NSDictionary *)accountInfoDict;

- (void)setinitWithMDAssetsView;

- (void)initializeView;

@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gifImg;

@end

@interface MyAssetsBottomViewFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *serviceTelephoneViewAddGestrue;
@property (weak, nonatomic) IBOutlet UILabel *telephoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;

@property (copy, nonatomic) NSDictionary * serviceDict;

- (instancetype)initWithBottomViewFooterViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController;
- (void)setServicesValue:(NSDictionary *)servicesDict;

@end

