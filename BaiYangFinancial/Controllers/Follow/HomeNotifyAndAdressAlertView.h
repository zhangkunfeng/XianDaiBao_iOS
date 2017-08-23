//
//  AddAdressBookAlertView.h
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/6.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNotifyAndAdressAlertViewDelegate <NSObject>
- (void)cancleBtnClicked;//以后再说
- (void)importAdressBookPage;//好
@end

@interface HomeNotifyAndAdressAlertView : UIView{
    id<HomeNotifyAndAdressAlertViewDelegate> homeNotifyAndAdreessDelegate;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;//以后再说 & 知道了
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;//好

//Notify AutoLayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineCenterX;//0

- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)importAdressBookPage:(id)sender;

- (id)initWithHomeNotifyAndAdressAlertViewDelegate:(id<HomeNotifyAndAdressAlertViewDelegate>)theDelegate;

- (void)setHomePageNotificationDetailsView:(NSDictionary *)NotifictionDict;
- (void)setNotificaitonViewConstant;

@end
