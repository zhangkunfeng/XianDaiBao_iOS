//
//  MDErrorShowView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/26.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "MDErrorShowView.h"

@implementation MDErrorShowView

- (id)initWithMDErrorShowView:(CGRect)MDErrorShowViewFarm contentShowString:(NSString *)contentShowString MDErrorShowViewType:(MDErrorShowViewType)ErrorType theDelegate:(id<MDErrorShowViewDelegate>) theDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MDErrorShowView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = MDErrorShowViewFarm;
        delegate = theDelegate;
        
        [self.contentButton setTitle:contentShowString forState:UIControlStateNormal];
        
        if (ErrorType == NoNetwork) {
            self.contentButton.enabled = YES;
        }else if (ErrorType == againRequestData){
            self.contentButton.enabled = YES;
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aginaRequestGestureRecognizer)];
            [self.contentImageView addGestureRecognizer:gestureRecognizer];
//            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aginaRequestGestureRecognizer:)];
//            [self.contentImageView addGestureRecognizer:gestureRecognizer];
        }else{//NoData || NoRedenveLope
            self.contentButton.enabled = YES;
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aginaRequestGestureRecognizer)];
            [self.contentImageView addGestureRecognizer:gestureRecognizer];
        }
    }
    return self;
}

/*
- (void)setContentString:(NSString *)str
{
    [self.contentButton setTitle:str forState:UIControlStateNormal];
}*/

- (void)aginaRequestGestureRecognizer{
    [delegate againLoadingData];
}

- (IBAction)contentButtonAction:(id)sender {
    self.contentButton.enabled = NO;
    [delegate againLoadingData];
    [self performSelector:@selector(ReductioncontentButton) withObject:self afterDelay:1.0];
}

- (void)ReductioncontentButton{
    self.contentButton.enabled = YES;
}

@end
