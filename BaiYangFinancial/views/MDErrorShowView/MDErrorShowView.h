//
//  MDErrorShowView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/26.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    NoNetwork = 0,
    NoData = 1,
    againRequestData = 2,
    NoRedenveLope = 3 //后添加 没有红包
}MDErrorShowViewType;

@protocol MDErrorShowViewDelegate <NSObject>

- (void)againLoadingData;

@end

@interface MDErrorShowView : UIView{
    id<MDErrorShowViewDelegate> delegate;
}


- (id)initWithMDErrorShowView:(CGRect)MDErrorShowViewFarm contentShowString:(NSString *)contentShowString MDErrorShowViewType:(MDErrorShowViewType)ErrorType theDelegate:(id<MDErrorShowViewDelegate>) theDelegate;

//- (void)setContentString:(NSString *)str;//强制执行更改文字

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
- (IBAction)contentButtonAction:(id)sender;

@end
