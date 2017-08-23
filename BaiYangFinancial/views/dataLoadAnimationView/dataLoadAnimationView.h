//
//  dataLoadAnimationView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dataLoadAnimationView : UIView{
    NSTimer *myTimer;
    NSInteger LoadNumber;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dataLoadActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *loadTextLable;

- (id)initWithdataLoadAnimationView;

- (void)stratImageAnimating;

- (void)stopImageAnimating;


@end
