//
//  UIUtils+NSObject.h
//
//  Created by Joy Chiang on 11-11-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

///---------------------------------------------------------------------------
/// @name NSObject
///---------------------------------------------------------------------------
@interface NSObject (UIUtilsAdditions)

- (void)performSelector:(SEL)aSelector andReturnTo:(void *)returnData withArguments:(void **)arguments;
- (void)performSelector:(SEL)aSelector withArguments:(void **)arguments;
- (void)performSelectorIfExists:(SEL)aSelector andReturnTo:(void *)returnData withArguments:(void **)arguments;
- (void)performSelectorIfExists:(SEL)aSelector withArguments:(void **)arguments;

// 对象的生命周期关联
- (void)associateValue:(id)value withKey:(void *)key;
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;

@end

///---------------------------------------------------------------------------
/// @name NSArray
///---------------------------------------------------------------------------
@interface NSArray (UIUtilsAdditions)

// 返回一个新的倒序的NSArray数组
- (NSArray *)reversedArray;

@end

///---------------------------------------------------------------------------
/// @name NSMutableArray
///---------------------------------------------------------------------------
@interface NSMutableArray (UIUtilsAdditions)

// 将数组里的元素倒序排序
- (void)reverse;

@end

///---------------------------------------------------------------------------
/// @name NSDate
///---------------------------------------------------------------------------
@interface NSDate (UIUtilsAdditions)

- (NSString *)stringWithHumanizedTimeDifference;
- (NSString *)stringWithFormat:(NSString *)string;

@end

///---------------------------------------------------------------------------
/// @name NSDictionary
///---------------------------------------------------------------------------
@interface NSDictionary (UIUtilsAdditions)

@property(nonatomic, readonly, getter=isEmpty) BOOL empty;

- (BOOL)containsObjectForKey:(id)key;

@end