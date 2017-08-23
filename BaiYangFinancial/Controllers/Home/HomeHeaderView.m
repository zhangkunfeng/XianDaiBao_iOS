//
//  HomeHeaderView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "HomeHeaderView.h"
#import "NewDiscoveryViewController.h"
#import "VerificationiPhoneNumberViewController.h"
#import "SDCycleScrollView.h"
#import "AdvertiseInfoBean.h"

@interface HomeHeaderView ()<SDCycleScrollViewDelegate>
{
    BaseViewController *_viewController;
    
    NSMutableArray * linksArray;
    NSMutableArray * titleArray;
    NSMutableArray * imageArray;
}

@property (nonatomic,strong)NewDiscoveryViewController *discoveryViewController;
@property (copy, nonatomic) NSDictionary *homeinfoDict;

@end

@implementation HomeHeaderView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.homeMoneyEyeBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateNormal];
    [self.homeMoneyEyeBtn setImage:[UIImage imageNamed:@"睁眼"] forState: UIControlStateHighlighted];
    [self.homeMoneyEyeBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
    [self.homeMoneyEyeBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [self.homeMoneyEyeBtn addTarget:self action:@selector(homeMoneyEyeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController {
    if (![super init]) {
        return nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:self options:nil] lastObject];
    self.frame = viewFram;
    _viewController = (BaseViewController *)viewController;
    
//    [_viewController setTheGradientWithView:self.headerView_topView];
//    [_viewController setTheGradientWithView:self.topView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionViewTap:)];
    [self.functionView addGestureRecognizer:tap];
    
    [self InitializationData];//初始化数据 避闪改数据
    
    return self;
}

- (void)functionViewTap:(UITapGestureRecognizer *)tap
{
    [_viewController jumpToWebview:SecurityURL webViewTitle:@"安全保障"];
}

- (void)setAdViewDataWithArray:(NSArray *)array
{
    linksArray = [NSMutableArray arrayWithCapacity:0];
    titleArray = [NSMutableArray arrayWithCapacity:0];
    imageArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [array count]; i++) {
        AdvertiseInfoBean *advInfo;
        advInfo = [array objectAtIndex:i];
        
        [imageArray addObject:advInfo.advertise_logo?advInfo.advertise_logo:@""];
        [titleArray addObject:advInfo.advertise_title?advInfo.advertise_title:@""];
        [linksArray addObject:advInfo.advertise_url?advInfo.advertise_url:@""];
    }
    
    NSString * imageStr = @"scroll_default";
    // 网络加载 --- 创建带标题的图片轮播器
    CGFloat adViewHeight = self.frame.size.height-80-10;
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, iPhoneWidth, adViewHeight) delegate:self placeholderImage:[UIImage imageNamed:imageStr]];
        
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //    cycleScrollView2.titlesGroup = titleArray;
        cycleScrollView2.currentPageDotColor = AppMianColor; // 自定义分页控件小圆标颜色
        cycleScrollView2.imageURLStringsGroup = imageArray;
    cycleScrollView2.backgroundColor= [UIColor colorWithHexString:@"F4F4F4"];
        cycleScrollView2.pageDotColor = [UIColor colorWithHex:@"F2F2F2"];
        [_adView addSubview:cycleScrollView2];
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    if (![_viewController isBlankString:linksArray[index]]) {
        [_viewController jumpToWebview:linksArray[index] webViewTitle:titleArray[index]];
    }
}

/**
      UILabel *earningsLabel;//当月收益
      UILabel *totalAssetsLabel;//总资产
      UILabel *accumulatedEarningsLabel;//累计收益
 */
- (void)setTheMonthAssetsEarningsDataWithDictionary:(NSDictionary *)dict
{
    _homeinfoDict = [dict copy];
    if ([getObjectFromUserDefaults(SHOWHOMEMONEY) isEqualToString:@"YES"]) {
        self.homeMoneyEyeBtn.selected = YES;
        self.earningsLabel.text = @"****";
        self.totalAssetsLabel.text  = @"****";
        self.accumulatedEarningsLabel.text = @"****";
    }else{
        //本月收益
        if ([_viewController isLegalObject:_homeinfoDict[@"currentMonthEarning"]]) {
            self.earningsLabel.text = [Number3for1 formatAmount:_homeinfoDict[@"currentMonthEarning"]];
        }
        
        //总资产
        if ([_viewController isLegalObject:_homeinfoDict[@"amount"]]) {
            self.totalAssetsLabel.text = [Number3for1 formatAmount:_homeinfoDict[@"amount"]];
        }
        
        //累计收益
        if ([_viewController isLegalObject:_homeinfoDict[@"totalEarning"]]) {
            self.accumulatedEarningsLabel.text = [Number3for1 formatAmount:_homeinfoDict[@"totalEarning"]];
        }
    }
}

//UILabel *earningsLabel;//当月收益
//UILabel *totalAssetsLabel;//总资产
//UILabel *accumulatedEarningsLabel;//累计收益
#pragma mark - HomeMoneyEyeBtnSetting
- (void)InitializationData
{
    if ([getObjectFromUserDefaults(SHOWHOMEMONEY) isEqualToString:@"YES"]) {
        self.homeMoneyEyeBtn.selected  = YES;
        self.earningsLabel.text            = @"****";
        self.totalAssetsLabel.text         = @"****";
        self.accumulatedEarningsLabel.text = @"****";
        self.totalAmountToTop.constant = 24;
        self.totalAmountToBottom.constant = 11;
    }
}

- (void)homeMoneyEyeBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        self.earningsLabel.text            = @"****";
        self.totalAssetsLabel.text         = @"****";
        self.accumulatedEarningsLabel.text = @"****";
        self.totalAmountToTop.constant = 24;
        self.totalAmountToBottom.constant = 11;
        getObjectFromUserDefaults(SHOWHOMEMONEY) ? removeObjectFromUserDefaults(SHOWHOMEMONEY) : @"";
        saveObjectToUserDefaults(@"YES",SHOWHOMEMONEY);
    }else{
        //本月收益
        if ([_viewController isLegalObject:_homeinfoDict[@"currentMonthEarning"]]) {
            self.earningsLabel.text = [Number3for1 formatAmount:_homeinfoDict[@"currentMonthEarning"]];
        }
        
        //总资产
        if ([_viewController isLegalObject:_homeinfoDict[@"amount"]]) {
            self.totalAssetsLabel.text = [Number3for1 formatAmount:_homeinfoDict[@"amount"]];
        }
        
        //累计收益
        if ([_viewController isLegalObject:_homeinfoDict[@"totalEarning"]]) {
            self.accumulatedEarningsLabel.text = [Number3for1 formatAmount:_homeinfoDict[@"totalEarning"]];
        }
        self.totalAmountToTop.constant = 15;
        self.totalAmountToBottom.constant = 20;
        getObjectFromUserDefaults(SHOWHOMEMONEY) ? removeObjectFromUserDefaults(SHOWHOMEMONEY) : @"";
        saveObjectToUserDefaults(@"NO",SHOWHOMEMONEY);
    }
}

@end
