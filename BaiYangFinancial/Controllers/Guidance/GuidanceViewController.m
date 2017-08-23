//
//  GuidanceViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/5.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "GuidanceViewController.h"

#define Guiding_TotalCount              3  // 修改新手引导页面的图片总数
#define Guiding_Max_Alpha               1
#define Guiding_Min_Alpha               0.75
#define Guiding_Min_OffSetToStart       50
#define Guiding_OffSetRate              100

#define Guiding_Animation_Duration      1.2
#define Guiding_Min_MainPage_Alpha      0.0

@interface GuidanceViewController ()

@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
}

- (void)initBaseData
{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    NSString * exStr = @"";
//    if (iPhoneHeight <= 480)
//    {
//        exStr = @"_ip4";
//    }
    for (int i = 1; i <= Guiding_TotalCount; i++)
    {
        UIImageView * imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guiding_img_%d%@.jpg",i,exStr]]];
        imageV.frame = CGRectMake(0+width*(i-1), 0, width, height);
//        float distanceBottom = 15;
//        distanceBottom = distanceBottom * [UIScreen mainScreen].bounds.size.height/1920;
//        if ([UIScreen mainScreen].bounds.size.width >= 414)
//        {
//            distanceBottom = 12;
//        }
        if (i == Guiding_TotalCount)
        {
            /***
            UIButton * skipBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [skipBtn addTarget:self
                        action:@selector(startEnjoyApp)
              forControlEvents:(UIControlEventTouchUpInside)];
            skipBtn.frame = CGRectMake((iPhoneWidth - 200) / 2, iPhoneHeight - 47 - iPhoneHeight*0.16, 200, 47);
            if (exStr.length != 0)
            {
                skipBtn.frame = CGRectMake((iPhoneWidth - 148) / 2, iPhoneHeight - 34 - iPhoneHeight*0.16, 148, 34);
            }
            [skipBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"guiding_skipBtn%@",exStr]]
                               forState:(UIControlStateNormal)];
            [imageV addSubview:skipBtn];
             */
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [imageV addGestureRecognizer:tap];
            
            [imageV setUserInteractionEnabled:YES];
//            skipBtn.center = CGPointMake(CGRectGetWidth(imageV.frame)/2, CGRectGetHeight(imageV.frame) - CGRectGetHeight(skipBtn.frame)/2-distanceBottom);
        }
        [self.guidingScrollView addSubview:imageV];
    }
    [self.guidingScrollView setContentSize:CGSizeMake(width*Guiding_TotalCount,1)];
}
- (void)tapAction
{
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) wSelf = self;
    [UIView animateWithDuration:Guiding_Animation_Duration
                     animations:^{
                         self.view.alpha = Guiding_Min_MainPage_Alpha;
                         [self.view setTransform:(CGAffineTransformMakeScale(1.5, 1.5))];
                         //刷新首页数据
                         [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:@"测试通知内容:之后未取值,不影响"];
                     } completion:^(BOOL finished) {
                         [wSelf.view removeFromSuperview];
                         if (_delegate && [_delegate respondsToSelector:@selector(guidingViewWillDisappear)])
                         {
                             [_delegate guidingViewWillDisappear];
                         }
                     }];

}

/***
- (void)startEnjoyApp
{
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) wSelf = self;
    [UIView animateWithDuration:Guiding_Animation_Duration
                     animations:^{
                         self.view.alpha = Guiding_Min_MainPage_Alpha;
                         [self.view setTransform:(CGAffineTransformMakeScale(1.5, 1.5))];
                     } completion:^(BOOL finished) {
                         [wSelf.view removeFromSuperview];
                         if (_delegate && [_delegate respondsToSelector:@selector(guidingViewWillDisappear)])
                         {
                             [_delegate guidingViewWillDisappear];
                         }
                     }];
}
*/
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0)
    {
        scrollView.alpha = (Guiding_Max_Alpha+scrollView.contentOffset.x/Guiding_OffSetRate>Guiding_Min_Alpha)?(Guiding_Max_Alpha+scrollView.contentOffset.x/Guiding_OffSetRate):Guiding_Min_Alpha;
    }
    else if (scrollView.contentOffset.x >= scrollView.contentSize.width-scrollView.frame.size.width)
    {
        scrollView.alpha = (Guiding_Max_Alpha- (scrollView.contentOffset.x-scrollView.contentSize.width+scrollView.frame.size.width)/Guiding_OffSetRate>Guiding_Min_Alpha)?(Guiding_Max_Alpha- (scrollView.contentOffset.x-scrollView.contentSize.width+scrollView.frame.size.width)/Guiding_OffSetRate):Guiding_Min_Alpha;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ((scrollView.contentOffset.x >= scrollView.contentSize.width-scrollView.frame.size.width+Guiding_Min_OffSetToStart) && decelerate)
    {
       /* [self startEnjoyApp]; */
        [self tapAction];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
