//
//  CustomMadeNavigationControllerView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "CustomNavigationButton.h"
#import <UIKit/UIKit.h>

@protocol CustomUINavBarDelegate

- (void)goBack;

@optional
- (void)doOption;

@end

@interface CustomMadeNavigationControllerView : UIView {
    id<CustomUINavBarDelegate> delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *CustomTitle;
@property (weak, nonatomic) IBOutlet CustomNavigationButton *backButton;
@property (weak, nonatomic) IBOutlet CustomNavigationButton *RightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnWidth;
@property (weak, nonatomic) IBOutlet UIView *NavigationView;

- (id)initWithTitle:(NSString *)titleStr showBackButton:(BOOL)isShowButton showRightButton:(BOOL)isShowRightButton rightButtonTitle:(NSString *)rightButtonTile target:(id<CustomUINavBarDelegate>)theTarget;

- (IBAction)goBackButtonAction:(id)sender;
- (IBAction)rightButtonAction:(id)sender;

@end
