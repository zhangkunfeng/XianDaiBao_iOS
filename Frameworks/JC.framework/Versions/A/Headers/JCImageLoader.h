//
//  JCImageLoader.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-4-19.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef __JCIL_USE_BLOCKS
#define __JCIL_USE_BLOCKS 0
#endif

#ifndef __JCIL_USE_NOTIF
#define __JCIL_USE_NOTIF 1
#endif

@protocol JCImageLoaderObserver;

@interface JCImageLoader : NSObject {
@private
	NSDictionary *_currentConnections;
	NSMutableDictionary *currentConnections;
#if __JCIL_USE_BLOCKS
	dispatch_queue_t _operationQueue;
#endif
	NSLock *connectionsLock;
}

+ (JCImageLoader *)sharedImageLoader;

- (BOOL)isLoadingImageURL:(NSURL *)aURL;

#if __JCIL_USE_NOTIF
- (void)loadImageForURL:(NSURL *)aURL observer:(id<JCImageLoaderObserver>)observer;
- (UIImage *)imageForURL:(NSURL *)aURL shouldLoadWithObserver:(id<JCImageLoaderObserver>)observer;

- (void)removeObserver:(id<JCImageLoaderObserver>)observer;
- (void)removeObserver:(id<JCImageLoaderObserver>)observer forURL:(NSURL *)aURL;
#endif

#if __JCIL_USE_BLOCKS
- (void)loadImageForURL:(NSURL *)aURL completion:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completion;
- (void)loadImageForURL:(NSURL *)aURL style:(NSString *)style styler:(UIImage* (^)(UIImage *image))styler completion:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completion;
#endif

- (BOOL)hasLoadedImageURL:(NSURL *)aURL;
- (void)cancelLoadForURL:(NSURL *)aURL;

- (void)clearCacheForURL:(NSURL *)aURL;
- (void)clearCacheForURL:(NSURL *)aURL style:(NSString *)style;

@property(nonatomic, retain) NSDictionary *currentConnections;

@end

////////////////////////////////////////////////////////////////////////////////////

@protocol JCImageLoaderObserver<NSObject>
@optional
- (void)imageLoaderDidLoad:(NSNotification *)notification;
- (void)imageLoaderDidFailToLoad:(NSNotification *)notification;
@end