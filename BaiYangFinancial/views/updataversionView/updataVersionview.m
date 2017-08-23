//
//  updataVersionview.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/9/25.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "updataVersionview.h"

@implementation updataVersionview

- (id)initWithupdataVersionview:(VersionupdataStyle)VersionupdataStyle contentString:(NSString *)contentString theDelegate:(id<versionUpdataviewDelegate>) theDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"updataVersionview" owner:self options:nil] lastObject];
    if (self) {
        if (VersionupdataStyle == NOFORCEUPDATAVERSION) {
            self.leftButtonwidthConstraint.constant = (280 - 50)/2;
            self.rightButtonWidthConstraint.constant = (280 - 50)/2;
        }else if (VersionupdataStyle == FORCEUPDATAVERSION){
            self.buttonconstraint.constant = 0;
            self.leftButtonwidthConstraint.constant = 0;
            self.rightButtonWidthConstraint.constant = 280 - 30;
        }
        self.cancleButton.layer.borderWidth = 0.5;
        self.cancleButton.layer.borderColor = LineBackGroundColor.CGColor;
        self.updataContentLable.text = contentString;
        self.updataContentLable.numberOfLines = 0;
        self.updataContentLable.lineBreakMode = NSLineBreakByCharWrapping;
        delegate = theDelegate;
        CGRect versionRect = self.frame;
        versionRect.size.width = iPhoneWidth;
        versionRect.size.height = iPhoneHeight;
        self.frame = versionRect;
        return self;
    }
    return nil;
}

- (IBAction)cancelButtonaction:(id)sender {
    [delegate noUpdatabuttonAction];
}

- (IBAction)updataVersionButtonaction:(id)sender {
    [delegate updataButtonAction];
}
@end
