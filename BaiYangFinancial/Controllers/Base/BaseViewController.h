//
//  BaseViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "KVNProgress.h"
#import "LoadAnimationView.h"
#import "dataLoadAnimationView.h"
#import <UIKit/UIKit.h>
//弹出试图
#import "CNPPopupController.h"
//系统报错界面
#import "MDErrorShowView.h"
//支付时候的加载框
#import "SDRefresh.h" //加载框
#import "payLoadview.h"
#import "XBGradientColorView.h"

typedef enum {
    CustomPush = 0,
    CustomModal,
    CustomGradient, //渐变
    CustomPaging    //翻页
} CustomPushStates;

#define RGB(r, g, b) \
    [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]

@interface BaseViewController : UIViewController <UIGestureRecognizerDelegate, CNPPopupControllerDelegate, MDErrorShowViewDelegate, NSURLConnectionDataDelegate> {
    LoadAnimationView *loadAnimation;
}

//@property (nonatomic, assign)CustomPushStates *customPushmode;
@property (nonatomic, strong) CNPPopupController *popupViewController; //弹出试图
@property (nonatomic, strong) payLoadview *payload;                    // 支付加载框


#pragma mark - 滑动返回禁用/启用
- (void)forbiddenSideBack;
- (void)resetSideBack;

#pragma mark - ---------- 计算文本大小
- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

#pragma mark - Push/Pop
- (void)customPresentViewController:(UIViewController *)controller;
- (void)customPresentViewController:(UIViewController *)controller withAnimation:(BOOL)enableAnimation;
- (void)customDismissController;
- (void)customDismissControllerWithAnimation:(BOOL)enableAnimation;
- (void)customDismissControllerWithAnimation:(BOOL)flag completion:(void (^)(void))completion;

#pragma mark - 正则判断
- (BOOL)isLegalNum:(NSString *)text;
- (BOOL)isBlankString:(NSString *)string;
- (BOOL)isLegalObject:(NSObject *)object;
- (BOOL)isPureFloat:(NSString *)string;

#pragma mark - 手机号码字符串查找替换删除截取操作(通讯录)
- (NSString *)searchReplaceRemoveClippingOperationForPhoneNumStr:(NSString *)phoneNumStr;
#pragma mark - 返回指定页面
- (void)jumpViewController:(NSString *)viewContoller;

#pragma mark - Navigation Controller
- (void)customPushViewController:(UIViewController *)controller customNum:(NSInteger)number;
- (void)customPushViewController:(UIViewController *)controller customNum:(NSInteger)number animation:(BOOL)animate;

- (void)customPopViewController:(NSInteger)CustomPushStatesnumber;
- (void)customPopViewControllerWithAnimation:(BOOL)animate CustomPushStates:(NSInteger)CustomPushStatesnumber;
//- (void) customPopViewControllerWithLevel:(NSInteger)level animated:(BOOL)animate;

#pragma mark - pop 到指定层级
- (void)comePopViewControllerWithAnimation:(BOOL)animate CustomPushIndex:(NSInteger)pushIndex;

#pragma mark -16进制计算颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString;

#pragma mark - 添加安全管理资金view
//- (void)addSafetyViewToSubview:(UIView *)Sudview;
#pragma mark - 添加安全管理资金
//- (void)addCustomServicesiPhoneNumberView:(UIView *)customServicesView viewController:(UIViewController *)viewController;

#pragma mark - 字典本地存储
- (void)userDefaultsKeyForDictionary:(NSDictionary *)valueDictionary defaultsKey:(NSString *)keyString;
- (NSDictionary *)getLocalUserinfoDict;
- (void)removeLocalUserinfoDict;
#pragma mark - 获取 bundle version版本号
- (NSString*)getLocalAppVersion;

#pragma mark - json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

