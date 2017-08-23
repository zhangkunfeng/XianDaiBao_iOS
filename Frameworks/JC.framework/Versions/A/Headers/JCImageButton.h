//
//  JCImageButton.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-4-21.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCImageLoader.h"

@protocol JCImageButtonDelegate;

@interface JCImageButton : UIButton <JCImageLoaderObserver> 

@property(nonatomic, retain) NSURL *imageURL;// 图片URL地址
@property(nonatomic, retain) UIImage *placeholderImage;// 默认图片，用于未下载、下载未完成、下载失败时显示
@property(nonatomic, assign) id<JCImageButtonDelegate> delegate;
@property(nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property(nonatomic) BOOL showingActivityIndicator;// 是否显示加载框

- (id)initWithURL:(NSURL *)imageURL;
- (id)initWithPlaceholderImage:(UIImage *)anImage;// 所给图片被设置为UIControlStateNormal
- (id)initWithPlaceholderImage:(UIImage *)anImage delegate:(id<JCImageButtonDelegate>)aDelegate;

- (void)cancelImageLoad;

@end

///////////////////////////////////////////////////////////////

@protocol JCImageButtonDelegate<NSObject>
@optional
- (void)imageButtonLoadedImage:(JCImageButton *)imageButton;
- (void)imageButtonFailedToLoadImage:(JCImageButton *)imageButton error:(NSError *)error;
@end