//
//  JCLivelyTableView.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-4-26.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSTimeInterval JCLivelyDefaultDuration;

typedef NSTimeInterval (^JCLivelyTransform)(CALayer * layer, float speed);

extern JCLivelyTransform JCLivelyTransformCurl;
extern JCLivelyTransform JCLivelyTransformFade;
extern JCLivelyTransform JCLivelyTransformFan;
extern JCLivelyTransform JCLivelyTransformFlip;
extern JCLivelyTransform JCLivelyTransformHelix;
extern JCLivelyTransform JCLivelyTransformTilt;
extern JCLivelyTransform JCLivelyTransformWave;

@interface JCLivelyTableView : UITableView<UITableViewDelegate> {
    CGPoint _lastScrollPosition;
    CGPoint _currentScrollPosition;
    JCLivelyTransform _transformBlock;
    id<UITableViewDelegate>  _preLivelyDelegate;
}

- (CGPoint)scrollSpeed;
- (void)setInitialCellTransformBlock:(JCLivelyTransform)block;

@end