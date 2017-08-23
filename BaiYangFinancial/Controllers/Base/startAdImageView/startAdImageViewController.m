//
//  startAdImageViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 16/3/4.
//  Copyright © 2016年 无名小子. All rights reserved.
//

#import "startAdImageViewController.h"
#import "SDImageCache.h"

@interface startAdImageViewController ()
{
    UIButton  * _skipButton;
    NSTimer   * _timer;
    NSInteger _duration;
}
@end

@implementation startAdImageViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setQLStatusBarStyleDefault];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self setQLStatusBarStyleLightContent];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _duration = 3;
    
    [self loadAdimage];
}

- (void)loadAdimage{
    
    NSString *imageURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"adImage.path"];
    UIImage *adImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageURL];
    
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:adImageView];
    
    if (adImage) {
        adImageView.image = adImage;
    }else{//无效
        adImageView.image = [UIImage imageNamed:@"暂无"];
    }
    
    adImageView.userInteractionEnabled = YES;//打开交互
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [adImageView addGestureRecognizer:tap];
    
    _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth-95, 28, 70, 35)];
    _skipButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
    _skipButton.layer.cornerRadius = 35/2;
    [_skipButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",(long)_duration] forState:UIControlStateNormal];
    [_skipButton addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [adImageView addSubview:_skipButton];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(skipButtonTitle)
                                            userInfo:nil
                                             repeats:YES];//YES 循环(耗内存) NO不走
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];//避免UIScrollView滑动timer停止 Default&scroll
//    [_timer fire];//立即执行
    
}

- (void)skipButtonTitle
{
    _duration--;
    if (_duration<1) {
        // 停止定时器
        [_timer invalidate];
        return;
    }
    [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",(long)_duration] forState:UIControlStateNormal];
}

- (void)skipButtonClicked:(id)sender
{
    [_timer invalidate];
    self.skipRemove(YES);
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap
{
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"adImage.url"]]) {
        [_timer invalidate];
        NSString *urlLink = [[NSUserDefaults standardUserDefaults] objectForKey:@"adImage.url"];
        NSString *titleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"adImage.title"];
        [self jumpToWebview:urlLink webViewTitle:titleStr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