#pragma mark - 错误提示
- (void)errorPrompt:(float)timerCancel promptStr:(NSString *)Pstring;
#pragma mark - 圈圈加载框
- (void)showWithDataRequestStatus:(NSString *)requestStr;
#pragma mark - 操作成功界面
- (void)showWithSuccessWithStatus:(NSString *)requestStr;
#pragma mark - 数据加载框消失
- (void)dismissWithDataRequestStatus;

#pragma mark - 跳转网页
- (void)jumpToWebview:(NSString *)LinkURL webViewTitle:(NSString *)title;

#pragma mark - 加载袋鼠跳跃动画
//显示加载界面
- (void)showWeidaiLoadAnimationView:(UIViewController *)contentView;
//隐藏加载动画
- (void)dismissWeidaiLoadAnimationView:(UIViewController *)contentView;

#pragma mark - 系统报错界面
- (void)showMDErrorShowViewForError:(UIViewController *)viewController MDErrorShowViewFram:(CGRect)MDErrorShowViewFram contentShowString:(NSString *)contentShowString MDErrorShowViewType:(MDErrorShowViewType)ErrorShowViewType;
//隐藏系统报错界面
- (void)hideMDErrorShowView:(UIViewController *)contentView;
//没有网络或者其他的错误的时候报错
- (void)initWithWDprojectErrorview:(SDRefreshHeaderView *)weakRefreshHeader contentView:(UIViewController *)contentView MDErrorShowViewFram:(CGRect)MDErrorShowViewFram;
//需要显示提示界面
- (void)showErrorViewinMain;
#pragma mark - 界面弹出框
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle popupView:(UIView *)popupView;
#pragma mark - 关闭弹出试图
- (void)dismissPopupController;

#pragma mark - 支付的时候加载框
- (void)showInpayingLoadingView:(UIViewController *)viewController;
#pragma mark - 隐藏支付的时候加载框
- (void)hideInpayingLoadingView;

#pragma mark - 设置UITableView分割线顶格
- (void)setCellSeperatorToLeft:(UITableViewCell *)cell;

#pragma mark - 字符串数字的格式化每三位用，分开
- (NSString *)NumberFormatterBackString:(NSString *)NumberString;
#pragma mark - 获取本地时间
- (NSString *)getNowTime;

#pragma mark - 设置导航栏状态栏颜色
- (void)setQLStatusBarStyleDefault;
- (void)setQLStatusBarStyleLightContent;

#pragma mark - 数据统计（每个界面的时间）
//开始的时候
- (void)talkingDatatrackPageBegin:(NSString *)page_name;
//离开的时候
- (void)talkingDatatrackPageEnd:(NSString *)page_name;
#pragma mark - 设置不规则大小颜色等文本
- (UILabel *)AttributedString:(NSString *)willChangeString andTextColor:(UIColor *)color andTextFontSize:(CGFloat)fontSize AndRange:(CGFloat)startPosition withlength:(CGFloat)length AndLabel:(UILabel *)label;


#pragma mark - 给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;
#pragma mark - 计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

#pragma mark - 替换掉手机号里面含有的空格
- (NSString *)clearPhoneNumerSpaceWithString:(NSString *)phoneStr;

#pragma mark - 判断当前是否在所传视图控制器内
+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

#pragma mark - 设置渐变颜色
- (void)setTheGradientWithView:(UIView *)view;
#pragma mark - XBGradientColorView 渐变
- (void)setTheXBGradientColorWithView:(UIView *)view;
#pragma mark - 去除网址空格及换行符
- (NSString *)clearSiteSpecialCharactersWithURLStr:(NSString *)urlStr;

#pragma mark - talkingData Ad广告监测 自定义效果点
- (void)XROnCustEvent1AuthenticationSuccess;//认证
- (void)XROnCustEvent2RechargeSuccess;//充值
- (void)XROnCustEvent3InvestmentSuccess;//投资 /投标
- (void)XROnCustEvent4WithdrawalsSuccess;//提现

@end
