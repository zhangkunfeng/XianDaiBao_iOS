//
//  SignInHeaderView.m
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/8/28.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "SignInHeaderView.h"
#import "AlertSignSuccessInView.h"

@interface SignInHeaderView ()//<AlertSignSuccessInViewDelegate>
{
    BaseViewController *_viewController;
}

@property (weak, nonatomic) IBOutlet UIImageView *standingsImageView;//积分
@property (weak, nonatomic) IBOutlet UIImageView *standingsConvertImageView;//积分兑换
@property (weak, nonatomic) IBOutlet UIImageView *signInBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UILabel *signInIntegralLabel;//签到总积分

//@property (strong, nonatomic) AlertSignSuccessInView * alertSignSuccessInView;
- (IBAction)signInBtnClicked:(id)sender;
@end
@implementation SignInHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    self.standingsConvertImageView.userInteractionEnabled = YES;
    self.standingsImageView.userInteractionEnabled = YES;
}

- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController theDelegate:(id<SignInHeaderViewDelegate>)theDelegate
{
    if (![super init]) {
        return nil;
    }
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"SignInHeaderView" owner:self options:nil] lastObject];
    self.frame = viewFram;
    _viewController = (BaseViewController *) viewController;
    _delegate = theDelegate;
    
    [self addTapGestrue];
  
    return self;
}

- (void)addTapGestrue
{
    UITapGestureRecognizer * standingsImageViewTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(standingsImageViewTap:)];
    [self.standingsImageView addGestureRecognizer:standingsImageViewTap];
    
    UITapGestureRecognizer * standingsConvertImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(standingsConvertImageViewTap:)];
    [self.standingsConvertImageView addGestureRecognizer:standingsConvertImageViewTap];
}

- (void)standingsImageViewTap:(id)tapLeft
{
    NSLog(@"点击了积分模块");
}

- (void)standingsConvertImageViewTap:(id)tapRight
{
    NSLog(@"点击了积分兑换模块");
    if ([self.delegate respondsToSelector:@selector(ClickedClickIntegralShake)]) {
        [self.delegate ClickedClickIntegralShake];
    }
}

- (void)setSignInIntegralData:(NSString *)signInIntegralString
{
    self.signInIntegralLabel.text = [NSString stringWithFormat:@"%@",signInIntegralString];
}

- (void)setIsSignInData:(BOOL)isSignIn
{
    if (isSignIn) {
        [self.signInBtn setTitle:@"签到成功" forState:UIControlStateNormal];
    }
}

- (IBAction)signInBtnClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ClickedSignInBtn:)]) {
        [self.delegate ClickedSignInBtn:sender];
    }
    
    /* 代理回去做
     [sender setTitle:@"签到成功" forState:UIControlStateNormal];
    [_viewController showPopupWithStyle:CNPPopupStyleCentered popupView:self.alertSignSuccessInView];
    */
    
    
    /*  keywindow  猜测也应可以
    self.alertSignSuccessInView = [[AlertSignSuccessInView alloc] init];
    self.alertSignSuccessInView.delegate = self;
    self.alertSignSuccessInView.tag = 1500;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.alertSignSuccessInView];
    self.alertSignSuccessInView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alertSignSuccessInView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.alertSignSuccessInView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
     */
}
/*
#pragma  mark - alertSignSuccessInView
- (AlertSignSuccessInView *)alertSignSuccessInView
{
    if (!_alertSignSuccessInView) {
        _alertSignSuccessInView = [[AlertSignSuccessInView alloc] init];
        _alertSignSuccessInView.delegate = self;
    }
    return _alertSignSuccessInView;
}
 
#pragma  mark - alertSignSuccessInViewDelegate
- (void)closeSignInSuccessView
{
    [_viewController dismissPopupController];
}
*/
@end
