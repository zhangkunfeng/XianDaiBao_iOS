//
//  ProjectContractMaterialsViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/5.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ProjectContractMaterialsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "YiRefreshHeader.h"
#import "UIImageView+WebCache.h"
#import "PhotoTableViewCell.h"
#import "UITableView+CellHeightCache.h"

@interface ProjectContractMaterialsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * contractMaterialsTableView;
@property(nonatomic,strong) NSMutableArray * contractMaterialsArray;
@property(nonatomic,strong) NSMutableArray * imageViewHeightArray;
@property(nonatomic,strong) YiRefreshHeader * yiRefreshHeader;
@property(nonatomic,strong) UIImage * myImage;
@property(nonatomic,assign) NSInteger i;
@end

@implementation ProjectContractMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contractMaterialsArray = [NSMutableArray arrayWithCapacity:0];
    _i = 0;
    [self createTableView];
    [self setupHeaderRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCellImageData:) name:showDetailContractMaterialsDataimage object:nil];
}

- (void)setupHeaderRefresh
{
    // YiRefreshHeader  头部刷新按钮的使用
    _yiRefreshHeader=[[YiRefreshHeader alloc] init];
    _yiRefreshHeader.scrollView = self.contractMaterialsTableView;
    [_yiRefreshHeader header];
    typeof(_yiRefreshHeader) __weak weakRefreshHeader = _yiRefreshHeader;
    typeof(self) __weak weakSelf = self;

    _yiRefreshHeader.beginRefreshingBlock=^(){
//        typeof(weakRefreshHeader) __strong strongRefreshHeader = weakRefreshHeader;
//        [[NSNotificationCenter defaultCenter] postNotificationName:changeDetailContentScrollView object:nil];
//        [strongRefreshHeader endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf loadContractMaterialsData];
        });
    };
    //    // 是否在进入该界面的时候就开始进入刷新状态
        [weakRefreshHeader beginRefreshing];
}

- (void)createTableView
{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhoneWidth, 64)];
    [self.view addSubview:nav];
    nav.backgroundColor = [UIColor colorWithHex:@"60B8D3"];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(15, 27, 30, 30);
    [back addTarget:self action:@selector(backToUpView:) forControlEvents:(UIControlEventTouchUpInside)];
    [back setImage:[UIImage imageNamed:@"back_ default.png"] forState:(UIControlStateNormal)];
    [nav addSubview:back];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhoneWidth/2.0 - 150/2, 27, 150, 30)];
    titleLab.text = self.title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [nav addSubview:titleLab];
    
    _contractMaterialsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64) style:UITableViewStylePlain];
    //    _tableViewList.backgroundColor = [UIColor orangeColor];
    _contractMaterialsTableView.backgroundColor = [UIColor colorWithHex:@"f7f7f7"];
    _contractMaterialsTableView.delegate = self;
    _contractMaterialsTableView.dataSource = self;
    _contractMaterialsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_contractMaterialsTableView];
}

-(void)backToUpView:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadCellImageData:(NSNotification *)notifica
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _i==0?[self showWithDataRequestStatus:@"加载中..."]:@"";_i++;
        [self loadContractMaterialsData];
    });
}

- (void)loadContractMaterialsData
{
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"bid": _bidString,
                                  @"typeId":_bidTypeId,};
   
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@newEight/contrantData",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadContractMaterialsData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                NSLog(@"%@ = %@",[_bidTypeId isEqualToString:@"29"]?@"合同":@"材料",responseObject);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissWithDataRequestStatus];
                });
//                if (_contractMaterialsArray.count > 0) {
//                    [_contractMaterialsArray removeAllObjects];
//                }
                if ([self isLegalObject:responseObject[@"data"]]) {
                    _contractMaterialsArray = [responseObject[@"data"] copy];
                    if (_contractMaterialsArray.count > 0) {
                        [_contractMaterialsTableView reloadData];
                    }else{
                        [self showMDErrorShowViewForError:self MDErrorShowViewFram:self.view.bounds contentShowString:@"暂无数据" MDErrorShowViewType:NoData];
                    }
                }
            } else {
                [self showMDErrorShowViewForError:self MDErrorShowViewFram:self.view.bounds contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }else{
            [self showMDErrorShowViewForError:self MDErrorShowViewFram:self.view.bounds contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self initWithWDprojectErrorview:nil contentView:self MDErrorShowViewFram:self.view.bounds];
                              }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contractMaterialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* static NSString *TableViewID = @"tableViewId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewID];
    }*/
    
    PhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[PhotoTableViewCell initWithPhotoTableViewCell_ID]];
    if (!cell) {
        cell = [PhotoTableViewCell initWithPhotoTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!_isShowPic) {
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:_contractMaterialsArray[indexPath.row]]];// placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    }else{
        [self showMDErrorShowViewForError:self MDErrorShowViewFram:self.view.bounds contentShowString:@"满标不展示数据" MDErrorShowViewType:NoData];
    }
    
    //去缓存图片 可能走NSData又下载 造成卡顿
//  cell.myImageView.image = [self getImageForSDWebImageCacheOrDownloadWithURL:[NSURL URLWithString:_contractMaterialsArray[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

PhotoTableViewCell *cell;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [tableView getCellHeightCacheWithCacheKey:_contractMaterialsArray[indexPath.row]/*值作为key*/];
    NSLog(@"从缓存取出来图片高度的-----%f",cellHeight);
    
    if(!cellHeight){
        cellHeight = [self getImageCellHeightWithImageWidth:iPhoneWidth-20 AndIdexPathRowData:_contractMaterialsArray[indexPath.row] AndCellImageView:cell.myImageView];
        [tableView setCellHeightCacheWithCellHeight:cellHeight CacheKey:_contractMaterialsArray[indexPath.row]];
    }
    return cellHeight;
}

//获取cellHeight     #import "UIImageView+WebCache.h"
- (CGFloat)getImageCellHeightWithImageWidth:(CGFloat)itemW AndIdexPathRowData:(NSString *)urlString AndCellImageView:(UIImageView *)myImageView
{
    __block CGFloat itemH = 0;
    if (urlString) {
          NSURL * url =[NSURL URLWithString:urlString];
       [myImageView sd_setImageWithURL:url placeholderImage:nil];
        UIImage * image = [self getImageForSDWebImageCacheOrDownloadWithURL:url];
        //根据image的比例来设置高度
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    }
    return itemH;
}

//获取imageCache
- (UIImage *)getImageForSDWebImageCacheOrDownloadWithURL:(NSURL *)url
{
//    __block UIImage * image;
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    BOOL existDiskBool = [manager diskImageExistsForURL:url];//判断是否有缓存
//    if (existDiskBool) {
//        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//    }else{
//        
//        [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            NSLog(@"显示当前进度");
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            image = image;
//        }];
//        
//    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL existDiskBool = [manager diskImageExistsForURL:url];//判断是否有缓存
    UIImage * image;
    if (existDiskBool) {
        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
    }else{//取image 走NSData。。。
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
    }
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //清缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

@end
