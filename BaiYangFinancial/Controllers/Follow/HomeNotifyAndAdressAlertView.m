//
//  AddAdressBookAlertView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/6.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "HomeNotifyAndAdressAlertView.h"
@implementation HomeNotifyAndAdressAlertView

- (IBAction)cancelBtnClicked:(id)sender {
    if ( [homeNotifyAndAdreessDelegate respondsToSelector:@selector(cancleBtnClicked)]) {
        [homeNotifyAndAdreessDelegate cancleBtnClicked];
    }
}

- (IBAction)importAdressBookPage:(id)sender {
    if ([homeNotifyAndAdreessDelegate respondsToSelector:@selector(importAdressBookPage)]) {
        [homeNotifyAndAdreessDelegate importAdressBookPage];
    }
}

- (id)initWithHomeNotifyAndAdressAlertViewDelegate:(id<HomeNotifyAndAdressAlertViewDelegate>)theDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HomeNotifyAndAdressAlertView" owner:self options:nil] lastObject];
    if (self) {
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
        homeNotifyAndAdreessDelegate = theDelegate;
        return self;
    }
    return nil;
}

//Notification
- (void)setNotificaitonViewConstant{
    self.rightBtn.hidden = YES;
    self.iconImageTop.constant = 25;
    self.verticalLineCenterX.constant = 143;
    self.iconImageView.image = [UIImage imageNamed:@"Notify_icon"];
    [self.leftBtn setTitle:@"知道了" forState:UIControlStateNormal];
}

- (void)setHomePageNotificationDetailsView:(NSDictionary *)NotifictionDict{
        self.messageTitle.text = NotifictionDict[@"title"];
        self.contentLable.text = NotifictionDict[@"content"];
}
@end
