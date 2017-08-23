//
//  XYErrorView.m
//  xycms
//
//  Created by 姚琪 on 15/12/2.
//  Copyright © 2015年 xycms. All rights reserved.
//

#import "Masonry.h"
#import "XYErrorView.h"

@interface XYErrorView ()

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIImageView *imgLog;

@end

@implementation XYErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lblTitle];
        [self addSubview:self.imgLog];
    }
    return self;
}

- (void)updateConstraints {
    __weak typeof(self) weakself = self;

    [self.imgLog mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.centerY.equalTo(weakself);
    }];

    [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.top.equalTo(weakself.imgLog.mas_bottom).offset(10);
    }];
    [super updateConstraints];
}

+ (void)showInView:(UITableView *)parentView title:(NSString *)title {
    if (!parentView) return;

    UIView *backgroundview = parentView.backgroundView;
    if (!backgroundview) {
        backgroundview = [[self alloc] init];
        backgroundview.backgroundColor = RGB(239, 239, 239);
        parentView.backgroundView = backgroundview;
    }

    XYErrorView *errorview = (XYErrorView *) backgroundview;
    errorview.lblTitle.text = title;
}

+ (void)hideInView:(UITableView *)parentView {
    if (!parentView) return;
    parentView.backgroundView = nil;
}

#pragma mark - getters && setters
- (UILabel *)lblTitle {
    if (_lblTitle == nil) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.textColor = RGB(153, 153, 153);
        _lblTitle.font = [UIFont systemFontOfSize:15.0f];
    }
    return _lblTitle;
}

- (UIImageView *)imgLog {
    if (_imgLog == nil) {
        _imgLog = [[UIImageView alloc] init];
        _imgLog.image = [UIImage imageNamed:@"no_redimage"];
    }
    return _imgLog;
}

@end
