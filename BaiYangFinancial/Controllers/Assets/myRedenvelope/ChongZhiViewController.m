//
//  ChongZhiViewController.m
//  BaiYangFinancial
//
//  Created by 民华 on 2017/8/3.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "MyRedCollectionViewCell.h"
#import "SDRefresh.h"
#import "XYErrorView.h"
@interface ChongZhiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *ChongZiCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *moenyLab;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;//上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *weakRefreshHeader;
@property (nonatomic, copy) NSMutableArray *accinfoArray;

@end
@implementation ChongZhiViewController
static NSString *cellCollectID = @"cellCollectID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //请求数据页数为1
    _pageIndexNum = 1;
    [self setUI];
    [self loadRedenvelopeData];
}


-(void)setUI{
    _ChongZiCollectionView.delegate = self;
    _ChongZiCollectionView.dataSource = self;
    _ChongZiCollectionView.showsHorizontalScrollIndicator = NO;
    // [_footCollectView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:cellCollectID];
    [_ChongZiCollectionView registerNib:[UINib nibWithNibName:@"MyRedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellCollectID];
}
#pragma mark - 加载我的红包数据
- (void)loadRedenvelopeData{
    NSDictionary *parameters = nil;
    
        
    WS(weakSelf);
    [self showWithDataRequestStatus:@"获取红包中..."];
    parameters = @{
                   @"uid":getObjectFromUserDefaults(UID),
                   @"at" :getObjectFromUserDefaults(ACCESSTOKEN),
                   @"status": [NSString stringWithFormat:@"%zd", 1],
                   @"page": [NSString stringWithFormat:@"%zd", _pageIndexNum],
                   @"rows": @"20"
                   };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/userRedCenter",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadRedenvelopeData];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                [self dismissWithDataRequestStatus];
                [_weakRefreshHeader endRefreshing];
                //移除错误界面
                [weakSelf hideMDErrorShowView:self];
                if (_pageIndexNum == 1 && [_accinfoArray count] > 0) {
                    [_accinfoArray removeAllObjects];
                }
                NSArray *array = responseObject[@"data"];
                if (_pageIndexNum > 1) {
                    if ([array count] == 0) {
                        [weakSelf errorPrompt:3.0 promptStr:[NSString stringWithFormat:@"没有更多%@",weakSelf.title]];
                    }
                }
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    for (int i = 0; i < [array count]; i++) {
                
                    
                    }
                }
                if ([_accinfoArray count] > 0) {
                    //移除错误界面
                    [weakSelf hideMDErrorShowView:self];
                    [weakSelf.ChongZiCollectionView reloadData];
                }else{
                    NSString * redenvelistNullStr = [NSString stringWithFormat:@"你还没有%@",self.title];
                    [weakSelf showMDErrorShowViewForError:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108) contentShowString:redenvelistNullStr MDErrorShowViewType:NoRedenveLope];
                }
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadRedenvelopeData];
                } withFailureBlock:^{
                    
                }];
            }else{
                [weakSelf errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                [_weakRefreshHeader endRefreshing];
            }
        }
    } fail:^{
        [weakSelf dismissWithDataRequestStatus];
        [_weakRefreshHeader endRefreshing];
        [self initWithWDprojectErrorview:_weakRefreshHeader contentView:self MDErrorShowViewFram:CGRectMake(0, 0, iPhoneWidth, iPhoneHeight - 108)];
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     MyRedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellCollectID forIndexPath: indexPath];
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToLicAction:(id)sender {
}
- (IBAction)canAction:(id)sender {
}
#pragma mark -----  上下拉加载  ------
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_ChongZiCollectionView];
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageIndexNum = 1;
            [self loadRedenvelopeData];
        });
    };
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_ChongZiCollectionView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    _pageIndexNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadRedenvelopeData];
        [self.refreshFooter endRefreshing];
        
    });
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
