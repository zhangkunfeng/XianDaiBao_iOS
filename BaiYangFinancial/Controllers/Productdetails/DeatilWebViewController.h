//
//  DeatilWebViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/28.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class ProductdetailsViewController;

@interface DeatilWebViewController : BaseViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mainWebview;
//加载的地址
@property (nonatomic,retain)NSString *requestURL;
@property (nonatomic, strong)ProductdetailsViewController *productdetail;

- (void)setloadviewRequestWithrequestURL:(NSString *)requestUrl;

@end
