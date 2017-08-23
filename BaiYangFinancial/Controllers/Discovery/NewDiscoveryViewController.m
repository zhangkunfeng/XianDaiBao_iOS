//
//  NewDiscoveryViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 16/9/29.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "NewDiscoveryViewController.h"
#import "NewDiscoveryListViewController.h"
#import "AddressBookViewController.h"
#import "AddPhoneAdressViewController.h"
#import "Masonry.h"
@interface NewDiscoveryViewController ()<UIScrollViewDelegate>
{
    UIButton * _addAdressBookBtn;
    UIButton * _addPhoneAdressBookBtn;
    UIScrollView * _scrollView;
    UISegmentedControl * _productSegment;// 贤钱宝动态 | 我的消息
}
@property (nonatomic, strong)UILabel *DotsLable; //有消息时候小红点
@property (weak, nonatomic) IBOutlet UIView *NavigationView;
- (IBAction)goBack:(id)sender;

@end

@implementation NewDiscoveryViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self talkingDatatrackPageEnd:@"发现"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"发现"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self slideSwitchviewAndisaddRedDots];
//    [self setTheGradientWithView:self.NavigationView];
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];

    _productSegment = [[UISegmentedControl alloc] initWithItems:@[@"动态",@"消息"]];
    _productSegment.selectedSegmentIndex  =  0;
    _productSegment.tintColor = [UIColor whiteColor];
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];
    dictionay[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [_productSegment setTitleTextAttributes:dictionay forState:UIControlStateNormal];
    [_productSegment addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.NavigationView addSubview:_productSegment];
    
    [_productSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(146);
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
}
#pragma mark - scrollView代理方法
- (void)segmentedControlAction:(UISegmentedControl *)sgc
{
    //  sgc.selectedSegmentIndex    0 / 1;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(sgc.selectedSegmentIndex * iPhoneWidth, 0);
    }];
    
    if (sgc.selectedSegmentIndex == 1 && _DotsLable.hidden == NO) {//新消息点击清除
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscoveryView object:nil];
        _DotsLable.hidden = YES;
    }
}
//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / iPhoneWidth;
    _productSegment.selectedSegmentIndex = index;
    
    if (index == 1  &&  _DotsLable.hidden == NO) {//新消息滑动清除
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscoveryView object:nil];
        _DotsLable.hidden = YES;
    }
}

- (void)addControllers
{
    for (NSInteger i = 0; i < 2; i++) {
        NewDiscoveryListViewController * htvc = [[NewDiscoveryListViewController alloc] init];
        htvc.type  = i;
        htvc.view.frame = CGRectMake(i * iPhoneWidth,0,iPhoneWidth,iPhoneHeight);
//        htvc.view.backgroundColor = i==1? [UIColor redColor]:[UIColor greenColor];
        [self addChildViewController:htvc];
        [_scrollView addSubview:htvc.view];
    }
}

//设置滑动视图及小红点
- (void)slideSwitchviewAndisaddRedDots
{
    [self isaddRedDots];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ishideDiscoveryNumberLable:) name:HideDiscoveryviewRedDot object:nil];
}

#pragma mark - 当有消息的时候显示小红点
- (void)isaddRedDots{
   
        //添加消息小红点
        _DotsLable = [[UILabel alloc] init];//20总间距 宽度
        _DotsLable.frame = CGRectMake(CGRectGetMaxX(_productSegment.frame)+44, CGRectGetMinY(_productSegment.frame)+5, 6, 6);
        _DotsLable.layer.masksToBounds = YES;
        _DotsLable.layer.cornerRadius = 3.0;
        _DotsLable.hidden = _isHaveMessage;
        _DotsLable.backgroundColor = [UIColor whiteColor];
        [_productSegment addSubview:_DotsLable];
    
}

- (void)ishideDiscoveryNumberLable:(id)sender{

    if (_DotsLable) {
        if ([self isBlankString:getObjectFromUserDefaults(UID)]) {
            _DotsLable.hidden = YES;
        }else{
            _DotsLable.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
     [self customPopViewController:3]; 
}
@end
