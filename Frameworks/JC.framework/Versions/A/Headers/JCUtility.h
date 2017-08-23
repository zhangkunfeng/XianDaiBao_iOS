//
//  JCUtility.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-3-20.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

///---------------------------------------------------------------------------
/// @name Memory Management
///---------------------------------------------------------------------------
#define Free(obj) {if (obj) { free(obj); obj = NULL; } }
#define Release(obj) {if (obj) { [(obj) release]; obj = nil; } }


///---------------------------------------------------------------------------
/// @name Math Helpers
///---------------------------------------------------------------------------
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180) /** 角度转换成弧度 */
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI) /** 弧度转换成角度 */


///---------------------------------------------------------------------------
/// @name Creating colors
///---------------------------------------------------------------------------
#define RGB(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

#define RGBA(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


///---------------------------------------------------------------------------
/// @name Calling Delegates
///---------------------------------------------------------------------------
#define CALL_DELEGATE(_delegate, _selector) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector]; \
} \
} while(0);

#define CALL_DELEGATE_WITH_ARG(_delegate, _selector, _argument) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector withObject:_argument]; \
} \
} while(0);

#define CALL_DELEGATE_WITH_ARGS(_delegate, _selector, _arg1, _arg2) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector withObject:_arg1 withObject:_arg2]; \
} \
} while(0);


///---------------------------------------------------------------------------
/// @name UIDevice Helpers
///---------------------------------------------------------------------------
#define IOS_3_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
#define IOS_4_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
#define IOS_5_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IOS_6_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPad       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone     [[UIDevice currentDevice].model isEqualToString:@"iPhone"]
#define isIPod       [[UIDevice currentDevice].model isEqualToString:@"iPod touch"]
#define isSimulator  [[UIDevice currentDevice].model rangeOfString:@"Simulator"].location != NSNotFound

#define osVersion    [[UIDevice currentDevice] systemVersion]     /** 系统版本号 */
#define uId          [[UIDevice currentDevice] uniqueIdentifier]  /** 设备惟一标识号 */
#define deviceModel  [[UIDevice currentDevice] model]             /** 设备类型 */

#define appFrame               [UIScreen mainScreen].applicationFrame
#define mainScreenWidth        [UIScreen mainScreen].bounds.size.width
#define mainScreenHeight       [UIScreen mainScreen].bounds.size.height
#define appFrameWidth          [UIScreen mainScreen].applicationFrame.size.width
#define appFrameHeight         [UIScreen mainScreen].applicationFrame.size.height

#define isNull(obj)        (obj && ((NSNull *)obj == [NSNull null]))


