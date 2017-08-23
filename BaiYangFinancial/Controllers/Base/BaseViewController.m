//
//  BaseViewController.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "UniversalWebViewController.h"
#import "WDToastUtil.h"
#import "TalkingData.h"
#import "TalkingDataAppCpa.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) MDErrorShowView *ErrorShowView;
@property (nonatomic, assign) BOOL isCanSideBack;

@end

@implementation BaseViewController
//解决APP界面卡死Bug
/*
 *  一级页面响应方法中调用
 *  在一级页面进入和离开时 分别添加禁用和开启右滑返回手势
 */
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self forbiddenSideBack];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self resetSideBack];
//}

/**
 * 禁用边缘返回
 */
- (void)forbiddenSideBack{
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.navigationController.interactivePopGestureRecognizer.view;
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
}

/*
 恢复边缘返回
 */
- (void)resetSideBack {
    self.isCanSideBack=YES;
    //开启ios右滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.navigationController.interactivePopGestureRecognizer.view;
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    if (self.navigationController.childViewControllers.count<=0) {
        return NO;
    }
    return self.isCanSideBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
//    //  获取添加系统边缘触发手势的View
//    UIView *targetView = self.navigationController.interactivePopGestureRecognizer.view;
//    //  创建pan手势 作用范围是全屏
//    UIPanGestureRecognizer *fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
//    fullScreenGes.delegate = self;
//    [targetView addGestureRecognizer:fullScreenGes];

    //增加滑动返回
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
//     OC   plist->   View controller-based status bar appearance  NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
//    [self setQLStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//    [self setQLStatusBarStyleDefault];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
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

#pragma mark - ---------- 计算文本大小
- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName: paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

#pragma mark - Push/Pop
- (void)customPresentViewController:(UIViewController *)controller {
    [self customPresentViewController:controller withAnimation:YES];
}
- (void)customPresentViewController:(UIViewController *)controller withAnimation:(BOOL)enableAnimation {
    if (!controller) {
        return;
    }
    UINavigationController *navigationController = [[UINavigationController alloc]
        initWithRootViewController:controller];
    navigationController.navigationBarHidden = YES;
    [self presentViewController:navigationController animated:enableAnimation completion:^{

    }];
}
- (void)customDismissController {
    [self customDismissControllerWithAnimation:YES];
}

- (void)customDismissControllerWithAnimation:(BOOL)flag completion:(void (^)(void))completion {
    [self.navigationController dismissViewControllerAnimated:flag completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)customDismissControllerWithAnimation:(BOOL)enableAnimation {
    [self.navigationController dismissViewControllerAnimated:enableAnimation completion:^{

    }];
}

#pragma mark - 设置不规则大小颜色等文本
- (UILabel *)AttributedString:(NSString *)willChangeString andTextColor:(UIColor *)color andTextFontSize:(CGFloat)fontSize AndRange:(CGFloat)startPosition withlength:(CGFloat)length AndLabel:(UILabel *)label
{
    if (willChangeString == nil) {
        return 0;
    }
    NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:willChangeString];
    [strAtt_Temp addAttributes:@{ NSForegroundColorAttributeName: color,
                                  NSFontAttributeName : [UIFont fontWithName:@".PingFangSC-Regular" size:fontSize],}
                         range:NSMakeRange(startPosition, length)];
    [label setAttributedText:strAtt_Temp];
    return label;
}

#pragma mark - 正则判断
- (BOOL)isLegalNum:(NSString *)text {
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[0-9]|17[0-9]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];

    BOOL isMatch = [pred evaluateWithObject:text];
    return isMatch;
}

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isLegalObject:(NSObject *)object {
    if (object == nil) {
        return NO;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
//判断是否为浮点数
- (BOOL)isPureFloat:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 手机号码字符串查找替换删除截取操作(通讯录)
- (NSString *)searchReplaceRemoveClippingOperationForPhoneNumStr:(NSString *)phoneNumStr
{
    if ([self isLegalNum:phoneNumStr]){
        return phoneNumStr;
    }
    
    NSString * newPhoneNumStr = phoneNumStr;//防止返回为nil
    if ([newPhoneNumStr rangeOfString:@","].location != NSNotFound) {
        NSRange range = [newPhoneNumStr rangeOfString:@","];
        newPhoneNumStr = [newPhoneNumStr substringToIndex:range.location];
    }
    
    NSMutableString *mString = [NSMutableString stringWithString:newPhoneNumStr];
    NSArray * symbolArray = @[@"-",@" ",@"（",@"）",@"(",@")",@"+86",@" "/*顽固字符 非空格*/];
    for (NSInteger i = 0; i < symbolArray.count; i++){
        if ([mString rangeOfString:symbolArray[i]].location != NSNotFound) {
            mString = (NSMutableString*)[mString stringByReplacingOccurrencesOfString:symbolArray[i] withString:@""];
        }
    }
    
    if (mString.length > 15) {
        mString = (NSMutableString*)[mString substringToIndex:15];
    }

    newPhoneNumStr = [NSString stringWithString:mString];
    
    return newPhoneNumStr;
}
#pragma mark - 返回指定页面
- (void)jumpViewController:(NSString *)viewContoller{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[viewContoller class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
#pragma mark - Navigation Controller
- (void)customPushViewController:(UIViewController *)controller customNum:(NSInteger)number {
    [self customPushViewController:controller customNum:number animation:YES];
}

- (void)customPushViewController:(UIViewController *)controller customNum:(NSInteger)number animation:(BOOL)animate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (number == 0) {
        [appDelegate.navigationController pushViewController:controller animated:animate];
    } else if (number == 1) {
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      [appDelegate.navigationController presentViewController:controller animated:YES completion:^{

        }];
    } else if (number == 2) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.7];
        [appDelegate.navigationController pushViewController:controller animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    } else if (number == 3) {
        CATransition *Transition = [CATransition animation];
        Transition.duration = 0.8;
        Transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        Transition.type = kCATransitionFade;
        [self.navigationController.view.layer addAnimation:Transition forKey:nil];
        [appDelegate.navigationController pushViewController:controller animated:NO];
    } else {
        [appDelegate.navigationController pushViewController:controller animated:animate];
    }
}

- (void)customPopViewController:(NSInteger)CustomPushStatesnumber {
    [self customPopViewControllerWithAnimation:YES CustomPushStates:CustomPushStatesnumber];
}

- (void)customPopViewControllerWithAnimation:(BOOL)animate CustomPushStates:(NSInteger)CustomPushStatesnumber {
    UINavigationController *navigationController = (UINavigationController *) self.navigationController;
    if (CustomPushStatesnumber == 0) {
        [navigationController popViewControllerAnimated:animate];
    } else if (CustomPushStatesnumber == 1) {
       [self dismissViewControllerAnimated:animate completion:^{

        }]; 
    } else if (CustomPushStatesnumber == 2) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [navigationController popViewControllerAnimated:animate];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    } else if (CustomPushStatesnumber == 3) {
        [navigationController popToViewController:[navigationController.viewControllers objectAtIndex:0] animated:animate];
    } else if (CustomPushStatesnumber == 4) {
        [navigationController popToViewController:[navigationController.viewControllers objectAtIndex:1] animated:animate];
    } else if (CustomPushStatesnumber == 5) {
        [navigationController popToViewController:[navigationController.viewControllers objectAtIndex:2] animated:animate];
    } else {
        [navigationController popViewControllerAnimated:animate];
    }
}

#pragma mark - pop 到指定层级
- (void)comePopViewControllerWithAnimation:(BOOL)animate CustomPushIndex:(NSInteger)pushIndex {
    UINavigationController *navigationController = (UINavigationController *) self.navigationController;
    [navigationController popToViewController:[navigationController.viewControllers objectAtIndex:pushIndex] animated:animate];
}


#pragma mark -16进制计算颜色
/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
- (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (nil != inColorString) {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
        colorWithRed:(float) redByte / 0xff
               green:(float) greenByte / 0xff
                blue:(float) blueByte / 0xff
               alpha:1.0];
    return result;
}
#pragma mark - 获取 bundle version版本号
- (NSString*)getLocalAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - 字典本地存储
- (void)userDefaultsKeyForDictionary:(NSDictionary *)valueDictionary defaultsKey:(NSString *)keyString {
    NSUserDefaults *userDefaults = UserDefaults;
    if ([userDefaults objectForKey:keyString] != nil) {
        [userDefaults removeObjectForKey:keyString];
    }
    [userDefaults setObject:valueDictionary forKey:keyString];
    [userDefaults synchronize];
}

- (NSDictionary *)getLocalUserinfoDict {
    NSUserDefaults *userDefaults = UserDefaults;
    NSDictionary *userInfdict = [userDefaults objectForKey:InviteCode];
    if (userInfdict != nil) {
        return userInfdict;
    } else {
        return nil;
    }
}
- (void)removeLocalUserinfoDict {
    NSUserDefaults *userDefaults = UserDefaults;
    NSDictionary *userInfdict = [userDefaults objectForKey:InviteCode];
    if (userInfdict != nil) {
        removeDictionaryFromUserDefaults(InviteCode);
    }
}
#pragma mark - json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

#pragma mark - 错误提示
- (void)errorPrompt:(float)timerCancel promptStr:(NSString *)Pstring {
    if ([Pstring isEqualToString:@"access_token为空"]
        ||[Pstring isEqualToString:@""]) {
        return;
    }
//    [KVNProgress showErrorWithStatus:Pstring];
    [self dismissWithDataRequestStatus];
    [WDToastUtil toast:Pstring];
}
#pragma mark - 圈圈数据加载框
- (void)showWithDataRequestStatus:(NSString *)requestStr {
    [KVNProgress showWithStatus:requestStr];
}
#pragma mark - 操作成功界面
- (void)showWithSuccessWithStatus:(NSString *)requestStr {
    [KVNProgress showSuccessWithStatus:requestStr];
}

#pragma mark - 数据加载框消失
- (void)dismissWithDataRequestStatus {
    dispatch_main_after(0.1f, ^{
        [KVNProgress dismiss];
    });
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

#pragma mark - 跳转网页
- (void)jumpToWebview:(NSString *)LinkURL webViewTitle:(NSString *)title {
    NSLog(@"%@", LinkURL);
    UniversalWebViewController *webViews = [[UniversalWebViewController alloc] initWithNibName:@"UniversalWebViewController" bundle:nil];
    webViews.WebTiltle = title;
    webViews.requestURL = LinkURL;
    [self customPushViewController:webViews customNum:1];
}


#pragma mark - 加载袋鼠跳跃动画
//显示加载界面
- (void)showWeidaiLoadAnimationView:(UIViewController *)contentView {
    dataLoadAnimationView *dataLoadView = [[dataLoadAnimationView alloc] initWithdataLoadAnimationView];
    dataLoadView.tag = 10010;
    [contentView.view addSubview:dataLoadView];
    [contentView.view bringSubviewToFront:dataLoadView];
    [dataLoadView stratImageAnimating];
}
//隐藏加载界面
- (void)dismissWeidaiLoadAnimationView:(UIViewController *)contentView {
    dataLoadAnimationView *loadView = (dataLoadAnimationView *) [contentView.view viewWithTag:10010];
    if (loadView) {
        [loadView stopImageAnimating];
        [loadView removeFromSuperview];
    }
}
#pragma mark - 系统报错界面
- (void)showMDErrorShowViewForError:(UIViewController *)viewController MDErrorShowViewFram:(CGRect)MDErrorShowViewFram contentShowString:(NSString *)contentShowString MDErrorShowViewType:(MDErrorShowViewType)ErrorShowViewType {

    if (!_ErrorShowView) {
        _ErrorShowView = [[MDErrorShowView alloc] initWithMDErrorShowView:MDErrorShowViewFram contentShowString:contentShowString MDErrorShowViewType:ErrorShowViewType theDelegate:self];
    }
//    [_ErrorShowView setContentString:contentShowString];//好友页面展示字符串异常
    _ErrorShowView.tag = 9999;
    [viewController.view addSubview:_ErrorShowView];
    [viewController.view bringSubviewToFront:_ErrorShowView];
}

- (void)againLoadingData {
}
//隐藏系统报错界面
- (void)hideMDErrorShowView:(UIViewController *)contentView {
    UIView *errorView = (UIView *) [contentView.view viewWithTag:9999];
    if (errorView) {
        [errorView removeFromSuperview];
    }
}

//没有网络或者其他的错误的时候报错
//需要显示报错界面
- (void)initWithWDprojectErrorview:(SDRefreshHeaderView *)weakRefreshHeader contentView:(UIViewController *)contentView MDErrorShowViewFram:(CGRect)MDErrorShowViewFram {
    if (weakRefreshHeader) {
        [weakRefreshHeader endRefreshing];
    }
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self showMDErrorShowViewForError:contentView MDErrorShowViewFram:MDErrorShowViewFram contentShowString:@"亲，没有网络哦！" MDErrorShowViewType:NoData];
        } else {
            [self showMDErrorShowViewForError:contentView MDErrorShowViewFram:MDErrorShowViewFram contentShowString:errorPromptString MDErrorShowViewType:NoData];
        }
    }];
}
//需要显示提示界面
- (void)showErrorViewinMain {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self errorPrompt:3.0 promptStr:@"亲，没有网络哦！"];
        } else {
            [self errorPrompt:3.0 promptStr:@"网络开小差了,请稍后再试"];
        }
    }];
}
#pragma mark - 界面弹出框
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle popupView:(UIView *)popupView {
    self.popupViewController = [[CNPPopupController alloc] initWithContents:@[popupView]];
    self.popupViewController.theme = [CNPPopupTheme defaultTheme:popupView.frame.size.width];
    self.popupViewController.theme.popupStyle = popupStyle;
    self.popupViewController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
    self.popupViewController.delegate = self;
    [self.popupViewController presentPopupControllerAnimated:YES];
}

