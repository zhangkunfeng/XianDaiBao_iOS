//
//  JSObject.h
//  BaiYangFinancial
//
//  Created by dudu on 2017/7/10.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)callAndroid;

@end

@interface JSObject : NSObject <JSObjcDelegate>

@end
