//
//  UniversalWebViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/4.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "UniversalWebViewController.h"
#import "UIWebView+AFNetworking.h"
#import "LoginViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "NewProductListViewController.h"
#import "BaseNewProductViewController.h"
#import "myRedenvelopeListViewController.h"
#import "RedenvelopeViewController.h"
//#import "WebViewJavascriptBridge.h"
#import "MainViewController.h"
#import "NewProductListViewController.h"
#import "ProductdetailsViewController.h"
#import "HomeViewController.h"

@interface UniversalWebViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *webActivityIndicatorView;

//@property WebViewJavascriptBridge* bridge;
@end

@implementation UniversalWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:[NSString stringWithFormat:@"%@(网页)",self.WebTiltle]];
    //    [_NavigationControllerView addSubview:_progressView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self talkingDatatrackPageEnd:[NSString stringWithFormat:@"%@(网页)",self.WebTiltle]];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    //    [_progressView removeFromSuperview];
    
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_mainWebview) {
        [_mainWebview removeFromSuperview];
        _mainWebview = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    //设置第三方Bridge是否可用
    //    [WebViewJavascriptBridge enableLogging];
    //
    //    //关联webView和bridge
    //    _bridge = [WebViewJavascriptBridge bridgeForWebView:_mainWebview];
    //
    //    [_bridge setWebViewDelegate:self];
    //    [_bridge callHandler:@"webValue" data:@{@"uid": [NetManager TripleDES:getObjectFromUserDefaults(UID) encryptOrDecrypt:kCCEncrypt key:K3DESKey]}];
    //
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _NavigationControllerView = [[CustomMadeNavigationControllerView alloc] initWithTitle:self.WebTiltle showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:_NavigationControllerView];
    
    [self loadviewRequest];
}

#pragma mark - 加载网页
- (void)loadviewRequest{
    self.requestURL = [self.requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
    [_mainWebview loadRequest:request];
}

- (void)goBack{
    if ([_jumpTypeStr isEqualToString:@"PUSH"]) {
        [self customPopViewController:0];
    }else{
        [self customPopViewController:1];
        
        
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 以 JSExport 协议关联 client 的方法
    self.context[@"androidCall"] = self;
    
}

-(void)newbie:(NSString *)title Bid:(NSString *)bid{
   
    
    if ([bid isEqualToString:@""] || bid == nil) {
        
    }else{
        [self allowErrorOperation];
        ProductdetailsViewController *proVC = [[ProductdetailsViewController alloc]initWithNibName:@"ProductdetailsViewController" bundle:nil];
        proVC.productBid = bid;
        proVC.bidNameString = title;
        [self customPushViewController:proVC customNum:0];
    }

}

-(void)toRegOrToRedPacket{
    if ([self isBlankString:getObjectFromUserDefaults(UID)] || [self isBlankString:getObjectFromUserDefaults(SID)]) {
        [self allowErrorOperation];
        VerificationiPhoneNumberViewController *view = [[VerificationiPhoneNumberViewController alloc]initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        
        [self customPushViewController:view customNum:0];
        
    }else{
        [self allowErrorOperation];
        RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] initWithNibName:@"RedenvelopeViewController" bundle:nil];
        
        myRedenvelopeView.redBao = redFrom;
        [self customPushViewController:myRedenvelopeView customNum:0];
        
    }
}

-(void)toReg{
    
    if ([self isBlankString:getObjectFromUserDefaults(UID)] || [self isBlankString:getObjectFromUserDefaults(SID)]) {
        //[self goBack];
        
        [self allowErrorOperation];
        VerificationiPhoneNumberViewController *view = [[VerificationiPhoneNumberViewController alloc]initWithNibName:@"VerificationiPhoneNumberViewController" bundle:nil];
        [self customPushViewController:view customNum:0];
        
    }else{
        
        [self allowErrorOperation];
        RedenvelopeViewController *myRedenvelopeView = [[RedenvelopeViewController alloc] initWithNibName:@"RedenvelopeViewController" bundle:nil];
        
        myRedenvelopeView.redBao = redFrom;
        [self customPushViewController:myRedenvelopeView customNum:0];
        
    }
}

- (void)allowErrorOperation{
    if ([self.jumpTypeStr isEqualToString:@"PUSH"]) {
        return;
    }
    [self customPopViewController:1];
}

-(void)invest{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissTo102" object:nil];
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //    [self dismissWeidaiLoadAnimationView:self];
    [_webActivityIndicatorView stopAnimating];
    _webActivityIndicatorView.hidden = YES;
    
    //    if (![self isBlankString:getObjectFromUserDefaults(UID)]) {//如果有值
    //.在webview的代理方法中，我们用去调用第一个js方法
    NSString *sendData = [NSString stringWithFormat:@"showAlert('%@')",[NetManager TripleDES:getObjectFromUserDefaults(UID) encryptOrDecrypt:kCCEncrypt key:K3DESKey]];
    [_mainWebview stringByEvaluatingJavaScriptFromString:sendData];
    
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self dismissWeidaiLoadAnimationView:self];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"亲，没有网络哦！" MDErrorShowViewType:NoData];
        }else{
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64) contentShowString:@"加载失败,点击加载" MDErrorShowViewType:NoNetwork];
        }
    }];
}

//JavaScript to Objective-C
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSString *URLstr = [url absoluteString];
    NSLog(@"%@",URLstr);
    
    //[self callAndroid:1];
    
    return YES;
}


- (void)againLoadingData{
    [self hideMDErrorShowView:self];
    [self loadviewRequest];
}

//#pragma mark - NJKWebViewProgressDelegate
//- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//    [_progressView setProgress:progress animated:YES];
//    self.title = [_mainWebview stringByEvaluatingJavaScriptFromString:@"document.title"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
