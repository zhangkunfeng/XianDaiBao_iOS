//
//  BaseNewProductViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/23.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseNewProductViewController.h"
#import "NewProductListViewController.h"
#import "Masonry.h"
@interface BaseNewProductViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    UISegmentedControl * _productSegment;
}
@property (weak, nonatomic) IBOutlet UIButton *MoreBidListButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBidListButtontrailingConstant;
@property (weak, nonatomic) IBOutlet UIView *NavgationView;
@property (nonatomic,strong) UIView *vi;
@end

@implementation BaseNewProductViewController

//解决APP界面卡死Bug
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIViewController *v in self.childViewControllers) {
        [v viewWillAppear:YES];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0f alpha:1];
//    [self setTheGradientWithView:self.NavgationView];
}


- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];

    _productSegment = [[UISegmentedControl alloc] initWithItems:@[@"定期",@"债转"/*,@"债权转让"*/]];
    _productSegment.selectedSegmentIndex  =  0;
    _productSegment.tintColor = [UIColor clearColor];
    
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];

    dictionay[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictionay[NSFontAttributeName] = [UIFont systemFontOfSize:16];


    [_productSegment setTitleTextAttributes:dictionay forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHex:@"05CBF3"] forKey:NSForegroundColorAttributeName];
    [_productSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [_productSegment addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.NavgationView addSubview:_productSegment];
    //seg下划线
       //位置调整
    [_productSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.bottom.mas_equalTo(-13);
        make.centerX.mas_equalTo(0);
        //make.height.mas_equalTo(30);
        make.width.mas_equalTo(280);
    }];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(iPhoneWidth * 2,CGRectGetHeight(_scrollView.frame));
    [self.view addSubview: _scrollView];
    [self addControllers];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    _vi = [[UIView alloc]init];
    _vi.backgroundColor = [UIColor colorWithHex:@"05CBF3"];
    _vi.frame = CGRectMake((iPhoneWidth - 240)/2 + 35, 62, 50, 2);
    [self.NavgationView addSubview:_vi];

}
#pragma mark - scrollView代理方法
//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / iPhoneWidth;
    _productSegment.selectedSegmentIndex = index;
    
    if (index == 1) {
        _vi.frame = CGRectMake(_productSegment.frame.origin.x + _productSegment.frame.size.width/2 + 35, 62, _productSegment.frame.size.width/2 - 70, 2);
    }else{
        _vi.frame = CGRectMake(_productSegment.frame.origin.x + 35, 62, _productSegment.frame.size.width/2 -70, 2);
    }
    
    for (UIViewController *v in self.childViewControllers) {
        [v viewWillAppear:YES];
    }
}

- (void)segmentedControlAction:(UISegmentedControl *)sgc
{
    //  sgc.selectedSegmentIndex    0 / 1;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(sgc.selectedSegmentIndex * iPhoneWidth, 0);
    }];
    
    if (sgc.selectedSegmentIndex == 1) {
        _vi.frame = CGRectMake(_productSegment.frame.origin.x + _productSegment.frame.size.width/2 + 35, 62, _productSegment.frame.size.width/2 - 70, 2);
    }else{
    _vi.frame = CGRectMake(_productSegment.frame.origin.x + 35, 62, _productSegment.frame.size.width/2 -70, 2);
    }

    for (UIViewController *v in self.childViewControllers) {
        [v viewWillAppear:YES];
    }
}

- (void)addControllers
{
    for (NSInteger i = 0; i < 2; i++) {
        NewProductListViewController * htvc = [[NewProductListViewController alloc] init];
        htvc.type  = i;
        htvc.view.frame = CGRectMake(i * iPhoneWidth,0,iPhoneWidth,iPhoneHeight);
//        htvc.view.backgroundColor = i==1? [UIColor redColor]:[UIColor greenColor];
        [self showMDErrorShowViewForError:htvc MDErrorShowViewFram:htvc.view.frame contentShowString:errorPromptString MDErrorShowViewType:NoData];
        [self addChildViewController:htvc];
        [_scrollView addSubview:htvc.view];
        
//        NSLog(@"%f",htvc.view.frame.size.height);//550
//        NSLog(@"%f",htvc.view.frame.origin.y);//0
//        NSLog(@"%f",_scrollView.frame.size.height);//0
    }
}

/*
- (void)goMoreBidList:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    MoreProductListViewController *MoreProductListView = [[MoreProductListViewController alloc] initWithNibName:@"MoreProductListViewController" bundle:nil];
    if (btn.tag == 100) {
        MoreProductListView.titleString = @"全部标的";
    } else {
        MoreProductListView.titleString = @"已回款标的";
    }
    [self customPushViewController:MoreProductListView customNum:0];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
