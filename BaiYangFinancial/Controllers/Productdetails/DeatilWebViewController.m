//
//  DeatilWebViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/28.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "DeatilWebViewController.h"
#import "UIWebView+AFNetworking.h"
#import "SDRefresh.h"
#import "YiRefreshHeader.h"

@interface DeatilWebViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *webActivityIndicatorView;

@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) YiRefreshHeader *refreshHeader;
@end

@implementation DeatilWebViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
    
    if (_weakRefreshHeader) {
        [_weakRefreshHeader removeFromSuperview];
        _weakRefreshHeader  = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setupHeaderRefresh];
//    [self loadviewRequest];
}


#pragma mark - YiRefreshHeader
- (void)setupHeaderRefresh
{
    // YiRefreshHeader  头部刷新按钮的使用
    _refreshHeader=[[YiRefreshHeader alloc] init];
    _refreshHeader.scrollView = _mainWebview.scrollView;
    [_refreshHeader header];
    typeof(_refreshHeader) __weak weakRefreshHeader = _refreshHeader;
    _refreshHeader.beginRefreshingBlock=^(){
        typeof(weakRefreshHeader) __strong strongRefreshHeader = weakRefreshHeader;
        [[NSNotificationCenter defaultCenter] postNotificationName:changeDetailContentScrollView object:nil];
        [strongRefreshHeader endRefreshing];
    };
    //    // 是否在进入该界面的时候就开始进入刷新状态
    //    [_refreshHeader beginRefreshing];
}


- (void)refreshStateChange:(UIRefreshControl *)control
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changeDetailContentScrollView object:nil];
    [control endRefreshing];
}

- (void)setloadviewRequestWithrequestURL:(NSString *)requestUrl
{
    self.requestURL = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
    [_mainWebview loadRequest:request];
}

#pragma mark - 加载网页
- (void)loadviewRequest{
    self.requestURL = [self.requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
    [_mainWebview loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //    [self showWeidaiLoadAnimationView:self];
    _webActivityIndicatorView.hidden = NO;
    [_webActivityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webActivityIndicatorView stopAnimating];
    _webActivityIndicatorView.hidden = YES;
    

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
    //    NSURL *url = [request URL];
    //    NSString *URLstr = [url absoluteString];
    //    NSLog(@"%@",URLstr);
    return YES;
}

- (void)againLoadingData{
    [self hideMDErrorShowView:self];
    [self loadviewRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
