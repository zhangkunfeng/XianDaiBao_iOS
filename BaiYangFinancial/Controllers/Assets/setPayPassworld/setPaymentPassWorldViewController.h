//
//  setPaymentPassWorldViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/31.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef void(^isHavePaypassworld)(BOOL ishavePW);

@interface setPaymentPassWorldViewController : BaseViewController<CustomUINavBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *safeView;
@property (weak, nonatomic) IBOutlet UIView *iPhoneNumberView;

@property (copy, nonatomic) NSString * initalClassName;

//回调函数
@property (nonatomic, copy)isHavePaypassworld backUpView;
@property (nonatomic, strong) NSString *iPhoneCodeString;
@property (nonatomic, assign) NSInteger set;



@end
