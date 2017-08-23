//
//  TradePswViewController.h
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/7/24.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"

@interface TradePswViewController : BaseViewController<CustomUINavBarDelegate>

@property (nonatomic, retain)NSString *sedpassedString; //修改密码加密字
@property (weak, nonatomic) IBOutlet UITextField *oldPassworldTF;//原密码
@property (weak, nonatomic) IBOutlet UITextField *NewpassworldTF;//新密码
@property (weak, nonatomic) IBOutlet UITextField *againPassworldTF;//重复新密码
//- (IBAction)SaveButton:(id)sender;//保存密码按钮

@end
