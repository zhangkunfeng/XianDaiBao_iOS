//
//  JCImageLoadConnection.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-4-19.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCImageLoadConnectionDelegate;

@interface JCImageLoadConnection : NSObject {
@private
	NSURL *_imageURL;
	NSURLResponse *_response;
	NSMutableData *_responseData;
	NSURLConnection *_connection;
	NSTimeInterval _timeoutInterval;
	
	id<JCImageLoadConnectionDelegate> _delegate;
}

- (id)initWithImageURL:(NSURL *)aURL delegate:(id)delegate;

- (void)start;
- (void)cancel;

@property(nonatomic, readonly) NSData *responseData;
@property(nonatomic, readonly, getter=imageURL) NSURL *imageURL;

@property(nonatomic, retain) NSURLResponse *response;
@property(nonatomic, assign) id<JCImageLoadConnectionDelegate> delegate;

@property(nonatomic, assign) NSTimeInterval timeoutInterval; // 30 seconds

#if __JCIL_USE_BLOCKS
@property(nonatomic, readonly) NSMutableDictionary *handlers;
#endif

@end

@protocol JCImageLoadConnectionDelegate<NSObject>
- (void)imageLoadConnectionDidFinishLoading:(JCImageLoadConnection *)connection;
- (void)imageLoadConnection:(JCImageLoadConnection *)connection didFailWithError:(NSError *)error;	
@end