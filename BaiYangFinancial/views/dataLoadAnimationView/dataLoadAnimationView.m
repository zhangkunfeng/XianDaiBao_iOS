//
//  dataLoadAnimationView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "dataLoadAnimationView.h"

@implementation dataLoadAnimationView

- (id)initWithdataLoadAnimationView{
    self = [[[NSBundle mainBundle] loadNibNamed:@"dataLoadAnimationView" owner:self options:nil] lastObject];
    if (self) {
        LoadNumber = 0;
        
        CGRect rectFarm = self.frame;
        rectFarm.origin.y = 64;
        rectFarm.size.width = iPhoneWidth;
        rectFarm.size.height = iPhoneHeight - 64;
        self.frame = rectFarm;
        
       
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getMYmessageNumber) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)stratImageAnimating{
    self.layer.hidden = NO;
    [self.dataLoadActivityIndicatorView startAnimating];
    //打开定时器
    [myTimer setFireDate:[NSDate distantPast]];
}


- (void)getMYmessageNumber{
    if (LoadNumber < 3) {
        switch (LoadNumber) {
            case 0:{
                self.loadTextLable.text = @"加载中.";
            }
                break;
            case 1:{
                self.loadTextLable.text = @"加载中..";
            }
                break;
            case 2:{
                self.loadTextLable.text = @"加载中...";
            }
                break;
            default:
                break;
        }
        LoadNumber++;
    }else{
        LoadNumber = 0;
    }
}

- (void)stopImageAnimating{
    self.dataLoadActivityIndicatorView.hidden = YES;
    [self.dataLoadActivityIndicatorView stopAnimating];
    //关闭定时器
    [myTimer setFireDate:[NSDate distantFuture]];
}

@end
