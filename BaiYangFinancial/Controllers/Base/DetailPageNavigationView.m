//
//  CustomMadeNavigationControllerView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "DetailPageNavigationView.h"

@implementation DetailPageNavigationView

- (id)initWithDetailPageNavigationViewTitle:(NSString *)titleStr showBackButton:(BOOL)isShowButton showRightButton:(BOOL)isShowRightButton rightButtonTitle:(NSString *)rightButtonTile target:(id<DetailPageNavigationViewDelegate>)theTarget {
    self = [[[NSBundle mainBundle] loadNibNamed:@"DetailPageNavigationView" owner:self options:nil] lastObject];
    if (self) {
        self.CustomTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.CustomTitle.text = titleStr;
      //  self.CustomTitle.textColor = [UIColor redColor];
        if (!isShowButton) {
            self.backButton.hidden = YES;
        }

        if (!isShowRightButton) {
            self.RightButton.hidden = YES;
        } else {
            [self.RightButton setTitle:rightButtonTile forState:UIControlStateNormal];
        }

//        [self.backButton setImage:[UIImage imageNamed:@"back_detailPage"] forState:UIControlStateNormal];
//        [self.backButton setImage:[UIImage imageNamed:@"back_detailPage"] forState:UIControlStateHighlighted];
        delegate = theTarget;
        
    }
    CGRect rectFarm = self.frame;
    rectFarm.size.width = iPhoneWidth;
    self.frame = rectFarm;
    
    return self;
}

- (void)setupTitleStr:(NSString *)titleStr{
     self.CustomTitle.text = titleStr;
}

- (IBAction)goBackButtonAction:(id)sender {
    [delegate goBack];
}

- (IBAction)rightButtonAction:(id)sender {
    [delegate doOption];
}
@end
