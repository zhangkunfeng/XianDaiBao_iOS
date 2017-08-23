//
//  UIView+Badge.h
//
//  Created by Joy Chiang on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#define JC_BADGE_VIEW_STANDARD_HEIGHT       20.0
#define JC_BADGE_VIEw_STANDARD_WIDTH        30.0
#define JC_BADGE_VIEw_MINIMUM_WIDTH         22.0
#define JC_BADGE_VIEW_FONT_SIZE             16.0

typedef enum {
    JCBadgeViewHorizontalAlignmentLeft = 0,
    JCBadgeViewHorizontalAlignmentCenter,
    JCBadgeViewHorizontalAlignmentRight,
    JCBadgeViewHorizontalAlignmentBasic
} JCBadgeViewHorizontalAlignment;

typedef enum {
    JCBadgeViewWidthModeStandard = 0,     // 30x20
    JCBadgeViewWidthModeSmall            // 22x20
} JCBadgeViewWidthMode;

@interface JCBadgeView : UIView

@property(nonatomic, copy) NSString *text;
@property(nonatomic, retain) UIColor *textColor;
@property(nonatomic, retain) UIColor *badgeColor;
@property(nonatomic, retain) UIColor *outlineColor;
@property(nonatomic, assign) CGFloat outlineWidth;
@property(nonatomic, assign) BOOL outline;
@property(nonatomic, assign) JCBadgeViewHorizontalAlignment horizontalAlignment;
@property(nonatomic, assign) JCBadgeViewWidthMode widthMode;
@property(nonatomic, assign) BOOL shadow;
@property(nonatomic, assign) BOOL shadowOfOutline;
@property(nonatomic, assign) BOOL shadowOfText;

+ (CGFloat)badgeHeight;

@end