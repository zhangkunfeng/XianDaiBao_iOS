//
//  AutoBidViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/17.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "AttributedLabel.h"

typedef void(^backRefreshView)(NSDictionary *autoSettingDict);

@interface AutoBidViewController : BaseViewController<CustomUINavBarDelegate,UIAlertViewDelegate>
{
    BOOL isOpen;
}
@property (weak, nonatomic) IBOutlet UILabel *RightnumberLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;//开动投标人数
//排行左部分  label
@property (weak, nonatomic) IBOutlet UILabel *partLeftLabel;
//排行右部分  label
@property (weak, nonatomic) IBOutlet UILabel *partRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *openLab;//关闭中
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;//投标开关
//@property (weak, nonatomic) IBOutlet UILabel *setBtn;//自助设置按钮 xiugai
@property (weak, nonatomic) IBOutlet UIView *autoSettingView;//自动设置 view 添加手势
@property (weak, nonatomic) IBOutlet UILabel *timeLimit;//投标期限 回传参数
@property (weak, nonatomic) IBOutlet UILabel *moneyLimit;//投标最低金额 回传参数

@property (weak, nonatomic) IBOutlet UILabel *leftMonth;
@property (weak, nonatomic) IBOutlet UILabel *rightMonth;
@property (weak, nonatomic) IBOutlet UILabel *minAmount;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollerView;
@property (weak, nonatomic) IBOutlet UIView *bidSetView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidSetHeightConstraint;//给投标设置的View约束添加属性
@property (weak, nonatomic) IBOutlet UILabel *topAutoNumberLable;//头部当前排队投标人数说明

@property (nonatomic, assign)NSString *isOpenswith;

@property (nonatomic, copy)backRefreshView backAssetsView;//回调前一个界面

//@property (weak, nonatomic) IBOutlet UILabel *aboutBidRuleBtn;//xiugai
@property (weak, nonatomic) IBOutlet UIView *aboutBidRule;//关于自动投标规则 View
- (IBAction)autoBidbuttonAction:(id)sender;

@property (nonatomic, assign)NSInteger pushNumber;

@end
