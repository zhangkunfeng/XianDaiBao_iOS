//
//  JCAsyncImageView.h
//
//  Created by Joy Chiang on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCImageLoader.h"

@protocol JCImageViewDelegate;

@interface JCAsyncImageView : UIImageView <JCImageLoaderObserver>

@property(nonatomic, retain) NSURL *imageURL;// 图片URL地址
@property(nonatomic, retain) UIImage *placeholderImage;// 临时图片，用于未下载完成时显示
@property(nonatomic, assign) BOOL showingActivityIndicator;// 是否显示加载框
@property(nonatomic, assign) id<JCImageViewDelegate> delegate;
@property(nonatomic, retain, readonly) UIActivityIndicatorView *activityIndicator;

- (void)cancelImageLoad;// 取消图片下载

- (id)initWithURL:(NSURL *)imageURL;
- (id)initWithPlaceholderImage:(UIImage *)anImage;
- (id)initWithPlaceholderImage:(UIImage *)anImage delegate:(id<JCImageViewDelegate>)aDelegate;

@end

//////////////////////////////////////////////////////////////////////

@protocol JCImageViewDelegate<NSObject>
@optional
- (void)imageViewInvalidURL:(JCAsyncImageView *)imageView;// 所给定的图片地址错误
- (void)imageViewLoadedImage:(JCAsyncImageView *)imageView;// 加载图片完成
- (void)imageViewFailedToLoadImage:(JCAsyncImageView *)imageView error:(NSError *)error;// 加载图片失败
- (UIImage *)imageView:(JCAsyncImageView *)imageView processingForImageWhenLoaded:(UIImage *)image;// 当图片下载完成时，对网络图片进行处理后再显示
@end