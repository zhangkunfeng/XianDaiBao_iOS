//
//  ProductSectionView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/16.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "OtherFinancialHeaderView.h"
#import "SDImageCache.h"

@interface OtherFinancialHeaderView ()
{
    NSString * _type;
    
    NSString * _descImageUrlKey;
    NSString * _descImagePathKey;
    NSString * _descImageTitleKey;

    BaseViewController * _viewController;
}
@end

@implementation OtherFinancialHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    self = [[[NSBundle mainBundle] loadNibNamed:@"OtherFinancialHeaderView" owner:self options:nil] lastObject];
    }
    self.descImageView.userInteractionEnabled = YES;
    
    return self;
}

- (void)setViewController:(UIViewController *)viewController withType:(NSString *)type
{
    _type = type;
    _viewController = (BaseViewController *)viewController;
    [self loadAdimage];
}

- (void)loadAdimage{
    
    if([_type isEqualToString:@"long"]){
        _descImageUrlKey = @"long-descImage.url";
        _descImagePathKey = @"long-descImage.path";
        _descImageTitleKey = @"long-descImage.title";
    } else {
        _descImageUrlKey = @"long-descImage.url";
        _descImagePathKey = @"long-descImage.path";
        _descImageTitleKey = @"long-descImage.title";
    }
    NSString *imageURL = [[NSUserDefaults standardUserDefaults] objectForKey:_descImagePathKey];
    UIImage *descImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageURL];
    if (descImage) {
        self.descImageView.image = descImage;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherDescImageViewTap:)];
        [self.descImageView addGestureRecognizer:tap];
    }else{
        self.descImageView.image = [UIImage imageNamed:@"活动条"];
    }
}

- (void)otherDescImageViewTap:(UITapGestureRecognizer *)tap
{
    //跳转页面
    NSString *urlLink = [[NSUserDefaults standardUserDefaults] objectForKey:_descImageUrlKey];
    NSLog(@"other - urlLink = %@",urlLink);
    if (urlLink) {
        [_viewController jumpToWebview:urlLink webViewTitle:[[NSUserDefaults standardUserDefaults] objectForKey:_descImageTitleKey]];
    }
}
@end
