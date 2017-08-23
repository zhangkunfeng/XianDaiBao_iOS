//
//  JCProgressHUD.h
//
//  Created by Joy Chiang on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    JCProgressHUDMaskTypeNone = 1,
    JCProgressHUDMaskTypeClear,
    JCProgressHUDMaskTypeBlack,
    JCProgressHUDMaskTypeGradient
};

typedef NSUInteger JCProgressHUDMaskType;

@interface JCProgressHUD : UIView

+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(JCProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(JCProgressHUDMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString *)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString *)string;

+ (void)dismiss;
+ (void)dismissWithSuccess:(NSString *)successString;
+ (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString *)errorString;
+ (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

@end