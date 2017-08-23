//
//  CustomMadeNavigationControllerView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "CustomMadeNavigationControllerView.h"
#import "XBGradientColorView.h"

@implementation CustomMadeNavigationControllerView

- (id)initWithTitle:(NSString *)titleStr showBackButton:(BOOL)isShowButton showRightButton:(BOOL)isShowRightButton rightButtonTitle:(NSString *)rightButtonTile target:(id<CustomUINavBarDelegate>)theTarget {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomMadeNavigationControllerView" owner:self options:nil] lastObject];
    if (self) {
        self.CustomTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.CustomTitle.text = titleStr;
        self.CustomTitle.textColor = [UIColor whiteColor];
        if (!isShowButton) {
            self.backButton.hidden = YES;
        }

        if (!isShowRightButton) {
            self.RightButton.hidden = YES;
        } else {
            [self.RightButton setTitle:rightButtonTile forState:UIControlStateNormal];
        }

        [self.backButton setImage:[UIImage imageNamed:@"back_ default"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"back_ Selected"] forState:UIControlStateHighlighted];
        delegate = theTarget;
        
    }
    CGRect rectFarm = self.frame;
    rectFarm.size.width = iPhoneWidth;
    self.frame = rectFarm;

//    [self setTheXBGradientColorWithView:self.NavigationView];
    
    return self;
}

- (void)setTheXBGradientColorWithView:(UIView *)view
{
    XBGradientColorView * grv=[XBGradientColorView new];
    [view insertSubview:grv atIndex:0];
    grv.frame = CGRectMake(0, 0, iPhoneWidth, view.frame.size.height);
    grv.fromColor = [UIColor colorWithHex:@"#317df4"];
    grv.toColor =[UIColor colorWithHex:@"#2896f8"];
    grv.direction=0;//设置渐变方向
}


- (IBAction)goBackButtonAction:(id)sender {
    [delegate goBack];
}

- (IBAction)rightButtonAction:(id)sender {
    [delegate doOption];
}
@end
