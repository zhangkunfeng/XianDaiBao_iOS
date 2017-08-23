//
//  PropagandaView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/10.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "PropagandaView.h"
#import "Masonry.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "UIImageView+WebCache.h"

@interface PropagandaView ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    UIButton * _btn;

    UIScrollView * _view;
    
    NSMutableArray * linksArray;
    NSMutableArray * titleArray;
    NSMutableArray * imageArray;
    
    NewPagedFlowView *_pageFlowView;
    BaseViewController * _viewController;
}
@end
#define EachWidth    iPhoneWidth - 84
#define EachHeight   iPhoneHeight * 0.5922
@implementation PropagandaView

- (instancetype)init {
    self = [super init];
    if (self) {
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
    
        [self createView];
//        [self setupUI];
        return self;
    }
    return nil;
}

- (void)createView
{
    _view = [[UIScrollView alloc] init];
    _view.backgroundColor = [UIColor clearColor];
    [self addSubview:_view];
    
    UIButton * btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _btn = btn;
    
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(iPhoneWidth);
        make.height.mas_equalTo(iPhoneHeight * 0.5922);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view.mas_bottom).offset(35);
        make.centerX.mas_equalTo(0);
    }];
    
}

- (void)setPropagandaImagesArray:(NSArray *)array viewController:(UIViewController *)viewController
{
    _viewController = (BaseViewController *)viewController;
    
    linksArray = [NSMutableArray arrayWithCapacity:0];
    titleArray = [NSMutableArray arrayWithCapacity:0];
    imageArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [array count]; i++) {
        [imageArray addObject:![_viewController isBlankString:array[i][@"path"]]
                               ?array[i][@"path"]:@""];
        [titleArray addObject:![_viewController isBlankString:array[i][@"title"]]
                               ?array[i][@"title"]:@""];
        [linksArray addObject:![_viewController isBlankString:array[i][@"urlLink"]]
                               ?array[i][@"urlLink"]:@""];
    }
    [self setupUI];
}

- (void)setupUI {
    
    if (_pageFlowView) {
        [_pageFlowView removeFromSuperview];
    }
    
    /* frame = (0 8; 414 209.625); */
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 8, iPhoneWidth, EachHeight)];
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.minimumPageScale = 0.85;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    pageFlowView.isOpenAutoScroll = YES;
    
    _pageFlowView = pageFlowView;

    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    [_view addSubview:pageFlowView];
    [pageFlowView reloadData];
}
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(EachWidth, EachHeight);//330,185.625
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    if (![_viewController isBlankString:linksArray[subIndex]]) {
        [_viewController dismissPopupController];
        [_viewController jumpToWebview:linksArray[subIndex] webViewTitle:titleArray[subIndex]];
        
        [_viewController dismissPopupController];
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return imageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, EachWidth, EachHeight)];//frame = (0 0; 330 185.625);
        bannerView.tag = index;
//        bannerView.layer.cornerRadius = 4;
//        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
      [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageArray[index]]] placeholderImage:[UIImage imageNamed:@""]];
//    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    NSLog(@"ViewController 滚动到了第%ld页",(long)pageNumber);
}

- (void)btnClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cancelPropagandaViewBtnClicked)]) {
        [self.delegate cancelPropagandaViewBtnClicked];
    }
}


@end
