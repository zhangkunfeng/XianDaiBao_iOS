//
//  WDToastUtil.m
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/4/20.
//  Copyright © 2016年 白杨（杭州）有限公司. All rights reserved.
//

#import "WDToastUtil.h"
#import "MBProgressHUD.h"

@implementation WDToastUtil

+ (void)toast:(NSString *)message {
    UIWindow *keyView = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [self toast:message inWindow:keyView];
}

+ (void)toast:(NSString *)message inWindow:(UIWindow *)window {
    if (window == nil)
        return;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.detailsLabelText = message;
    [hud showAnimated:true whileExecutingBlock:^{
        int time = (int) message.length / 10;
        time = MAX(WDToastShowTime, time);
        time = MIN(time, 5);
        sleep(time);
    }
        completionBlock:^{
            [hud removeFromSuperview];
        }];
}

+ (void)toast:(NSString *)message inView:(UIView *)view {
    if (view == nil)
        return;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.detailsLabelText = message;
    [hud showAnimated:true whileExecutingBlock:^{
        int time = (int) message.length / 10;
        time = MAX(WDToastShowTime, time);
        time = MIN(time, 5);
        sleep(time);
    }
        completionBlock:^{
            [hud removeFromSuperview];
        }];
}

+ (void)toastMsg:(NSString *)message image:(UIImage *)image inWindow:(UIWindow *)window {
    if (window == nil)
        return;
    NSAssert(image, @"%@: image is nil", self);
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, 30, 30);
    hud.customView = imageView;
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //hud.yOffset = 50.0f;
    //HUD.xOffset = 100.0f;
    [hud showAnimated:true whileExecutingBlock:^{
        int time = (int) message.length / 10;
        time = MAX(WDToastShowTime, time);
        time = MIN(time, 5);
        sleep(time);
    }
        completionBlock:^{
            [hud removeFromSuperview];
        }];
}

+ (void)toastMsg:(NSString *)message image:(UIImage *)image inView:(UIView *)view {
    if (view == nil)
        return;
    NSAssert(image, @"%@: image is nil", self);
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, 30, 30);
    hud.customView = imageView;
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //hud.yOffset = 50.0f;
    //HUD.xOffset = 100.0f;
    [hud showAnimated:true whileExecutingBlock:^{
        int time = (int) message.length / 10;
        time = MAX(WDToastShowTime, time);
        time = MIN(time, 5);
        sleep(time);
    }
        completionBlock:^{
            [hud removeFromSuperview];
        }];
}

+ (void)toastSuccessMsg:(NSString *)message inView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"MBProgressHUD.bundle/success.png"];
    [self toastMsg:message image:image inView:view];
}

+ (void)toastErrorMsg:(NSString *)message inView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"MBProgressHUD.bundle/error.png"];
    [self toastMsg:message image:image inView:view];
}

@end
