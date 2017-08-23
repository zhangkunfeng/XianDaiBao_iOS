//
//  Toast.h
//  Framework-iOS
//
//  Created by kiefer on 14-4-21.
//  Copyright (c) 2014年 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    ToastPositionTop = 1,
    ToastPositionCenter,
    ToastPositionBottom,
};

typedef NSUInteger ToastPosition;

@interface Toast : UIView

+ (void)makeText:(NSString *)message;
+ (void)makeText:(NSString *)message duration:(NSTimeInterval)duration;
+ (void)makeText:(NSString *)message duration:(NSTimeInterval)duration position:(ToastPosition)position;

+ (BOOL)isVisible;

+ (void)dismiss;

@end
