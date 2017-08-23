//
//  RegisOneCNNViewController.h
//  BaiYangFinancial
//
//  Created by 民华 on 2017/6/29.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
typedef void(^backRefresh)(BOOL isRefresh);

@interface RegisOneCNNViewController : BaseViewController<CustomUINavBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *iPhoneNumberTextField;
//@property (weak, nonatomic) IBOutlet UILabel *isShowiPhoneNumberLableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isShowiPhoneNumberLableHeight;
@property (weak, nonatomic) IBOutlet UILabel *showiPhoneNumberLable;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *WeidaiProtocolButton;

- (IBAction)VerificationiPhoneButtonAction:(id)sender;
//获取验证码剩余的时间
@property (nonatomic,assign)int remainTime;
//记录跳转 便于判断
@property (nonatomic, assign)NSInteger pushviewNumber;

@property (nonatomic, copy)backRefresh isbackRefresh;//回去刷新

@property (nonatomic, retain)NSString *loginName;//登陆名

@property (nonatomic, strong)NSString *telePhone;
@end
