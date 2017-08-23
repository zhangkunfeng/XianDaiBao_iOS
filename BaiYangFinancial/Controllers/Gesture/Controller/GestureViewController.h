
#import <UIKit/UIKit.h>

typedef enum {
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
} GestureViewControllerType;

typedef enum {
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget

} buttonTag;

typedef void (^openGestureblock)(BOOL isOpen);
typedef void (^AppDelegateGobackBlock)(BOOL isBack);

@interface GestureViewController : BaseViewController

@property (nonatomic, assign) BOOL isShowPupopView;
@property (nonatomic, assign) BOOL isSettingGesture;

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@property (nonatomic, copy) openGestureblock openGesture;

@property (nonatomic, copy) AppDelegateGobackBlock appDelegateGoback;

@end
