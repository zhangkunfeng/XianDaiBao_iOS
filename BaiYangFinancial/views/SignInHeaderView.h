//
//  SignInHeaderView.h
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/8/28.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInHeaderViewDelegate <NSObject>

@required
- (void)ClickedSignInBtn:(UIButton *)btn;
- (void)ClickedClickIntegralShake;
@end
@interface SignInHeaderView : UIView

@property (nonatomic, weak)id <SignInHeaderViewDelegate> delegate;

- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController theDelegate:(id<SignInHeaderViewDelegate>)theDelegate;

- (void)setSignInIntegralData:(NSString *)signInIntegralString;

- (void)setIsSignInData:(BOOL)isSignIn;
@end
