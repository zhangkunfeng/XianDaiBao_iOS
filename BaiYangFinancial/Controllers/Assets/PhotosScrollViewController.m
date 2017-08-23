//
//  PhotosScrollViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/5.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "PhotosScrollViewController.h"
#import "UIImageView+WebCache.h"

@interface PhotosScrollViewController ()

@end

@implementation PhotosScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)createPhotosScrollViewTitleString:(NSString *)title
                         photoImageString:(NSString *)imageStr
                                imageType:(ImageStrType)type
                         heightWidthScale:(float)scale

{
    CustomMadeNavigationControllerView *photosScrollView = [[CustomMadeNavigationControllerView alloc] initWithTitle:title showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:photosScrollView];
    
   
    switch (type) {
            
        case ImageUrlStrType:
        {
//           UIImage * urlImage = [self getImageForSDWebImageCacheOrDownloadWithURLStr:imageStr];
            
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];
//            scrollView.contentSize = CGSizeMake(iPhoneWidth,iPhoneWidth*scale);
            [self.view addSubview:scrollView];
            
//            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneWidth*scale)];
            UIImageView * imageV = [[UIImageView alloc] init];
//            imageV.image = [UIImage imageNamed:imageStr];
            [scrollView addSubview:imageV];
            /**
             *  sdwebimage获取图片宽高
             */
//            UIImageView * sdImgView = [UIImageView new];
//            [self.view addSubview:sdImgView];
            NSURL * url = [NSURL URLWithString:imageStr];
            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat heightWidthScale = image.size.height / image.size.width;
//                NSLog(@"%f==%f",image.size.height,image.size.width);
                
                
                    scrollView.contentSize = CGSizeMake(iPhoneWidth,iPhoneWidth*heightWidthScale);
                
//                scrollView.contentSize = CGSizeMake(iPhoneWidth,iPhoneWidth*scale);
                imageV.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneWidth*heightWidthScale);
                imageV.image = image;
            }];
            
//            CGFloat heightWidthScale = urlImage
        }
            break;
            
        case ImageNameStrType:
        {
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];
            scrollView.contentSize = CGSizeMake(iPhoneWidth,iPhoneWidth*scale);
            [self.view addSubview:scrollView];
            
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneWidth*scale)];
            imageV.image = [UIImage imageNamed:imageStr];
            [scrollView addSubview:imageV];
        }
            break;
        default:
            break;
    }
    
  
}

- (UIImage *)getImageForSDWebImageCacheOrDownloadWithURLStr:(NSString *)urlStr
{
    __block UIImage * image;
    NSURL *url = [NSURL URLWithString:@"imageStr"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL existDiskBool = [manager diskImageExistsForURL:url];//判断是否有缓存
    if (existDiskBool) {
        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
    }else{
        
        [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"显示当前进度");
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            image = image;
        }];
    }
    return image;
}


- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
