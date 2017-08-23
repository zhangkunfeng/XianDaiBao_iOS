//
//  CustomMadeNavigationControllerView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationButton.h"

@protocol DetailPageNavigationViewDelegate

- (void)goBack;

@optional
- (void)doOption;

@end

@interface DetailPageNavigationView : UIView {
    id<DetailPageNavigationViewDelegate> delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *CustomTitle;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet CustomNavigationButton *RightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnWidth;
@property (weak, nonatomic) IBOutlet UIView *NavigationView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

- (id)initWithDetailPageNavigationViewTitle:(NSString *)titleStr showBackButton:(BOOL)isShowButton showRightButton:(BOOL)isShowRightButton rightButtonTitle:(NSString *)rightButtonTile target:(id<DetailPageNavigationViewDelegate>)theTarget;

- (void)setupTitleStr:(NSString *)titleStr;

- (IBAction)goBackButtonAction:(id)sender;
- (IBAction)rightButtonAction:(id)sender;

@end
