//
//  JCToast+UIView.h.h
//  JoyChiang
//
//  Created by Joy Chiang on 11-11-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface UIView (Toast)

- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(float)interval position:(id)point;
- (void)makeToast:(NSString *)message duration:(float)interval position:(id)point title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(float)interval position:(id)point title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(float)interval position:(id)point image:(UIImage *)image;

- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(float)interval position:(id)point;

@end