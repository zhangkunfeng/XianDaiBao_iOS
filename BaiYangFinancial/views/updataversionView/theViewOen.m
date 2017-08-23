//
//  AlartView.m
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/13.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "theViewOen.h"

@implementation theViewOen

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWiththeDelegate:(id<theViewOenDelegate>) theDelegate{

    self = [[[NSBundle mainBundle] loadNibNamed:@"theViewOen" owner:self options:nil] lastObject];
    if (self) {
       
        delegate = theDelegate;
        return self;
    }
    return nil;

}
- (IBAction)centerBtn:(id)sender {
    
    [delegate center];
}

@end
