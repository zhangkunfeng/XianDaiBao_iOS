
#import <UIKit/UIKit.h>

typedef void (^closeGestureBlock)(BOOL isClose);

@interface GestureVerifyViewController : BaseViewController

@property (nonatomic, assign) BOOL isToSetNewGesture;

@property (nonatomic, copy) closeGestureBlock closeGesture;

@end
