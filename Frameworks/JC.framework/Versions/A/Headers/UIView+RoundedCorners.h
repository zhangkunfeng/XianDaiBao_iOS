//
//  UIView+RoundedCorners.h
//  LinXun
//
//  Created by Joy Chiang on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundedCorners)

- (UIImage *)snapshotImage;
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setRoundedCornersWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color;

@end