//
//  UniversalWebViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/4.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
//#import "NJKWebViewProgress.h"
//#import "NJKWebViewProgressView.h"
#import "CustomMadeNavigationControllerView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TokenJSExport <JSExport>
JSExportAs
//(callAndroid, -(void)callAndroid:(NSInteger)type);
(newbie,-(void)newbie:(NSString *)title Bid:(NSString *)bid);
-(void)invest;
-(void)toReg;
-(void)toRegOrToRedPacket;

@end

@interface UniversalWebViewController : BaseViewController<UIWebViewDelegate,CustomUINavBarDelegate,TokenJSExport>
{
//    NJKWebViewProgressView *_progressView;
//    NJKWebViewProgress *_progressProxy;
    CustomMadeNavigationControllerView *_NavigationControllerView;
}
@property (weak, nonatomic) IBOutlet UIWebView *mainWebview;
//加载的地址
@property (nonatomic,retain)NSString *requestURL;
//网页标题
@property (nonatomic,retain)NSString *WebTiltle;

@property (nonatomic, copy) NSString * jumpTypeStr;

@property (strong, nonatomic) JSContext *context;
@property (nonatomic,strong)NSString *webUrl;

@end