- (void)dismissPopupController {
    if (self.popupViewController) {
        [self.popupViewController dismissPopupControllerAnimated:YES];
    }
}

#pragma mark - 支付的时候加载框
- (void)showInpayingLoadingView:(UIViewController *)viewControlle {
    if (!_payload) {
        _payload = [[payLoadview alloc] initWithPayloadView];
    }
    _payload.frame = CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64);
    _payload.backgroundColor = [UIColor clearColor];
    [viewControlle.view addSubview:_payload];
    [_payload stratImageAnimating];
}

#pragma mark - 隐藏支付的时候加载框
- (void)hideInpayingLoadingView {
    if (_payload) {
        [_payload stopImageAnimating];
        [_payload removeFromSuperview];
    }
}

#pragma mark - 设置UITableView分割线顶格
- (void)setCellSeperatorToLeft:(UITableViewCell *)cell {
    setLastCellSeperatorToLeft(cell);
}

static void setLastCellSeperatorToLeft(UITableViewCell *cell) {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {

        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {

        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

#pragma mark - 字符串数字的格式化每三位用，分开
- (NSString *)NumberFormatterBackString:(NSString *)NumberString {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    numFormat.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *num = [NSNumber numberWithDouble:[NumberString doubleValue]];
    NSString *numString = [numFormat stringFromNumber:num]; 
    return numString;
}

/* 获取本地时间 */
- (NSString *)getNowTime {
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

#pragma mark - 设置导航栏状态颜色
- (void)setQLStatusBarStyleDefault{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)setQLStatusBarStyleLightContent{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - 判断当前是否在所传视图控制器内
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

#pragma mark - 数据统计（每个界面的时间）
//开始的时候
- (void)talkingDatatrackPageBegin:(NSString *)page_name {
  [TalkingData trackPageBegin:page_name];
}
//离开的时候
- (void)talkingDatatrackPageEnd:(NSString *)page_name {
  [TalkingData trackPageEnd:page_name];
}


- (void)setTheGradientWithView:(UIView *)view
{
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = CGRectMake(0, 0, iPhoneWidth, CGRectGetHeight(view.frame));
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)[self colorFromHexRGB:@"317df4"].CGColor,
                             (id)[self colorFromHexRGB:@"2896f8"].CGColor,
                            /* (id)[UIColor blueColor].CGColor*/];
    
//    //  设置三种颜色变化点，取值范围 0.0~1.0
//    gradientLayer.locations = @[@(0.1f) ,@(0.4f)];
    
//    startPoint&endPoint 颜色渐变的方向，
//范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
//    [view.layer addSublayer:gradientLayer];
    //添加在最底层当背景使用
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setTheXBGradientColorWithView:(UIView *)view
{
    XBGradientColorView * grv=[XBGradientColorView new];
    [view insertSubview:grv atIndex:0];
    grv.frame = CGRectMake(0, 0, iPhoneWidth, view.frame.size.height);
    grv.fromColor = [UIColor colorWithHex:@"#317df4"];
    grv.toColor =[UIColor colorWithHex:@"#2896f8"];
    grv.direction=0;//设置渐变方向
}

#define UILABEL_LINE_SPACE 6
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    // alignment               对齐方式，取值枚举常量 NSTextAlignment
    // firstLineHeadIndent     首行缩进，取值 float
    // headIndent              缩进，取值 float
    // tailIndent              尾部缩进，取值 float
    // ineHeightMultiple       可变行高,乘因数，取值 float
    // maximumLineHeight       最大行高，取值 float
    // minimumLineHeight       最小行高，取值 float
    // lineSpacing             行距，取值 float
    // paragraphSpacing        段距，取值 float
    // paragraphSpacingBefore  段首空间，取值 float
    //
    // baseWritingDirection    句子方向，取值枚举常量 NSWritingDirection
    // lineBreakMode           断行方式，取值枚举常量 NSLineBreakMode
    // hyphenationFactor       连字符属性，取值 0 - 1
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


- (NSString *)clearSiteSpecialCharactersWithURLStr:(NSString *)urlStr
{
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return urlStr;
}

#pragma mark - 替换掉手机号里面含有的空格
- (NSString *)clearPhoneNumerSpaceWithString:(NSString *)phoneStr
{
    phoneStr = [phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return phoneStr;
}

/** 5) 添加自定义效果点
 *    接口说明
 *    系统预留了10个自定义效果点，在需要的时候调用TalkingDataAppCpa的onCustEvent1，onCustEvent2，…，onCustEvent10方法。
 */
- (void)XROnCustEvent1AuthenticationSuccess//认证
{
    [TalkingDataAppCpa onCustEvent1];
}

- (void)XROnCustEvent2RechargeSuccess//充值
{
    [TalkingDataAppCpa onCustEvent2];
}
- (void)XROnCustEvent3InvestmentSuccess//投资 /投标
{
    [TalkingDataAppCpa onCustEvent3];
}
- (void)XROnCustEvent4WithdrawalsSuccess//提现
{
    [TalkingDataAppCpa onCustEvent4];
}



@end
