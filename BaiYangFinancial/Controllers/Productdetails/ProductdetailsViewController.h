//
//  ProductdetailsViewController.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/2.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//  产品详情

#import "BaseViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "QCSlideSwitchView.h"
#import "RedenveListViewController.h"

#import "ProjectDetailsViewController.h"          //项目详情
#import "ProjectContractMaterialsViewController.h"//项目合同、项目材料
//#import "DeatilWebViewController.h"             //项目详情、项目材料
#import "InvestedUserViewController.h"            //投资记录

@interface ProductdetailsViewController : BaseViewController<CustomUINavBarDelegate,QCSlideSwitchViewDelegate,UITextFieldDelegate>{
    dispatch_source_t _timingCountdownTimer;
    dispatch_source_t _progressTimer;
}
@property (nonatomic, copy)NSString *bidNameString;         //标的名称
@property (nonatomic, copy)NSString *productBid;            //产品id
@property (nonatomic, assign)BOOL isOptimizationBid;        //是否优选标的
@property (nonatomic, copy)NSDictionary *producDetailstDict;//产品详情字典

@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) ProjectDetailsViewController  *projectDetail;//项目详情
//@property (nonatomic, strong) DeatilWebViewController  *productMaterial; //项目材料
@property (nonatomic, strong) InvestedUserViewController *investedUser;    //投资记录
@property (nonatomic, strong) ProjectContractMaterialsViewController * projectContract;//项目合同
@property (nonatomic, strong) ProjectContractMaterialsViewController * projectMaterials;//项目材料
@property (weak, nonatomic) IBOutlet UILabel *touZnumLab;
@property (weak, nonatomic) IBOutlet UIView *investAmountBgView;

@end
