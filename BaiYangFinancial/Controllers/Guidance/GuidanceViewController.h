//
//  GuidanceViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/5.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  新手引导界面

#import "BaseViewController.h"

@protocol GuidanceViewControllerDelegate <NSObject>

@optional
- (void)guidingViewWillDisappear;

@end

@interface GuidanceViewController : BaseViewController<UIScrollViewDelegate>

@property (nonatomic, weak)IBOutlet UIScrollView *guidingScrollView;

@property (nonatomic,assign) id<GuidanceViewControllerDelegate> delegate;

@end
