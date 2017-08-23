//
//  JCProgressView.h
//  TYReader
//
//  Created by Joy Chiang on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCProgressView : UIProgressView {
    @public
        BOOL        animated;
    
    @protected
        double      progressOffset;
        CGFloat     cornerRadius;
        NSTimer*    animationTimer;
}

@property(nonatomic, getter = isAnimated) BOOL animated;

@end