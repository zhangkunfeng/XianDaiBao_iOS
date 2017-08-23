//
//  UIAnimationManager.h
//  Chumkee
//
//  Created by Joy Chiang on 11-11-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum _UIAnimationDirection {
    kUIAnimationTop = 0,
    kUIAnimationRight,
    kUIAnimationBottom,
    kUIAnimationLeft,
    kUIAnimationTopLeft,
    kUIAnimationTopRight,
    kUIAnimationBottomLeft,
    kUIAnimationBottomRight
} UIAnimationDirection;

#pragma mark String Constants
extern NSString *const kUIAnimationName;
extern NSString *const kUIAnimationType;
extern NSString *const kUIAnimationTypeIn;
extern NSString *const kUIAnimationTypeOut;
extern NSString *const kUIAnimationSlideIn;
extern NSString *const kUIAnimationSlideOut;
extern NSString *const kUIAnimationBackOut;
extern NSString *const kUIAnimationBackIn;
extern NSString *const kUIAnimationFadeOut;
extern NSString *const kUIAnimationFadeIn;
extern NSString *const kUIAnimationFadeBackgroundOut;
extern NSString *const kUIAnimationFadeBackgroundIn;
extern NSString *const kUIAnimationPopIn;
extern NSString *const kUIAnimationPopOut;
extern NSString *const kUIAnimationFallIn;
extern NSString *const kUIAnimationFallOut;
extern NSString *const kUIAnimationFlyOut;

extern NSString *const kUIAnimationTargetViewKey;

#pragma mark Inline Functions
static inline CGPoint UIAnimationOutOfViewCenterPoint(CGRect enclosingViewFrame, CGRect viewFrame, CGPoint viewCenter, UIAnimationDirection direction) {
	switch (direction) {
		case kUIAnimationBottom: {
			CGFloat extraOffset = viewFrame.size.height / 2;
			return CGPointMake(viewCenter.x, enclosingViewFrame.size.height + extraOffset);
			break;
		}
		case kUIAnimationTop: {
			CGFloat extraOffset = viewFrame.size.height / 2;
			return CGPointMake(viewCenter.x, enclosingViewFrame.origin.y - extraOffset);
			break;
		}
		case kUIAnimationLeft: {
			CGFloat extraOffset = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.origin.x - extraOffset, viewCenter.y);
			break;
		}
		case kUIAnimationRight: {
			CGFloat extraOffset = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.size.width + extraOffset, viewCenter.y);
			break;
		}
		case kUIAnimationBottomLeft: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.origin.x - extraOffsetWidth, enclosingViewFrame.size.height + extraOffsetHeight);
			break;
		}
		case kUIAnimationTopLeft: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.origin.x - extraOffsetWidth, enclosingViewFrame.origin.y - extraOffsetHeight);
			break;
		}
		case kUIAnimationBottomRight: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.size.width + extraOffsetWidth, enclosingViewFrame.size.height + extraOffsetHeight);
			break;
		}
		case kUIAnimationTopRight: {
			CGFloat extraOffsetHeight = viewFrame.size.height / 2;
			CGFloat extraOffsetWidth = viewFrame.size.width / 2;
			return CGPointMake(enclosingViewFrame.size.width + extraOffsetWidth, enclosingViewFrame.origin.y - extraOffsetHeight);
			break;
		}
	}
	return CGPointZero;
}

static inline CGPoint UIAnimationOffscreenCenterPoint(CGRect viewFrame, CGPoint viewCenter, UIAnimationDirection direction) {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        CGFloat swap = screenRect.size.height;
        screenRect.size.height = screenRect.size.width;
        screenRect.size.width = swap;
    } 
    switch (direction) {
        case kUIAnimationBottom: {
            CGFloat extraOffset = viewFrame.size.height / 2;
            return CGPointMake(viewCenter.x, screenRect.size.height + extraOffset);
            break;
        }
        case kUIAnimationTop: {
            CGFloat extraOffset = viewFrame.size.height / 2;
            return CGPointMake(viewCenter.x, screenRect.origin.y - extraOffset);
            break;
        }
        case kUIAnimationLeft: {
            CGFloat extraOffset = viewFrame.size.width / 2;
            return CGPointMake(screenRect.origin.x - extraOffset, viewCenter.y);
            break;
        }
        case kUIAnimationRight: {
            CGFloat extraOffset = viewFrame.size.width / 2;
            return CGPointMake(screenRect.size.width + extraOffset, viewCenter.y);
            break;
        }
        default:
            break;
    }
	return UIAnimationOutOfViewCenterPoint([[UIScreen mainScreen] bounds], viewFrame, viewCenter, direction);
}

/////////////////////////////////////////////////

@interface UIAnimationManager : NSObject {
@private
    CGFloat overshootThreshold_;
}

@property(assign) CGFloat overshootThreshold;

+ (UIAnimationManager *)sharedManager;

- (CAAnimationGroup *)delayStartOfAnimation:(CAAnimation *)animation withDelay:(CFTimeInterval)delayTime;

- (CAAnimationGroup *)pauseAtEndOfAnimation:(CAAnimation *)animation withDelay:(CFTimeInterval)delayTime;

- (CAAnimation *)chainAnimations:(NSArray *)animations run:(BOOL)run;

- (CAAnimationGroup *)animationGroupFor:(NSArray *)animations withView:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector name:(NSString *)name type:(NSString *)type;

- (CAAnimation *)slideInAnimationFor:(UIView *)view direction:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)slideInAnimationFor:(UIView *)view direction:(UIAnimationDirection)direction inView:(UIView*)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)slideOutAnimationFor:(UIView *)view direction:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)slideOutAnimationFor:(UIView *)view direction:(UIAnimationDirection)direction inView:(UIView*)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)backOutAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)backOutAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(UIAnimationDirection)direction inView:(UIView *)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)backInAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(UIAnimationDirection)direction duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)backInAnimationFor:(UIView *)view withFade:(BOOL)fade direction:(UIAnimationDirection)direction inView:(UIView *)enclosingView duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)fadeAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector 
                     stopSelector:(SEL)stopSelector fadeOut:(BOOL)fadeOut;

- (CAAnimation *)fadeBackgroundColorAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector fadeOut:(BOOL)fadeOut;

- (CAAnimation *)popInAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                     startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)popOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)fallInAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)fallOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate
                       startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimation *)flyOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration delegate:(id)delegate 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

@end

////////////////////////////////////////////////////

@interface CAAnimation (UIAnimationAdditions)

- (void)setStartSelector:(SEL)selector withTarget:(id)target;
- (void)setStopSelector:(SEL)selector withTarget:(id)target;

@end