//
//  PhotosScrollViewController.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/5.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef NS_ENUM(NSInteger, ImageStrType) {
    ImageUrlStrType = 0,     // url图片字符串
    ImageNameStrType,        // 本地图片字符串
};

@interface PhotosScrollViewController : BaseViewController<CustomUINavBarDelegate>

@property (nonatomic, assign)ImageStrType imageType;

- (void)createPhotosScrollViewTitleString:(NSString *)title
                         photoImageString:(NSString *)imageStr
                                imageType:(ImageStrType)type
                         heightWidthScale:(float)scale;
@end
