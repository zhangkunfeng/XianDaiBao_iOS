//
//  WithDrawDetailsViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/4.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef NS_ENUM(NSInteger, ShareDictType) {
    ShareDictType_iconImage = 0,
    ShareDictType_shareTitle,
    ShareDictType_shareDesc,
    ShareDictType_shareLink
};

@interface WithDrawDetailsViewController : BaseViewController<CustomUINavBarDelegate>
@property (nonatomic, copy)NSDictionary *userInfodict;
@property (weak, nonatomic) IBOutlet UIView *fundsafetyView;
@property (nonatomic, retain)NSString *titleString;             //标题
@property (nonatomic, retain)NSString *payMonryString;          //购买标的金额
@property (nonatomic, assign)NSString *bidNameString;           //标名

@property (nonatomic,assign)ShareDictType type;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;                 //操作标题
@property (weak, nonatomic) IBOutlet UILabel *tixianTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *finishIntroductionsLable;   //最后一步说明
@property (weak, nonatomic) IBOutlet UILabel *MoneNumberLable;            //金额多少
@property (weak, nonatomic) IBOutlet UILabel *NaneLeftLable;              //名字前面的lable
@property (weak, nonatomic) IBOutlet UILabel *nameStringLable;            //名字
@property (weak, nonatomic) IBOutlet UILabel *tenderBidIntroductionsLable;//投标说明

@property (weak, nonatomic) IBOutlet UILabel *middleIntroductionsLable;   //中间的说明 安全审核  银行打款
/**
 *  为了 xib 美观 特意拉出来
 */
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;//银行卡
@property (weak, nonatomic) IBOutlet UILabel *bankName; //招商银行
@property (weak, nonatomic) IBOutlet UILabel *bankNum;  //13243243243


@property (weak, nonatomic) IBOutlet UILabel *bankNameLable;
@property (weak, nonatomic) IBOutlet UILabel *bankCode;
@property (weak, nonatomic) IBOutlet UIView *BankView;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (nonatomic, assign)NSInteger pushNumber;//判断是从哪进来的  0 是投标  1  是体现 2充值
- (IBAction)withDrawTimeButtonAction:(id)sender;  //提交到账时间按钮事件
@property (weak, nonatomic) IBOutlet UIButton *withDrawTimebutton;//提交到账时间按钮
@property (weak, nonatomic) IBOutlet UIImageView *withDrawButtonLeftimage;
- (IBAction)FinishButtonAction:(id)sender;//完成按钮的点击方法

@end
