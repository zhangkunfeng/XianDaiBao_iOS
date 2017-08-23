//
//  UMSQQDataTypeTableViewController.h
//  SocialSDK
//
//  Created by umeng on 16/4/15.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>

/*后加*/
#import <TencentOpenAPI/QQApiInterface.h>       //QQ互联 SDK
#import <TencentOpenAPI/TencentOAuth.h>


@interface UMSocialQQHandler : UMSocialHandler

+ (UMSocialQQHandler *)defaultManager;

/** QQ是否支持网页分享
 * @param support 是否支持
 */
- (void)setSupportWebView:(BOOL)support;

@end
