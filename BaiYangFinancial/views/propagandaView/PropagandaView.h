//
//  PropagandaView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/10.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PropagandaViewDelegate <NSObject>

//-(void)clickedImagesAction:(NSString *)imageTitle;
-(void)cancelPropagandaViewBtnClicked;

@end

@interface PropagandaView : UIView

@property (nonatomic, weak) id<PropagandaViewDelegate> delegate;

- (void)setPropagandaImagesArray:(NSArray *)array viewController:(UIViewController *)viewController;

@end
