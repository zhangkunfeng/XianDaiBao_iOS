//
//  DiscoverHeadView.h
//  BaiYangFinancial
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DiscoverHeadViewDelegate <NSObject>

- (void)meFriend;
- (void)reload;
- (void)redBo;

@end

@interface DiscoverHeadView : UIView
@property (nonatomic, weak)id<DiscoverHeadViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIButton *seleBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIView *friendView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
