//
//  UIPopView.h
//  JoyChiang
//
//  Created by Joy Chiang on 11-11-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	PointDirectionUp = 0,
	PointDirectionDown
} PointDirection;

typedef enum {
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop
} CMPopTipAnimation;

@protocol UIPopViewDelegate;

@interface JCPopView : UIView {
	UIColor					*backgroundColor;
	id<UIPopViewDelegate>	delegate;
	NSString				*message;
	id						targetObject;
	UIColor					*textColor;
	UIFont					*textFont;
    CMPopTipAnimation       animation;
    BOOL                    isShow;
    
@private
	CGSize					bubbleSize;
	CGFloat					cornerRadius;
	BOOL					highlight;
	CGFloat					sidePadding;
	CGFloat					topMargin;
	PointDirection			pointDirection;
	CGFloat					pointerSize;
	CGPoint					targetPoint;
}

@property(nonatomic, retain)			UIColor					*backgroundColor;
@property(nonatomic, assign)            id<UIPopViewDelegate>	delegate;
@property(nonatomic, retain)			NSString				*message;
@property(nonatomic, retain, readonly)	id						targetObject;
@property(nonatomic, retain)			UIColor					*textColor;
@property(nonatomic, retain)			UIFont					*textFont;
@property(nonatomic, assign)            CMPopTipAnimation       animation;
@property(nonatomic, assign)            CGFloat                 maxWidth;
@property(nonatomic, assign)            BOOL                    isShow;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (id)initWithMessage:(NSString *)messageToShow;

@end

@protocol UIPopViewDelegate <NSObject>
@optional
- (void)popTipViewWasDismissedByUser:(JCPopView *)popTipView;
@end