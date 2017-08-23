//
//  XYErrorView.h
//  xycms
//
//  Created by 姚琪 on 15/12/2.
//  Copyright © 2015年 xycms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYErrorView : UIView

+ (void)showInView:(nonnull UITableView *)parentView title:(nullable NSString *)title;
+ (void)hideInView:(nonnull UITableView *)parentView;

@end
