//
//  SelfSetingViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/8/26.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

typedef void(^backSetValue)(NSString *minMonth,NSString *maxMonth,NSString *minMoney);

@interface SelfSetingViewController : BaseViewController<CustomUINavBarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
}
@property (nonatomic, retain)NSString *isOpenAutoBid;//上个界面传下来的是否开启自动投标 0 为关闭 1为开启
@property (weak, nonatomic) IBOutlet UIButton *chooseMonthBtn;//选择月份按钮
@property (weak, nonatomic) IBOutlet UILabel *leftMonthLab;//最小借款月份
@property (weak, nonatomic) IBOutlet UILabel *rightMonthLab;//最大借款月份
@property (weak, nonatomic) IBOutlet UITextField *minAmount;//投标金额下限
@property (weak, nonatomic) IBOutlet UIView *MonthView;//借款期限的View
@property (weak, nonatomic) IBOutlet UIView *AmountView;//投标最低金额的View
@property (nonatomic, copy)backSetValue backAutoBidViewValue;//回调函数
@property (nonatomic, retain)NSString *minMonthString;//传值（最小借款月份）
@property (nonatomic, retain)NSString *maxMonthString;//传值（最大借款月份）
@property (nonatomic, retain)NSString *minAmountString;//传值（投标金额下限）
- (IBAction)saveButton:(id)sender;//保存修改按钮
//- (IBAction)autoBidruleButtonAction:(id)sender;//自动投标规则

@end
