//
//  NSString+BundleExtensions.h
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BundleExtensions)

+ (NSString *)stringFromFileNamed:(NSString *)bundleFileName;

@end