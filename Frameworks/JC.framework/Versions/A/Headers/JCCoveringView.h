//
//  TouchableView.h
//  JoyChiang
//
//  Created by Joy Chiang on 11-11-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCCoveringView;

@protocol TouchableViewDelegate<NSObject>

- (void)viewWasTouched:(JCCoveringView *)view;

@end

/**
 * 当弹出视图弹出时作为一个透明背景显示，点击其他地方时方便关闭弹出视图
 */
@interface JCCoveringView : UIView {
	BOOL touchForwardingDisabled;
	id <TouchableViewDelegate> delegate;
	NSArray *passthroughViews;
	BOOL testHits;
}

@property (nonatomic, assign) BOOL touchForwardingDisabled;
@property (nonatomic, assign) id <TouchableViewDelegate> delegate;
@property (nonatomic, copy) NSArray *passthroughViews;

@end